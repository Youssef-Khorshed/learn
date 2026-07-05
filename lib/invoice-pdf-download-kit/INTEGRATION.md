# Integration Guide

## 1. Flutter dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  dio:
  dartz:
  path_provider:
  file_picker: ^10.3.8
  open_file: ^3.5.11
  fluttertoast:   # success/error toasts in download_helper
  easy_localization:   # optional — toast strings
```

## 2. Dio requirement

Your HTTP client must support binary download with progress:

```dart
Future<Response> getBytesRequest({
  required String url,
  Map<String, String>? headers,
  void Function(int received, int total)? onReceiveProgress,
}) async {
  return dio.get(
    url,
    options: Options(
      responseType: ResponseType.bytes,
      headers: headers,
      followRedirects: true,
    ),
    onReceiveProgress: onReceiveProgress,
  );
}
```

**Important:** Custom headers (e.g. `Accept: application/pdf`, auth) must be **merged** with defaults, not replaced.

## 3. Android — MainActivity

Copy from `android/MainActivity.kt`:

- `downloadsChannel = "alma/downloads"`
- `savePdf` — reads `sourcePath` + optional `expectedSize`, writes via MediaStore
- `saveToDownloads` — rejects payloads `< 256` bytes
- `openUri` — opens `content://` PDF with mime type

Register in `configureFlutterEngine`:

```kotlin
when (call.method) {
    "savePdf" -> savePdf(call.arguments as Map<*, *>, result)
    "openUri" -> openUri(
        call.argument<String>("uri"),
        call.argument<String>("mimeType"),
        result
    )
    else -> result.notImplemented()
}
```

No `WRITE_EXTERNAL_STORAGE` permission needed (MediaStore / Scoped Storage).

**Rebuild required** after Kotlin changes: `flutter clean && flutter run`

## 4. iOS — Info.plist + AppDelegate

### Info.plist

Add inside `<dict>`:

```xml
<key>UIFileSharingEnabled</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

Saved files appear at: **Files → On My iPhone → [App Name] → Downloads**

### AppDelegate — QuickLook preview

Merge `ios/AppDelegate.reference.swift` into your `AppDelegate.swift`:

- Import `QuickLook`
- Register channel `alma/downloads` in `didInitializeImplicitFlutterEngine`
- Handle `openPdf` → `QLPreviewController` on saved file path
- Reject preview if file size `< 256` bytes

**Rebuild required** after Swift changes: `flutter clean && flutter run`

## 5. Usage example

```dart
final ok = await BookingInvoiceDownloadHelper.downloadAndShow(
  repository,
  invoiceId: 12345,
  fileName: 'CABS-Invoice-20260705',
);
```

Flow:
1. Download PDF bytes (retry up to 3×)
2. `prepareForSave()` validates header + trailer
3. Save to Downloads (Android) / Files app (iOS)
4. Verify written file size
5. Open preview (QuickLook iOS / system viewer Android)
6. Green long success toast

## 6. MethodChannel contract

| Method | Platform | Args | Returns |
|--------|----------|------|---------|
| `savePdf` | Android | `{ fileName, sourcePath, expectedSize? }` | `content://` URI |
| `openUri` | Android | `{ uri, mimeType? }` | `true` |
| `openPdf` | iOS | `{ path, mimeType? }` | `true` |

Channel name: **`alma/downloads`**

## 7. PDF validation before save

```dart
final bytes = BookingInvoicePdfBinary.prepareForSave(rawBytes);
// Returns null if missing %PDF, %%EOF, or size < 256
```

Never save raw API bytes without this check — prevents empty/corrupt PDFs.

## 8. Troubleshooting

| Symptom | Check |
|---------|-------|
| Toast success but empty PDF | `prepareForSave()` — trailer missing? Check logs |
| Android save fails silently | Log `[BookingInvoiceFileSaver] android save failed` |
| `TransactionTooLargeException` | Use `sourcePath`, not raw bytes in MethodChannel |
| iOS preview blank | File size >= 256? Rebuild after AppDelegate change |
| iOS file not in Files app | `UIFileSharingEnabled` in Info.plist? |
| Incomplete PDF | Downloader retries 3× — server may still be generating |
