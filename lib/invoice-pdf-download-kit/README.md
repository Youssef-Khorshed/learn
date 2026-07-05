# Invoice PDF Download Kit

Standalone extract from **Alma Flutter** — download invoice PDFs from an API, validate completeness, save to a user-visible location, and preview on Android & iOS.

## Documentation

| File | Description |
|------|-------------|
| **[REPORT_AR.md](./REPORT_AR.md)** | **تقرير مفصل بالعربي** — full solution walkthrough |
| **[LINKEDIN_POST_AR.md](./LINKEDIN_POST_AR.md)** | **بوست LinkedIn بالعربي** — problem & solution summary |
| **[INTEGRATION.md](./INTEGRATION.md)** | Step-by-step integration guide |

## What's inside

```
invoice-pdf-download-kit/
├── REPORT_AR.md
├── LINKEDIN_POST_AR.md
├── README.md
├── INTEGRATION.md
├── FILES.md
├── pubspec.dependencies.yaml
├── lib/
│   ├── data/
│   │   ├── datasources/booking_invoice_pdf_downloader.dart
│   │   ├── helpers/
│   │   │   ├── booking_invoice_pdf_binary.dart      ← prepareForSave()
│   │   │   └── booking_invoice_pdf_bytes_parser.dart
│   │   └── models/booking_invoice_pdf_download.dart
│   └── presentation/helpers/
│       ├── booking_invoice_download_helper.dart     ← green long success toast
│       ├── booking_invoice_file_saver.dart          ← verified writes
│       └── booking_invoice_file_opener.dart         ← QuickLook iOS / openUri Android
├── android/
│   └── MainActivity.kt       ← MediaStore savePdf + size check + openUri
└── ios/
    ├── Info.plist.snippet.xml
    ├── AppDelegate.snippet.swift
    └── AppDelegate.reference.swift   ← QuickLook openPdf preview
```

## Key fixes (latest)

| Issue | Fix |
|-------|-----|
| Empty / incomplete PDF files | `prepareForSave()` — requires `%PDF` + `%%EOF` + min 256 bytes |
| Partial file writes | Verified write: saved size must equal source bytes |
| Android Binder ~1 MB limit | Temp file → pass `sourcePath` only to Kotlin |
| iOS no preview | Native **QuickLook** (`openPdf`) from saved file path |
| Printing package unreliable | Removed — preview opens the saved file directly |
| False success toasts | Post-save size check; green long toast only on real success |

## Quick start

1. Copy `lib/` files into your project (adjust `package:` imports)
2. Merge `android/MainActivity.kt` into your MainActivity
3. Merge `ios/AppDelegate.reference.swift` into AppDelegate + add Info.plist keys
4. Add dependencies from `pubspec.dependencies.yaml`
5. `flutter clean && flutter run`

## Origin

Extracted from `lib/features/invoice_my_alma/` in AlmaTravelV8 Flutter app.
