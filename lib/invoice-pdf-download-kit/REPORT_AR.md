# تقرير مفصل: تحميل وحفظ فواتير PDF على الموبايل

> **المشروع:** Alma Flutter — feature `invoice_my_alma`  
> **التاريخ:** يوليو 2026  
> **الهدف:** تنزيل PDF من الـ API، انتظار اكتمال كل الـ bytes، ثم حفظ الملف في مكان يظهر للمستخدم على Android و iOS.

---

## 1. ملخص المشكلة الأصلية

| المشكلة | التأثير |
|---------|---------|
| السيرفر يرجع HTTP 200 مع ~870–892 KB | يبدو أن التحميل نجح |
| أحياناً الـ PDF ناقص أو بدون `%%EOF` | المعاينة داخل التطبيق تفشل |
| الملف كان يُحفظ في **sandbox** التطبيق | المستخدم لا يجده في Downloads / Files |
| تمرير ~892 KB كـ `ByteArray` عبر `MethodChannel` | **Android Binder limit ~1 MB** → الحفظ يفشل بصمت |
| Toast نجاح رغم أن الملف في مجلد مخفي | المستخدم يظن أن الحفظ لم يحدث |

**القرار النهائي:** إلغاء المعاينة داخل التطبيق → **تحميل + حفظ تلقائي** في مجلد عام (Android Downloads / iOS Files).

---

## 2. مخطط التدفق الكامل (End-to-End)

```
[المستخدم يضغط Download]
        │
        ▼
[InvoiceCubit.downloadInvoice]
        │
        ▼
[BookingInvoiceDownloadHelper._fetchAndSave]
        │
        ▼
[Repository.downloadInvoicePdf]
        │
        ▼
┌───────────────────────────────────────────────────────┐
│  BookingInvoicePdfDownloader                          │
│  ① GET /api/invoices/{id}/download                    │
│  ② Accept: application/pdf                            │
│  ③ onReceiveProgress → تتبع received / total          │
│  ④ Dio يرجّع body كامل كـ bytes                      │
│  ⑤ _isDownloadComplete() → downloadComplete = true    │
│  ⑥ Parser يتحقق من %PDF + حجم + truncation           │
│  ⑦ Retry حتى 3 مرات إذا الرد غير صالح                │
└───────────────────────────────────────────────────────┘
        │
        ▼
[BookingInvoicePdfBinary.extractPdfBytes]
        │
        ▼
┌───────────────────────────────────────────────────────┐
│  BookingInvoiceFileSaver                              │
│  Android: temp file → MethodChannel → MediaStore     │
│  iOS:     Downloads / Documents/Downloads             │
│  Fallback: FilePicker save dialog                     │
└───────────────────────────────────────────────────────┘
        │
        ▼
[تحقق: الملف موجود + length > 0]
        │
        ▼
[Android: فتح PDF من content:// URI]
        │
        ▼
[Toast: "تم الحفظ في Downloads" / "Files → Alma → Downloads"]
```

---

## 3. المرحلة الأولى: انتظار اكتمال تحميل كل الـ Bytes

### 3.1 طلب HTTP

**الملف:** `lib/data/datasources/booking_invoice_pdf_downloader.dart`

```dart
static const _pdfAcceptHeader = {'Accept': 'application/pdf'};

final result = await dioFactory.getBytesRequest(
  url: url,
  headers: _pdfAcceptHeader,
  onReceiveProgress: (received, total) {
    progressReceived = received;
    progressTotal = total;
    // ...
  },
);
```

**لماذا `Accept: application/pdf`؟**  
السيرفر أحياناً يرجّع HTML أو JSON في المحاولة الأولى. طلب PDF صريح يزيد احتمال الحصول على bytes صحيحة (نفس سلوك Postman عند إضافة الـ header).

### 3.2 Dio يُسلّم الـ body كاملاً

Dio مع `ResponseType.bytes` ينتظر حتى ينتهي الـ stream ويجمع كل الـ chunks في `response.data`.  
**لا نعتمد على Content-Length وحده** — نستخدم أيضاً `onReceiveProgress`.

### 3.3 متى نعتبر التحميل مكتملاً؟

**الدالة:** `_isDownloadComplete()`

