// Merge into ios/Runner/AppDelegate.swift
// Requires: import QuickLook
// Register inside didInitializeImplicitFlutterEngine (FlutterImplicitEngineDelegate)

import QuickLook

// --- Channel registration ---
let channel = FlutterMethodChannel(
  name: "alma/downloads",
  binaryMessenger: engineBridge.applicationRegistrar.messenger()
)
channel.setMethodCallHandler { [weak self] call, result in
  switch call.method {
  case "openPdf":
    guard
      let args = call.arguments as? [String: Any],
      let path = args["path"] as? String,
      !path.isEmpty
    else {
      result(FlutterError(code: "invalid_path", message: "No file path provided", details: nil))
      return
    }
    self?.previewPdf(at: path, result: result)
  default:
    result(FlutterMethodNotImplemented)
  }
}

// --- Preview helper (add as AppDelegate methods + PdfPreviewDataSource class) ---
// - Validates file exists and size >= 256 bytes before QuickLook
// - Presents QLPreviewController with share / save options
// See full reference: ios/AppDelegate.reference.swift
