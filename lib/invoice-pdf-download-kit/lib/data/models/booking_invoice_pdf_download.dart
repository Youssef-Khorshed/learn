class BookingInvoicePdfDownload {
  final List<int> bytes;
  final String? suggestedFileName;
  final int? contentLength;
  final bool downloadComplete;

  const BookingInvoicePdfDownload({
    required this.bytes,
    this.suggestedFileName,
    this.contentLength,
    this.downloadComplete = false,
  });

  @override
  String toString() =>
      'BookingInvoicePdfDownload(suggestedFileName: $suggestedFileName, '
      'bytesLength: ${bytes.length}, contentLength: $contentLength, '
      'downloadComplete: $downloadComplete)';
}