```dart
static bool _isDownloadComplete({
  required int bodyLength,
  required int progressReceived,
  required int progressTotal,
  int? contentLength,
}) {
  // 1) Progress وصل 100% والـ body >= total
  if (progressTotal > 0 && progressReceived >= progressTotal) {
    return bodyLength >= progressTotal;
  }
  // 2) Content-Length header موجود والـ body وصل له
  if (contentLength != null && bodyLength >= contentLength) {
    return true;
  }
  // 3) Chunked response بدون Content-Length — Dio سلّم body غير فارغ
  return progressTotal <= 0 && contentLength == null && bodyLength > 0;
}
```

| الحالة | `downloadComplete` |
|--------|-------------------|
| `progress = 892364/892364` و `body.length = 892364` | ✅ true |
| `Content-Length: 892364` و body نفس الحجم | ✅ true |
| Chunked بدون length header | ✅ true إذا body > 0 |
| body أصغر من Content-Length بـ > 512 byte | ❌ truncated |

### 3.4 التحقق من صحة PDF

**الملف:** `lib/data/helpers/booking_invoice_pdf_binary.dart`

| الفحص | الوصف |
|-------|-------|
| `%PDF` header | بايتات `0x25 0x50 0x44 0x46` — بداية أي PDF |
| `%%EOF` trailer | في آخر 64 KB — اختياري إذا `downloadComplete = true` |
| حد أدنى 256 byte | رفض الردود الفارغة/الصغيرة |
| Truncation | فرق > 512 byte عن Content-Length = ناقص |

**تساهل مقصود:** السيرفر أحياناً يرجّع PDF بدون `%%EOF` أو ناقص بـ 17 byte — ما زلنا نحفظه للمستخدم.

### 3.5 Retry (حتى 3 محاولات)

```dart
static const _maxAttempts = 3;
static const _retryDelay = Duration(milliseconds: 1500);
```

**نعيد المحاولة إذا:**
- خطأ قابل لإعادة المحاولة (`Invalid invoice PDF`, `Incomplete`, …)
- أو لا يوجد `%PDF` header
- أو حجم < 256 byte

**نتوقف عن Retry إذا:**
- `%PDF` موجود **و** الحجم ≥ 256 — حتى بدون trailer

### 3.6 Parser للردود غير المباشرة

**الملف:** `lib/data/helpers/booking_invoice_pdf_bytes_parser.dart`

يدعم:
- PDF خام في body
- Base64 داخل JSON
- Redirect URL في JSON → follow-up GET
- HTML login page → `Authentication required`
- رسائل API (`generating`, `please wait`) → retry

---

## 4. المرحلة الثانية: حفظ الملف على الجهاز

### 4.1 تجهيز الـ bytes للحفظ

**الملف:** `lib/presentation/helpers/booking_invoice_download_helper.dart`

```dart
final bytesToSave =
    BookingInvoicePdfBinary.extractPdfBytes(download.bytes) ??
        Uint8List.fromList(download.bytes);
```

- نحاول استخراج slice يبدأ من `%PDF`
- إذا فشل → نحفظ الـ body كاملاً (fallback)

### 4.2 Android — **التركية الأساسية (MethodChannel + Temp File)**

#### المشكلة

تمرير ~892 KB كـ `ByteArray` عبر Flutter `MethodChannel`:

```
Dart  ──[892 KB bytes]──►  Android Native
         ↑
    Binder transaction buffer ≈ 1 MB
    → TransactionTooLargeException أو فشل صامت
```

ملفات CSV صغيرة (~KB) كانت تعمل. PDF الفاتورة (~892 KB) **قريبة جداً من الحد**.

#### الحل: Temp File + Path فقط

**Flutter (`booking_invoice_file_saver.dart`):**

```dart
// 1) اكتب الـ PDF في temp directory (داخل Flutter — بدون MethodChannel limit)
final tempDir = await getTemporaryDirectory();
tempFile = File('${tempDir.path}/$fileName');
await tempFile.writeAsBytes(data, flush: true);

// 2) أرسل **مسار الملف فقط** (string صغير ~100 byte)
final uri = await _channel.invokeMethod<String>('savePdf', {
  'fileName': fileName,
  'sourcePath': tempFile.path,  // ← التركية
});

// 3) احذف temp file
await tempFile.delete();
```

