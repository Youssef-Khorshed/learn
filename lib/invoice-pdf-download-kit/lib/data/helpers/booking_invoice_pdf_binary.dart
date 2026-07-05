import 'dart:convert';
import 'dart:typed_data';

class BookingInvoicePdfBinary {
  BookingInvoicePdfBinary._();

  static const _minPdfSize = 256;
  static const minSaveSize = 256;
  static const _trailerScanWindow = 65536;

  static Uint8List? toUint8List(dynamic data) {
    if (data == null) return null;
    if (data is Uint8List) return data;
    if (data is List<int>) return Uint8List.fromList(data);
    if (data is String) return Uint8List.fromList(latin1.encode(data));
    if (data is List) {
      final ints = data.whereType<int>().toList(growable: false);
      if (ints.isEmpty || ints.length != data.length) return null;
      return Uint8List.fromList(ints);
    }
    return null;
  }

  /// Extracts PDF bytes when [%PDF] header is present.
  /// [requireTrailer] — when false, accepts after a confirmed full download.
  static Uint8List? extractPdfBytes(
    List<int> bytes, {
    bool requireTrailer = true,
  }) {
    final start = _findPdfStart(bytes);
    if (start == null) return null;

    final slice = start == 0 && bytes is Uint8List
        ? bytes
        : Uint8List.fromList(bytes.sublist(start));
    if (slice.length < _minPdfSize) return null;
    if (requireTrailer && !_hasPdfTrailer(slice)) return null;
    return slice;
  }

  static bool hasPdfHeader(List<int> bytes) => _findPdfStart(bytes) != null;

  static bool hasPdfTrailer(List<int> bytes) {
    final start = _findPdfStart(bytes);
    if (start == null) return false;
    final slice = bytes.sublist(start);
    return _hasPdfTrailer(
      slice is Uint8List ? slice : Uint8List.fromList(slice),
    );
  }

  /// Validates and returns a copy of PDF bytes safe to write to disk.
  static Uint8List? prepareForSave(List<int> bytes) {
    final pdf = extractPdfBytes(bytes, requireTrailer: true);
    if (pdf == null || pdf.length < minSaveSize) return null;
    return Uint8List.fromList(pdf);
  }

  static bool isValidForSave(List<int> bytes) => prepareForSave(bytes) != null;

  /// True when the HTTP body looks like a usable PDF.
  /// [downloadComplete] — [onReceiveProgress] reported received == total.
  static bool isUsablePdf(
    List<int> bytes, {
    int? contentLength,
    bool downloadComplete = false,
  }) {
    if (!hasPdfHeader(bytes)) return false;

    if (extractPdfBytes(bytes) != null) return true;

    if (!downloadComplete &&
        _isTruncated(bytes, contentLength: contentLength)) {
      return false;
    }

    return extractPdfBytes(bytes, requireTrailer: false) != null;
  }

  static bool isCompletePdf(
    List<int> bytes, {
    int? contentLength,
    bool downloadComplete = false,
  }) {
    return isUsablePdf(
      bytes,
      contentLength: contentLength,
      downloadComplete: downloadComplete,
    );
  }

  static bool _isTruncated(List<int> bytes, {int? contentLength}) {
    if (contentLength != null) {
      final gap = contentLength - bytes.length;
      // Server sometimes omits a few trailing bytes; still save for the user.
      if (gap > 512) return true;
    }
    return false;
  }

  static int? _findPdfStart(List<int> bytes) {
    if (bytes.length < 4) return null;
    if (_hasPdfHeader(bytes, 0)) return 0;
    if (bytes.length >= 7 &&
        bytes[0] == 0xef &&
        bytes[1] == 0xbb &&
        bytes[2] == 0xbf &&
        _hasPdfHeader(bytes, 3)) {
      return 3;
    }
    final limit = bytes.length < 1024 ? bytes.length - 4 : 1024;
    for (var i = 1; i <= limit; i++) {
      if (_hasPdfHeader(bytes, i)) return i;
    }
    return null;
  }

  static bool _hasPdfHeader(List<int> bytes, int offset) {
    if (offset + 3 >= bytes.length) return false;
    return bytes[offset] == 0x25 &&
        bytes[offset + 1] == 0x50 &&
        bytes[offset + 2] == 0x44 &&
        bytes[offset + 3] == 0x46;
  }

  static bool _hasPdfTrailer(List<int> bytes) {
    if (bytes.length < 128) return false;

    final start = bytes.length > _trailerScanWindow
        ? bytes.length - _trailerScanWindow
        : 0;
    for (var i = bytes.length - 5; i >= start; i--) {
      if (bytes[i] == 0x25 &&
          bytes[i + 1] == 0x25 &&
          bytes[i + 2] == 0x45 &&
          bytes[i + 3] == 0x4f &&
          bytes[i + 4] == 0x46) {
        return true;
      }
    }

    final tail = utf8.decode(
      bytes.sublist(start),
      allowMalformed: true,
    );
    return tail.contains('%%EOF');
  }
}
