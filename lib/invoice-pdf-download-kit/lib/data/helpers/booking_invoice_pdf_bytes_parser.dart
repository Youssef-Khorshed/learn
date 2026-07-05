import 'dart:convert';

import 'package:alma_app/features/invoice_my_alma/data/helpers/booking_invoice_pdf_binary.dart';

class BookingInvoicePdfParseResult {
  final List<int>? bytes;
  final String? suggestedFileName;
  final String? error;
  final String? followUrl;

  const BookingInvoicePdfParseResult({
    this.bytes,
    this.suggestedFileName,
    this.error,
    this.followUrl,
  });
}

class BookingInvoicePdfBytesParser {
  BookingInvoicePdfBytesParser._();

  static List<int>? normalize(dynamic data) {
    return BookingInvoicePdfBinary.toUint8List(data);
  }

  static bool isPdf(List<int> bytes) =>
      BookingInvoicePdfBinary.extractPdfBytes(bytes) != null;

  static List<int>? extractPdfBytes(
    List<int> bytes, {
    bool requireTrailer = true,
  }) =>
      BookingInvoicePdfBinary.extractPdfBytes(
        bytes,
        requireTrailer: requireTrailer,
      );

  static bool hasPdfHeader(List<int> bytes) =>
      BookingInvoicePdfBinary.hasPdfHeader(bytes);

  static bool hasPdfTrailer(List<int> bytes) =>
      BookingInvoicePdfBinary.hasPdfTrailer(bytes);

  static bool isPdfContentType(String? contentType) {
    final value = contentType?.toLowerCase() ?? '';
    return value.contains('application/pdf') ||
        value.contains('application/octet-stream');
  }

  static bool isHtmlLoginPage(List<int> bytes) {
    if (bytes.isEmpty) return false;
    try {
      final text = utf8.decode(bytes, allowMalformed: true).toLowerCase();
      return text.contains('<!doctype html') &&
          (text.contains('login') || text.contains('unauthenticated'));
    } catch (_) {
      return false;
    }
  }

  static String? apiErrorMessage(List<int> bytes) {
    try {
      final text = utf8.decode(bytes);
      final decoded = jsonDecode(text);
      if (decoded is Map) {
        final message = decoded['message']?.toString();
        if (message != null && message.trim().isNotEmpty) return message;
      }
    } catch (_) {}
    return null;
  }

  static String? notReadyPdfMessage(List<int> bytes) {
    try {
      final text = utf8.decode(bytes, allowMalformed: true).toLowerCase();
      if (text.contains('failed to load pdf') ||
          text.contains('please wait') ||
          text.contains('generating')) {
        return apiErrorMessage(bytes) ?? 'Failed to load PDF file.';
      }
    } catch (_) {}
    return null;
  }

  static bool isIgnorableNotReadyMessage(String message) {
    final lower = message.toLowerCase();
    return lower.contains('failed to load pdf') ||
        lower.contains('please wait') ||
        lower.contains('generating');
  }

  static bool isRetryableError(String error) {
    final lower = error.toLowerCase();
    return lower.contains('invalid invoice pdf') ||
        lower.contains('incomplete invoice pdf') ||
        lower.contains('failed to load pdf') ||
        lower.contains('failed to download invoice pdf');
  }

