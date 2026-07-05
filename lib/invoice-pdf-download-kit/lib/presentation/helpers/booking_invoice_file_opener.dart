import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';

class BookingInvoiceFileOpener {
  BookingInvoiceFileOpener._();

  static const _channel = MethodChannel('alma/downloads');

  static Future<bool> open(
    String location, {
    String mimeType = 'application/pdf',
  }) async {
    try {
      if (Platform.isAndroid && location.startsWith('content://')) {
        await _channel.invokeMethod<bool>('openUri', {
          'uri': location,
          'mimeType': mimeType,
        });
        return true;
      }
      if (Platform.isIOS) {
        final opened = await _channel.invokeMethod<bool>('openPdf', {
          'path': location,
          'mimeType': mimeType,
        });
        return opened == true;
      }
      final result = await OpenFile.open(location, type: mimeType);
      return result.type == ResultType.done;
    } catch (_) {
      return false;
    }
  }
}