**Android Kotlin (`MainActivity.kt`):**

```kotlin
private fun savePdf(args: Map<*, *>, result: MethodChannel.Result) {
    val sourcePath = args["sourcePath"] as? String
    val payload = File(sourcePath).readBytes()  // يقرأ من القرص

    saveToDownloads(
        fileName = name,
        mimeType = "application/pdf",
        bytes = payload,
        result = result,
    )
}
```

#### MediaStore → مجلد Downloads العام

```kotlin
private fun saveToDownloads(fileName, mimeType, bytes, result) {
    val values = ContentValues().apply {
        put(MediaStore.Downloads.DISPLAY_NAME, fileName)
        put(MediaStore.Downloads.MIME_TYPE, mimeType)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
            put(MediaStore.Downloads.IS_PENDING, 1)  // يكتب أولاً ثم ينشر
        }
    }
    val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
    resolver.openOutputStream(uri)?.use { it.write(bytes) }
    // IS_PENDING = 0 → يظهر في تطبيق Files / Downloads
    result.success(uri.toString())  // content://...
}
```

**لماذا MediaStore وليس `WRITE_EXTERNAL_STORAGE`؟**  
Google Play policy — التطبيق **حذف** صلاحيات التخزين الخارجي. MediaStore (Scoped Storage) هو الطريقة المعتمدة من Android 10+.

**MethodChannel:** `alma/downloads`  
**Methods:** `savePdf`, `saveCsv`, `openUri`

#### بعد الحفظ على Android

```dart
if (saveResult.locationKind == BookingInvoiceSaveLocation.publicDownloads) {
  await BookingInvoiceFileOpener.open(saveResult.location);
}
```

يفتح chooser لعرض PDF → المستخدم يتأكد أن الملف في Downloads.

`openUri` على Android:

```kotlin
Intent(Intent.ACTION_VIEW)
    .setDataAndType(Uri.parse(uriValue), "application/pdf")
    .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
```

### 4.3 iOS

**لا MethodChannel للحفظ** — نكتب مباشرة:

1. `getDownloadsDirectory()` (path_provider)
2. `Documents/Downloads`
3. `getApplicationDocumentsDirectory()`

**Info.plist (مهم لظهور الملفات في Files app):**

```xml
<key>UIFileSharingEnabled</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

**مسار المستخدم:** Files → On My iPhone → Alma → Downloads

### 4.4 Fallback — System Save Dialog

إذا فشل الحفظ التلقائي (Android أو iOS):

```dart
await FilePicker.platform.saveFile(
  fileName: fileName,
  bytes: data,
  type: FileType.custom,
  allowedExtensions: const ['pdf'],
);
```

المستخدم يختار المكان بنفسه — **ضمان أخير** أن الملف يُحفظ.

### 4.5 التحقق بعد الحفظ

```dart
if (!saveResult.isContentUri) {
  final savedFile = File(saveResult.location);
  if (!await savedFile.exists() || await savedFile.length() <= 0) {
    return failure;  // لا نُظهر toast نجاح كاذب
  }
}
```

`content://` على Android — MediaStore يضمن الكتابة؛ لا نفحص `File.exists`.

---

## 5. جدول الملفات والمسؤوليات

| الملف | الطبقة | المسؤولية |
|-------|--------|-----------|
| `booking_invoice_pdf_downloader.dart` | Data | GET + progress + retry + parse |
| `booking_invoice_pdf_binary.dart` | Data | `%PDF`, `%%EOF`, truncation |
| `booking_invoice_pdf_bytes_parser.dart` | Data | JSON/base64/redirect/errors |
| `booking_invoice_pdf_download.dart` | Model | bytes + fileName + flags |
| `booking_invoice_download_helper.dart` | Presentation | orchestration + toast |
| `booking_invoice_file_saver.dart` | Presentation | temp file + MediaStore / iOS dirs |
| `booking_invoice_file_opener.dart` | Presentation | open content:// or file path |
| `MainActivity.kt` | Android Native | MediaStore + openUri |
| `Info.plist` | iOS | UIFileSharingEnabled |

---

## 6. Dependencies