  static BookingInvoicePdfParseResult parseResponse({
    required List<int> bytes,
    String? contentType,
    int? invoiceId,
    int? contentLength,
    bool downloadComplete = false,
  }) {
    final pdfBytes = _resolvePdfBytes(
      bytes,
      contentType: contentType,
      contentLength: contentLength,
      downloadComplete: downloadComplete,
    );
    if (pdfBytes != null) {
      return BookingInvoicePdfParseResult(bytes: pdfBytes);
    }

    final base64Pdf = _decodeBase64PdfBody(bytes);
    if (base64Pdf != null) {
      return BookingInvoicePdfParseResult(bytes: base64Pdf);
    }

    if (isHtmlLoginPage(bytes)) {
      return const BookingInvoicePdfParseResult(
        error: 'Authentication required',
      );
    }

    try {
      final text = utf8.decode(bytes);
      final decoded = jsonDecode(text);
      if (decoded is Map) {
        final parsed = _parseJsonMap(
          decoded,
          invoiceId: invoiceId,
        );
        if (parsed != null) return parsed;
      }
    } catch (_) {}

    final apiError = apiErrorMessage(bytes);
    if (apiError != null && !isIgnorableNotReadyMessage(apiError)) {
      return BookingInvoicePdfParseResult(error: apiError);
    }

    final notReady = notReadyPdfMessage(bytes);
    if (notReady != null) {
      return BookingInvoicePdfParseResult(error: notReady);
    }

    if (hasPdfHeader(bytes) &&
        _isTruncated(bytes, contentLength, downloadComplete)) {
      return const BookingInvoicePdfParseResult(
        error: 'Incomplete invoice PDF',
      );
    }

    return const BookingInvoicePdfParseResult(
      error: 'Invalid invoice PDF response',
    );
  }

  static List<int>? _resolvePdfBytes(
    List<int> bytes, {
    String? contentType,
    int? contentLength,
    bool downloadComplete = false,
  }) {
    final withTrailer = extractPdfBytes(bytes, requireTrailer: true);
    if (withTrailer != null) return withTrailer;

    if (!downloadComplete) return null;
    if (contentLength != null && bytes.length < contentLength) return null;

    if (isPdfContentType(contentType) || hasPdfHeader(bytes)) {
      return extractPdfBytes(bytes, requireTrailer: false);
    }

    return null;
  }

  static bool _isTruncated(
    List<int> bytes,
    int? contentLength,
    bool downloadComplete,
  ) {
    if (downloadComplete) return false;
    if (contentLength != null) {
      final gap = contentLength - bytes.length;
      if (gap > 512) return true;
    }
    return false;
  }

  static BookingInvoicePdfParseResult? _parseJsonMap(
    Map decoded, {
    int? invoiceId,
  }) {
    final ok = decoded['status'] == true || decoded['success'] == true;
    final message = decoded['message']?.toString();
    final data = decoded['data'];

    if (data is Map) {
      final fileName = _readFileName(data) ??
          (invoiceId != null ? 'invoice_$invoiceId.pdf' : null);

      final base64 = _readBase64(data);
      if (base64 != null) {
        try {
          final pdfBytes = BookingInvoicePdfBinary.extractPdfBytes(
            base64Decode(base64),
          );
          if (pdfBytes != null) {
            return BookingInvoicePdfParseResult(
              bytes: pdfBytes,
              suggestedFileName: fileName,
            );
          }
        } catch (_) {}
      }

      final url = _readDownloadUrl(data);
      if (url != null && url.isNotEmpty) {
        return BookingInvoicePdfParseResult(
          followUrl: url,
          suggestedFileName: fileName,
        );
      }
    }

    if (!ok &&
        message != null &&
        message.trim().isNotEmpty &&
        !isIgnorableNotReadyMessage(message)) {
      return BookingInvoicePdfParseResult(error: message);
    }

    return null;
  }

  static List<int>? _decodeBase64PdfBody(List<int> bytes) {
    try {
      final text = utf8.decode(bytes).trim();
      if (text.length < 16 || text.contains('{')) return null;
      final decoded = base64Decode(text);
      return BookingInvoicePdfBinary.extractPdfBytes(decoded);
    } catch (_) {
      return null;
    }
  }

  static String? _readBase64(Map data) {
    for (final key in ['pdf', 'file', 'content', 'base64', 'pdf_base64']) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  static String? _readDownloadUrl(Map data) {
    for (final key in ['url', 'download_url', 'file_url', 'link']) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  static String? _readFileName(Map data) {
    for (final key in ['file_name', 'filename', 'name']) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }
}
