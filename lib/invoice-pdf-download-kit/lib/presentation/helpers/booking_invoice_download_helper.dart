import 'dart:io';

import 'package:alma_app/core/services/message_service.dart';
import 'package:alma_app/core/theme/app_colors.dart';
import 'package:alma_app/features/invoice_my_alma/data/helpers/booking_invoice_pdf_binary.dart';
import 'package:alma_app/features/invoice_my_alma/data/helpers/booking_invoice_pdf_bytes_parser.dart';
import 'package:alma_app/features/invoice_my_alma/data/models/booking_invoice_pdf_download.dart';
import 'package:alma_app/features/invoice_my_alma/data/repositories/booking_invoice_repository.dart';
import 'package:alma_app/features/invoice_my_alma/presentation/helpers/booking_invoice_file_opener.dart';
import 'package:alma_app/features/invoice_my_alma/presentation/helpers/booking_invoice_file_saver.dart';
import 'package:alma_app/features/invoice_my_alma/presentation/models/booking_invoice_download_result.dart';
import 'package:alma_app/features/invoice_my_alma/presentation/models/booking_invoice_download_target.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingInvoiceDownloadHelper {
  BookingInvoiceDownloadHelper._();

  /// GET /api/invoices/{id}/download → save PDF to device.
  static Future<bool> downloadAndShow(
    BookingInvoiceRepository repository, {
    required int invoiceId,
    String? fileName,
  }) async {
    final result = await _fetchAndSave(
      repository,
      BookingInvoiceDownloadTarget(
        invoiceId: invoiceId,
        fileName: fileName,
      ),
      showToast: true,
    );
    return result.success;
  }

  /// Saves each invoice PDF to device, one after another.
  static Future<BookingInvoiceDownloadResult> downloadManyAndShow(
    BookingInvoiceRepository repository,
    List<BookingInvoiceDownloadTarget> targets, {
    void Function(BookingInvoiceDownloadTarget target)? onTargetStart,
    void Function(BookingInvoiceDownloadTarget target)? onTargetEnd,
  }) async {
    if (targets.isEmpty) {
      return const BookingInvoiceDownloadResult();
    }

    var successCount = 0;
    var failCount = 0;
    String? lastError;
    String? lastSavedName;
    final showPerItemToast = targets.length == 1;

    for (final target in targets) {
      onTargetStart?.call(target);
      final step = await _fetchAndSave(
        repository,
        target,
        showToast: showPerItemToast,
      );
      onTargetEnd?.call(target);
      if (step.success) {
        successCount++;
        lastSavedName = step.savedName;
      } else {
        failCount++;
        lastError = step.error;
      }
    }

    final downloadResult = BookingInvoiceDownloadResult(
      successCount: successCount,
      failCount: failCount,
      lastError: lastError,
      lastSavedName: lastSavedName,
    );
    if (targets.length > 1) {
      _showBulkResultToast(downloadResult, targets.length);
    }
    return downloadResult;
  }

  static Future<({bool success, String? error, String? savedName})>
      _fetchAndSave(
    BookingInvoiceRepository repository,
    BookingInvoiceDownloadTarget target, {
    required bool showToast,
  }) async {
    final result = await repository.downloadInvoicePdf(target.invoiceId);

    return result.fold(
      (error) async {
        _logDownload(target: target, error: error);
        if (showToast) {
          ToastService.showToast(
            message: error,
            backgroundColor: AppColor.error,
          );
        }
        return (success: false, error: error, savedName: null);
      },
      (download) async {
        _logDownload(target: target, download: download);
        final resolvedName =
            _resolveFileName(target, download.suggestedFileName);
        final bytesToSave = BookingInvoicePdfBinary.prepareForSave(download.bytes);

        if (bytesToSave == null) {
          const message = 'Incomplete invoice PDF';
          if (showToast) {
            ToastService.showToast(
              message: message,
              backgroundColor: AppColor.error,
            );
          }
          return (success: false, error: message, savedName: null);
        }

        final saveResult = await BookingInvoiceFileSaver.savePdfBytes(
          bytes: bytesToSave,
          fileName: resolvedName,
        );
        if (saveResult == null) {
          final message = 'invoice.save_failed'.tr();
          if (showToast) {
            ToastService.showToast(
              message: message,
              backgroundColor: AppColor.error,
            );
          }
          return (success: false, error: message, savedName: null);
        }

        if (!saveResult.isContentUri) {
          final savedFile = File(saveResult.location);
          final savedLength = await savedFile.length();
          if (!await savedFile.exists() ||
              savedLength != bytesToSave.length) {
            final message = 'invoice.save_failed'.tr();
            if (showToast) {
              ToastService.showToast(
                message: message,
                backgroundColor: AppColor.error,
              );
            }
            return (success: false, error: message, savedName: null);
          }
        }

        if (kDebugMode) {
          debugPrint(
            '[BookingInvoiceDownload] saved location=${saveResult.location} '
            'kind=${saveResult.locationKind} name=${saveResult.fileName}',
          );
        }

        if (showToast) {
          await BookingInvoiceFileOpener.open(saveResult.location);
          _showSavedSuccessToast(_savedToastMessage(saveResult));
        }

        return (success: true, error: null, savedName: saveResult.fileName);
      },
    );
  }

  static void _logDownload({
    required BookingInvoiceDownloadTarget target,
    BookingInvoicePdfDownload? download,
    String? error,
  }) {
    if (!kDebugMode) return;
    if (download != null) {
      debugPrint(
        '[BookingInvoiceDownload] target=$target download=$download '
        'isPdf=${BookingInvoicePdfBytesParser.isPdf(download.bytes)}',
      );
      return;
    }
    debugPrint(
      '[BookingInvoiceDownload] target=$target error=$error',
    );
  }

  static String _resolveFileName(
    BookingInvoiceDownloadTarget target,
    String? suggestedFileName,
  ) {
    final suggested = suggestedFileName?.trim();
    if (suggested != null && suggested.isNotEmpty) {
      return _fileStem(suggested);
    }
    final label = target.fileName?.trim();
    if (label != null && label.isNotEmpty) return _fileStem(label);
    return 'invoice_${target.invoiceId}';
  }

  static String _fileStem(String value) {
    var trimmed = value.trim().isEmpty ? 'invoice' : value.trim();
    while (trimmed.toLowerCase().endsWith('.pdf')) {
      trimmed = trimmed.substring(0, trimmed.length - 4);
    }
    return trimmed;
  }

  static String _displayPdfName(String stem) {
    return stem.toLowerCase().endsWith('.pdf') ? stem : '$stem.pdf';
  }

  static String _savedToastMessage(BookingInvoiceSaveResult result) {
    final name = _displayPdfName(result.fileName);
    switch (result.locationKind) {
      case BookingInvoiceSaveLocation.publicDownloads:
        return 'invoice.download_saved_to_downloads'.tr(
          namedArgs: {'name': name},
        );
      case BookingInvoiceSaveLocation.appDownloads:
        return 'invoice.download_saved_to_files_app'.tr(
          namedArgs: {'name': name},
        );
      case BookingInvoiceSaveLocation.userSelected:
        return 'invoice.download_saved_to_device'.tr(
          namedArgs: {'name': name},
        );
    }
  }

  static void _showSavedSuccessToast(String message) {
    ToastService.showToast(
      message: message,
      backgroundColor: AppColor.green,
      duration: Toast.LENGTH_LONG,
    );
  }

  static void _showBulkResultToast(
    BookingInvoiceDownloadResult result,
    int total,
  ) {
    if (result.successCount > 0 && result.failCount == 0) {
      _showSavedSuccessToast(
        'invoice.download_completed'.tr(
          namedArgs: {'count': result.successCount.toString()},
        ),
      );
      return;
    }

    if (result.successCount > 0 && result.failCount > 0) {
      ToastService.showToast(
        message: 'invoice.download_partial'.tr(
          namedArgs: {
            'success': result.successCount.toString(),
            'total': total.toString(),
          },
        ),
        backgroundColor: AppColor.error,
      );
      return;
    }

    if (result.failCount > 0 && result.successCount == 0) {
      ToastService.showToast(
        message: result.lastError ?? 'invoice.download_failed'.tr(),
        backgroundColor: AppColor.error,
      );
    }
  }
}
