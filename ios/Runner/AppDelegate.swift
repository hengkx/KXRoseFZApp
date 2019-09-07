import UIKit
import Flutter

enum ChannelName {
    static let battery = "rose.hengkx.com/qq"
    static let login = "rose.hengkx.com/login"
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    private var qqLoginUrl:String?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        
        let batteryChannel = FlutterMethodChannel(name: ChannelName.battery,
                                                  binaryMessenger: controller.binaryMessenger)
        batteryChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard call.method == "getQQLoginUrl" else {
                result(FlutterMethodNotImplemented)
                return
            }
            result(self?.qqLoginUrl);
        })
        
        let loginChannel = FlutterEventChannel(name: ChannelName.login,
                                                  binaryMessenger: controller.binaryMessenger)
        loginChannel.setStreamHandler(self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        qqLoginUrl = url.absoluteString
        
        guard let eventSink = eventSink else {
            return false
        }
        
        eventSink(qqLoginUrl)
        return true
    }
}
