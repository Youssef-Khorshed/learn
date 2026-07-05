import Flutter
import UIKit
import QuickLook

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var previewDataSource: PdfPreviewDataSource?

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

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
          result(
            FlutterError(
              code: "invalid_path",
              message: "No file path provided",
              details: nil
            )
          )
          return
        }
        self?.previewPdf(at: path, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func previewPdf(at path: String, result: @escaping FlutterResult) {
    guard FileManager.default.fileExists(atPath: path) else {
      result(FlutterError(code: "file_not_found", message: "PDF not found at path", details: path))
      return
    }

    let fileSize = (try? FileManager.default.attributesOfItem(atPath: path)[.size] as? NSNumber)?
      .intValue ?? 0
    if fileSize < 256 {
      result(FlutterError(code: "empty_file", message: "PDF file is empty or incomplete", details: fileSize))
      return
    }

    DispatchQueue.main.async { [weak self] in
      guard let self = self, let presenter = self.topViewController() else {
        result(FlutterError(code: "no_presenter", message: "Could not present PDF preview", details: nil))
        return
      }

      let dataSource = PdfPreviewDataSource(url: URL(fileURLWithPath: path))
      self.previewDataSource = dataSource

      let controller = QLPreviewController()
      controller.dataSource = dataSource
      controller.modalPresentationStyle = .formSheet
      presenter.present(controller, animated: true) { result(true) }
    }
  }

  private func topViewController() -> UIViewController? {
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
      var top = root
      while let presented = top.presentedViewController { top = presented }
      return top
    }
    return window?.rootViewController
  }
}

private final class PdfPreviewDataSource: NSObject, QLPreviewControllerDataSource {
  private let url: URL
  init(url: URL) { self.url = url }
  func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }
  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    url as QLPreviewItem
  }
}
