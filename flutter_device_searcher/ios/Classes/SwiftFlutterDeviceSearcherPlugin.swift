import Flutter
import UIKit
import CoreBluetooth

public class SwiftFlutterDeviceSearcherPlugin: NSObject, FlutterPlugin {    
    let log = Log()

    let handler = BluetoothScanStreamHandler()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "hk.gogovan.flutter_device_searcher", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterDeviceSearcherPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let bluetoothScanChannel = FlutterEventChannel(name: "hk.gogovan.flutter_device_searcher.bluetoothScan", binaryMessenger: registrar.messenger())
        
        instance.handler.setup()
        bluetoothScanChannel.setStreamHandler(instance.handler)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "hk.gogovan.flutter_device_searcher.stopSearchBluetooth") {
            handler.stopScanning()
            result(true)
        } else if (call.method == "hk.gogovan.flutter_device_searcher.connectBluetooth") {
            if let args = call.arguments as? [String:Any],
               let address = args["address"] as? String {
                handler.connect(address, {
                    result(true)
                }, { error in
                    result(error)
                })
            } else {
                result(FlutterError(code: "1000", message: "Unable to extract arguments", details: Thread.callStackSymbols.joined(separator: "\n")))
            }
        } else if (call.method == "hk.gogovan.flutter_device_searcher.disconnectBluetooth") {
            if (handler.disconnect()) {
                result(true)
            } else {
                result(FlutterError(code: "1005", message: "Device not connected.", details: Thread.callStackSymbols.joined(separator: "\n")))
            }
        } else if (call.method == "hk.gogovan.flutter_device_searcher.read") {
            result(true)
        } else if (call.method == "hk.gogovan.flutter_device_searcher.write") {
            result(true)
        } else {
            result(FlutterError(code: "1000", message: "Unknown call method received: \(call.method)", details: Thread.callStackSymbols.joined(separator: "\n")))
        }
    }

}
