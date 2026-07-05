# File index — mapping to Alma app

| Kit file | Original path in Alma---Flutter |
|----------|-----------------------------------|
| `lib/data/datasources/booking_invoice_pdf_downloader.dart` | `lib/features/invoice_my_alma/data/datasources/booking_invoice_pdf_downloader.dart` |
| `lib/data/helpers/booking_invoice_pdf_binary.dart` | `lib/features/invoice_my_alma/data/helpers/booking_invoice_pdf_binary.dart` |
| `lib/data/helpers/booking_invoice_pdf_bytes_parser.dart` | `lib/features/invoice_my_alma/data/helpers/booking_invoice_pdf_bytes_parser.dart` |
| `lib/data/models/booking_invoice_pdf_download.dart` | `lib/features/invoice_my_alma/data/models/booking_invoice_pdf_download.dart` |
| `lib/presentation/helpers/booking_invoice_download_helper.dart` | `lib/features/invoice_my_alma/presentation/helpers/booking_invoice_download_helper.dart` |
| `lib/presentation/helpers/booking_invoice_file_saver.dart` | `lib/features/invoice_my_alma/presentation/helpers/booking_invoice_file_saver.dart` |
| `lib/presentation/helpers/booking_invoice_file_opener.dart` | `lib/features/invoice_my_alma/presentation/helpers/booking_invoice_file_opener.dart` |
| `android/MainActivity.kt` | `android/app/src/main/kotlin/com/example/alma_app/MainActivity.kt` |
| `ios/Info.plist.snippet.xml` | `ios/Runner/Info.plist` (keys only) |
| `ios/AppDelegate.reference.swift` | `ios/Runner/AppDelegate.swift` (QuickLook part only) |

## External dependencies (not included — project-specific)

- `DioFactory.getBytesRequest` → `lib/core/network/dio_consumer.dart`
- `BookingInvoiceEndpoints.download` → `lib/core/constants/endpoints/booking_invoice_endpoints.dart`
- `BookingInvoiceRepository` → `lib/features/invoice_my_alma/data/repositories/`
- `ToastService` / `AppColor` → `lib/core/services/` + `lib/core/theme/`
- `InvoiceCubit` caller → `lib/features/reports/invoice/presentation/cubit/invoice_cubit.dart`

## Key APIs added in latest sync

| API | File | Purpose |
|-----|------|---------|
| `prepareForSave()` | `booking_invoice_pdf_binary.dart` | Validate PDF before write |
| `isValidForSave()` | `booking_invoice_pdf_binary.dart` | Downloader retry gate |
| `_writeVerifiedBytes()` | `booking_invoice_file_saver.dart` | Flush + size match check |
| `_showSavedSuccessToast()` | `booking_invoice_download_helper.dart` | Green long toast |
| `openPdf` | iOS AppDelegate | QuickLook preview from saved path |
| `expectedSize` | Android savePdf | Temp file size verification |
