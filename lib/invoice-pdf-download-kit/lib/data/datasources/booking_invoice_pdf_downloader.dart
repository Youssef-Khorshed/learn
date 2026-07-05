import 'package:alma_app/core/constants/endpoints/booking_invoice_endpoints.dart';
import 'package:alma_app/core/network/dio_consumer.dart';
import 'package:alma_app/features/invoice_my_alma/data/datasources/booking_invoice_data_source.dart';
import 'package:alma_app/features/invoice_my_alma/data/helpers/booking_invoice_pdf_binary.dart';
import 'package:alma_app/features/invoice_my_alma/data/helpers/booking_invoice_pdf_bytes_parser.dart';
import 'package:alma_app/features/invoice_my_alma/data/models/booking_invoice_pdf_download.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Downloads invoice PDF via [DioFactory.getBytesRequest]:
/// GET [BookingInvoiceEndpoints.download]
class BookingInvoicePdfDownloader {
  final DioFactory dioFactory;

  const BookingInvoicePdfDownloader(this.dioFactory);

  static const _pdfAcceptHeader = {'Accept': 'application/pdf'};
  static const _maxAttempts = 3;
  static const _retryDelay = Duration(milliseconds: 1500);

  Future<Either<String, BookingInvoicePdfDownload>> download({
    required int invoiceId,
    InvoiceDownloadProgressCallback? onProgress,
    Duration? receiveTimeout,
  }) async {
    final url = BookingInvoiceEndpoints.download(id: invoiceId);
    Either<String, BookingInvoicePdfDownload>? lastResult;

    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      lastResult = await _downloadFromUrl(
        url: url,
        invoiceId: invoiceId,
        onProgress: onProgress,
        receiveTimeout: receiveTimeout,
        attempt: attempt,
      );

      final shouldRetry = lastResult.fold(
        (error) => BookingInvoicePdfBytesParser.isRetryableError(error),
        (download) {
          if (!BookingInvoicePdfBinary.isValidForSave(download.bytes)) {
            return true;
          }
          return false;
        },
      );

      if (!shouldRetry || attempt == _maxAttempts) {
        return lastResult;
      }

      if (kDebugMode) {
        debugPrint(
          '[InvoicePdfDownload] invoiceId=$invoiceId retry $attempt/$_maxAttempts',
        );
      }
      await Future.delayed(_retryDelay);
    }

    return lastResult ?? const Left('Failed to download invoice PDF');
  }

  Future<Either<String, BookingInvoicePdfDownload>> _downloadFromUrl({
    required String url,
    required int invoiceId,
    InvoiceDownloadProgressCallback? onProgress,
    Duration? receiveTimeout,
    bool isFollowUp = false,
    int attempt = 1,
  }) async {
    var lastReportedPercent = -1;
    var progressReceived = 0;
    var progressTotal = 0;

    final result = await dioFactory.getBytesRequest(
      url: url,
      headers: _pdfAcceptHeader,
      followRedirects: !isFollowUp,
      onReceiveProgress: (received, total) {
        progressReceived = received;
        progressTotal = total;
        if (total <= 0) return;
        final callback = onProgress;
        if (callback == null) return;
        final percent = ((received / total) * 100).round().clamp(0, 100);
        if (percent == lastReportedPercent) return;
        lastReportedPercent = percent;
        callback(percent);
      },
    );

    return result.fold(
      Left.new,
      (response) => _parseResponse(
        response: response,
        invoiceId: invoiceId,
        onProgress: onProgress,
        receiveTimeout: receiveTimeout,
        attempt: attempt,
        progressReceived: progressReceived,
        progressTotal: progressTotal,
      ),
    );
  }

  Future<Either<String, BookingInvoicePdfDownload>> _parseResponse({
    required Response response,
    required int invoiceId,
    InvoiceDownloadProgressCallback? onProgress,
    Duration? receiveTimeout,
    int attempt = 1,
    int progressReceived = 0,
    int progressTotal = 0,
  }) async {
    final bytes = BookingInvoicePdfBytesParser.normalize(response.data);
    if (bytes == null || bytes.isEmpty) {
      return const Left('Failed to download invoice PDF');
    }

    final headerContentLength = _parseContentLength(
      response.headers.value('content-length'),
    );
    final contentType = response.headers.value('content-type');

    // Dio already delivers the full body; progress confirms nothing was cut off.
    final downloadComplete = _isDownloadComplete(
      bodyLength: bytes.length,
      progressReceived: progressReceived,
      progressTotal: progressTotal,
      contentLength: headerContentLength,
    );

    if (kDebugMode) {
      debugPrint(
        '[InvoicePdfDownload] attempt=$attempt invoiceId=$invoiceId '
        'contentType=$contentType body=${bytes.length} '
        'contentLength=$headerContentLength '
        'progress=$progressReceived/$progressTotal '
        'downloadComplete=$downloadComplete '
        'hasHeader=${BookingInvoicePdfBinary.hasPdfHeader(bytes)} '
        'hasTrailer=${BookingInvoicePdfBinary.hasPdfTrailer(bytes)}',
      );
    }

    final parsed = BookingInvoicePdfBytesParser.parseResponse(
      bytes: bytes,
      contentType: contentType,
      invoiceId: invoiceId,
      contentLength: headerContentLength,
      downloadComplete: downloadComplete,
    );

    if (parsed.error != null) {
      return Left(parsed.error!);
    }

    final followUrl = parsed.followUrl;
    if (followUrl != null && followUrl.isNotEmpty) {
      return _downloadFromUrl(
        url: followUrl,
        invoiceId: invoiceId,
        onProgress: onProgress,
        receiveTimeout: receiveTimeout,
        isFollowUp: true,
        attempt: attempt,
      );
    }

    final pdfBytes = parsed.bytes;
    if (pdfBytes == null || pdfBytes.isEmpty) {
      return const Left('Invalid invoice PDF response');
    }

    return Right(
      BookingInvoicePdfDownload(
        bytes: pdfBytes,
        contentLength: headerContentLength,
        downloadComplete: downloadComplete,
        suggestedFileName: parsed.suggestedFileName ??
            _fileNameFromHeaders(response.headers, invoiceId),
      ),
    );
  }

  static bool _isDownloadComplete({
    required int bodyLength,
    required int progressReceived,
    required int progressTotal,
    int? contentLength,
  }) {
    if (progressTotal > 0 && progressReceived >= progressTotal) {
      return bodyLength >= progressTotal;
    }
    if (contentLength != null && bodyLength >= contentLength) {
      return true;
    }
    // Chunked responses may omit Content-Length; body is all Dio received.
    return progressTotal <= 0 && contentLength == null && bodyLength > 0;
  }

  static int? _parseContentLength(String? header) {
    if (header == null || header.isEmpty) return null;
    return int.tryParse(header.trim());
  }

  String _fileNameFromHeaders(Headers headers, int invoiceId) {
    final cd = headers.value('content-disposition');
    if (cd != null && cd.isNotEmpty) {
      final utf8 = RegExp(r"filename\*=UTF-8''([^;]+)", caseSensitive: false)
          .firstMatch(cd);
      if (utf8 != null) {
        return Uri.decodeComponent(utf8.group(1)!.trim());
      }
      final plain =
          RegExp(r'filename="?([^";]+)"?', caseSensitive: false).firstMatch(cd);
      final name = plain?.group(1)?.trim();
      if (name != null && name.isNotEmpty) return name;
    }
    return 'invoice_$invoiceId.pdf';
  }
}
