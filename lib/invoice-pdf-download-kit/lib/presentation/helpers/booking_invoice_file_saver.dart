import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:alma_app/features/invoice_my_alma/data/helpers/booking_invoice_pdf_binary.dart';

/// Where the invoice PDF was written.
enum BookingInvoiceSaveLocation {
  /// Public Downloads (Android MediaStore content URI).
  publicDownloads,

  /// App-accessible folder (iOS Files app: On My iPhone → Alma → Downloads).
  appDownloads,
  userSelected,
}

class BookingInvoiceSaveResult {
  const BookingInvoiceSaveResult({
    required this.location,
    required this.fileName,
    required this.locationKind,
  });

  final String location;
  final String fileName;
  final BookingInvoiceSaveLocation locationKind;

  bool get isContentUri => location.startsWith('content://');
}

class BookingInvoiceFileSaver {
  BookingInvoiceFileSaver._();

  static const _channel = MethodChannel('alma/downloads');

  static Future<BookingInvoiceSaveResult?> savePdfBytes({
    required List<int> bytes,
    required String fileName,
  }) async {
    final data = BookingInvoicePdfBinary.prepareForSave(bytes);
    if (data == null) return null;

    final name = _sanitizeFileName(fileName);

    if (Platform.isAndroid) {
      final android = await _saveAndroidDownloads(data: data, fileName: name);
      if (android != null) return android;
    } else {
      final ios = await _saveToAppDirectories(data: data, fileName: name);
      if (ios != null) return ios;
    }

    return _saveViaSystemDialog(data: data, fileName: name);
  }

  static Future<BookingInvoiceSaveResult?> _saveAndroidDownloads({
    required Uint8List data,
    required String fileName,
  }) async {
    File? tempFile;
    try {
      final tempDir = await getTemporaryDirectory();
      tempFile = File('${tempDir.path}/$fileName');
      if (!await _writeVerifiedBytes(tempFile, data)) return null;

      final uri = await _channel.invokeMethod<String>('savePdf', {
        'fileName': fileName,
        'sourcePath': tempFile.path,
        'expectedSize': data.length,
      });
      if (uri == null || uri.isEmpty) return null;

      if (kDebugMode) {
        debugPrint(
          '[BookingInvoiceFileSaver] android downloads uri=$uri '
          'bytes=${data.length}',
        );
      }
      return BookingInvoiceSaveResult(
        location: uri,
        fileName: fileName,
        locationKind: BookingInvoiceSaveLocation.publicDownloads,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BookingInvoiceFileSaver] android save failed: $e');
      }
      return null;
    } finally {
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  static Future<BookingInvoiceSaveResult?> _saveToAppDirectories({
    required Uint8List data,
    required String fileName,
  }) async {
    for (final directory in await _directoryCandidates()) {
      try {
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        final file = await _uniqueFile(directory, fileName);
        if (!await _writeVerifiedBytes(file, data)) continue;

        if (kDebugMode) {
          debugPrint(
            '[BookingInvoiceFileSaver] saved ${file.path} (${data.length} bytes)',
          );
        }
        return BookingInvoiceSaveResult(
          location: file.path,
          fileName: fileName,
          locationKind: BookingInvoiceSaveLocation.appDownloads,
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[BookingInvoiceFileSaver] failed ${directory.path}: $e');
        }
      }
    }
    return null;
  }

  static Future<BookingInvoiceSaveResult?> _saveViaSystemDialog({
    required Uint8List data,
    required String fileName,
  }) async {
    try {
      final path = await FilePicker.platform.saveFile(
        fileName: fileName,
        bytes: data,
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
      );
      if (path == null || path.isEmpty) return null;

      if (kDebugMode) {
        debugPrint('[BookingInvoiceFileSaver] user saved to $path');
      }
      return BookingInvoiceSaveResult(
        location: path,
        fileName: fileName,
        locationKind: BookingInvoiceSaveLocation.userSelected,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BookingInvoiceFileSaver] save dialog failed: $e');
      }
      return null;
    }
  }

  static Future<List<Directory>> _directoryCandidates() async {
    final directories = <Directory>[];

    if (Platform.isIOS) {
      try {
        final docs = await getApplicationDocumentsDirectory();
        directories.add(Directory('${docs.path}/Downloads'));
      } catch (_) {}
    }

    try {
      final downloads = await getDownloadsDirectory();
      if (downloads != null) directories.add(downloads);
    } catch (_) {}

    try {
      directories.add(await getApplicationDocumentsDirectory());
    } catch (_) {}

    return directories;
  }

  static Future<bool> _writeVerifiedBytes(File file, Uint8List data) async {
    RandomAccessFile? handle;
    try {
      if (await file.exists()) {
        await file.delete();
      }
      handle = await file.open(mode: FileMode.writeOnly);
      await handle.writeFrom(data);
      await handle.flush();
      await handle.close();
      handle = null;
      return await file.exists() && await file.length() == data.length;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BookingInvoiceFileSaver] write failed ${file.path}: $e');
      }
      return false;
    } finally {
      await handle?.close();
    }
  }

  static String _sanitizeFileName(String name) {
    var trimmed = name.trim().isEmpty ? 'invoice' : name.trim();
    while (trimmed.toLowerCase().endsWith('.pdf')) {
      trimmed = trimmed.substring(0, trimmed.length - 4);
    }
    final withExt = '$trimmed.pdf';
    return withExt.replaceAll(RegExp(r'[^\w.\-]'), '_');
  }

  static Future<File> _uniqueFile(Directory dir, String name) async {
    var candidate = File('${dir.path}/$name');
    if (!await candidate.exists()) return candidate;

    final stem = _fileStem(name);
    var index = 1;
    while (await candidate.exists()) {
      candidate = File('${dir.path}/${stem}_$index.pdf');
      index++;
    }
    return candidate;
  }

  static String _fileStem(String name) {
    var stem = name;
    while (stem.toLowerCase().endsWith('.pdf')) {
      stem = stem.substring(0, stem.length - 4);
    }
    return stem.isEmpty ? 'invoice' : stem;
  }
}
