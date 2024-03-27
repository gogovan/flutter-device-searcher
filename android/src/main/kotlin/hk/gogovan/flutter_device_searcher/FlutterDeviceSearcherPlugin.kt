package hk.gogovan.flutter_device_searcher

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

/** FlutterLabelPrinterPlugin */
class FlutterDeviceSearcherPlugin : FlutterPlugin {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var usbSearcher: UsbSearcher? = null
    private var methodHandler: FlutterDeviceSearcherMethodHandler? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val context = flutterPluginBinding.applicationContext

        usbSearcher = UsbSearcher(context)
        methodHandler = FlutterDeviceSearcherMethodHandler(context, usbSearcher)

        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "hk.gogovan.flutter_device_searcher")
        channel.setMethodCallHandler(methodHandler)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