```yaml
dependencies:
  dio:
  dartz:
  path_provider:
  file_picker: ^10.3.8
  open_file: ^3.5.11
  flutter:
    sdk: flutter
```

---

## 7. Debug Logs

| Log | المعنى |
|-----|--------|
| `[InvoicePdfDownload] body=892347 progress=892347/892364 downloadComplete=true` | التحميل اكتمل |
| `[InvoicePdfDownload] hasHeader=true hasTrailer=false` | PDF بدون EOF — قد يُحفظ |
| `[InvoicePdfDownload] retry 1/3` | إعادة محاولة |
| `[BookingInvoiceFileSaver] android downloads uri=content://...` | نجح MediaStore |
| `[BookingInvoiceFileSaver] android save failed: ...` | فشل — سيُجرّب FilePicker |
| `[BookingInvoiceDownload] saved location=... kind=publicDownloads` | نجاح كامل |

---

## 8. أين يجد المستخدم الملف؟

| Platform | المكان |
|----------|--------|
| **Android** | Files → Downloads (أو PDF viewer يفتح تلقائياً) |
| **iOS** | Files → On My iPhone → Alma → Downloads |
| **Fallback** | حيث اختاره المستخدم في save dialog |

---

## 9. خطوات التكامل في مشروع جديد

1. انسخ مجلد `invoice-pdf-download-kit/lib/` إلى مشروعك
2. أضف snippet Kotlin من `android/MainActivity.kt` (أو دمج `savePdf` + `saveToDownloads`)
3. أضف `Info.plist` keys على iOS
4. تأكد أن `DioFactory.getBytesRequest` يرجّع `ResponseType.bytes` ولا يقطع body
5. `flutter clean && flutter run` — **إجباري** بعد تغيير Kotlin

---

## 10. الدروس المستفادة (Lessons Learned)

1. **لا تمرّر ملفات كبيرة عبر MethodChannel** — استخدم temp file + path
2. **لا تعتمد على Content-Type header** — تحقق من bytes (`%PDF`)
3. **لا تعتبر sandbox = حفظ ناجح** — المستخدم يريد Downloads العام
4. **Retry مع Accept header** — السيرفر أحياناً يحتاج محاولتين
5. **تحقق من %%EOF قبل الحفظ** — PDF بدون trailer = ملف فاضي في المعاينة
6. **لا تستخدم printing package للمعاينة على iOS** — افتح الملف المحفوظ بـ QuickLook
7. **تحقق من حجم الملف بعد الكتابة** — `savedLength == bytes.length`

---

## 11. التحديثات الأخيرة (يوليو 2026)

### المشاكل اللي ظهرت

| المشكلة | السبب |
|---------|-------|
| PDF فاضي أو ناقص | حفظ bytes قبل اكتمال التحميل أو بدون `%%EOF` |
| معاينة iOS مش شغالة | package `printing` مش موثوق — محتاج native preview |
| Toast أحمر/قصير رغم الحفظ | لون ومدة الـ toast مش مظبوطين |

### الحل

1. **`prepareForSave()`** — يرفض أي PDF بدون `%PDF` + `%%EOF` + 256 byte على الأقل
2. **`_writeVerifiedBytes()`** — يكتب الملف ويتأكد إن الحجم مطابق 100%
3. **iOS QuickLook** — `openPdf` في AppDelegate يفتح الملف المحفوظ (مش bytes من الذاكرة)
4. **Android size check** — `expectedSize` يتأكد إن temp file كامل قبل MediaStore
5. **Retry 3 مرات** — لحد ما السيرفر يرجّع PDF كامل
6. **Toast أخضر طويل** — `_showSavedSuccessToast()` عند الحفظ الناجح

### الملفات الجديدة في الـ Kit

| ملف | وصف |
|-----|-----|
| `ios/AppDelegate.reference.swift` | QuickLook preview كامل |
| `ios/AppDelegate.snippet.swift` | snippet للدمج |
| `LINKEDIN_POST_AR.md` | ملخص المشكلة والحل للنشر |

5. **تحقق post-save** — `exists()` + `length > 0` قبل toast النجاح
6. **Fallback UI** — FilePicker أفضل من فشل صامت

---

*هذا التقرير يغطي الحل من لحظة بدء HTTP request حتى ظهور الملف في Downloads/Files.*
