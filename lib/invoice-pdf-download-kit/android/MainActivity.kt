package com.alma_app_v1

import android.content.ContentValues
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val downloadsChannel = "alma/downloads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            downloadsChannel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveCsv" -> saveCsv(call.arguments as Map<*, *>, result)
                "savePdf" -> savePdf(call.arguments as Map<*, *>, result)
                "openUri" -> openUri(
                    call.argument<String>("uri"),
                    call.argument<String>("mimeType"),
                    result
                )
                else -> result.notImplemented()
            }
        }
    }

    private fun saveCsv(args: Map<*, *>, result: MethodChannel.Result) {
        val name = args["fileName"] as? String ?: "offline_booking_template.csv"
        val bytes = args["bytes"] as? ByteArray
        if (bytes == null) {
            result.error("invalid_bytes", "No file bytes provided", null)
            return
        }
        saveToDownloads(
            fileName = name,
            mimeType = "text/csv",
            bytes = bytes,
            result = result,
        )
    }

    private fun savePdf(args: Map<*, *>, result: MethodChannel.Result) {
        val name = args["fileName"] as? String ?: "invoice.pdf"
        val sourcePath = args["sourcePath"] as? String
        val bytes = args["bytes"] as? ByteArray

        val payload = when {
            !sourcePath.isNullOrBlank() -> {
                try {
                    val file = File(sourcePath)
                    val bytes = file.readBytes()
                    val expectedSize = args["expectedSize"] as? Int
                    if (expectedSize != null && bytes.size != expectedSize) {
                        result.error(
                            "size_mismatch",
                            "PDF size mismatch: expected $expectedSize got ${bytes.size}",
                            null,
                        )
                        return
                    }
                    bytes
                } catch (e: Exception) {
                    result.error("invalid_path", e.message, null)
                    return
                }
            }
            bytes != null -> bytes
            else -> {
                result.error("invalid_bytes", "No file bytes provided", null)
                return
            }
        }

        saveToDownloads(
            fileName = name,
            mimeType = "application/pdf",
            bytes = payload,
            result = result,
        )
    }

    private fun saveToDownloads(
        fileName: String,
        mimeType: String,
        bytes: ByteArray,
        result: MethodChannel.Result,
    ) {
        if (bytes.isEmpty() || bytes.size < 256) {
            result.error("invalid_bytes", "PDF payload is empty or incomplete", null)
            return
        }
        try {
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, mimeType)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                    put(MediaStore.Downloads.IS_PENDING, 1)
                }
            }
            val resolver = applicationContext.contentResolver
            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: throw IllegalStateException("Could not create Downloads entry")
            resolver.openOutputStream(uri)?.use { output ->
                output.write(bytes)
                output.flush()
            } ?: throw IllegalStateException("Could not open Downloads stream")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                values.clear()
                values.put(MediaStore.Downloads.IS_PENDING, 0)
                resolver.update(uri, values, null, null)
            }
            result.success(uri.toString())
        } catch (e: Exception) {
            result.error("save_failed", e.message, null)
        }
    }

    private fun openUri(
        uriValue: String?,
        mimeType: String?,
        result: MethodChannel.Result,
    ) {
        if (uriValue.isNullOrBlank()) {
            result.error("invalid_uri", "No file uri provided", null)
            return
        }

        try {
            val type = mimeType?.takeIf { it.isNotBlank() } ?: "text/csv"
            val intent = Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(Uri.parse(uriValue), type)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            startActivity(Intent.createChooser(intent, "Open file"))
            result.success(true)
        } catch (e: Exception) {
            result.error("open_failed", e.message, null)
        }
    }
}
