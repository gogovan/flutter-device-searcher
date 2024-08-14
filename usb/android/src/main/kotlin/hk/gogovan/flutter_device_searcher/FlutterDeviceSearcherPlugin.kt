package hk.gogovan.flutter_device_searcher

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/** FlutterLabelPrinterPlugin */
class FlutterDeviceSearcherPlugin : FlutterPlugin, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var usbReadChannel: EventChannel

    private var usbSearcher: UsbSearcher? = null
    private var usbReadStreamHandler: UsbReadStreamHandler? = null
    private var methodHandler: FlutterDeviceSearcherMethodHandler? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val context = flutterPluginBinding.applicationContext

        usbSearcher = UsbSearcher(context)
        usbReadStreamHandler = UsbReadStreamHandler(usbSearcher)
        
        methodHandler = FlutterDeviceSearcherMethodHandler(context, usbSearcher)

        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "hk.gogovan.flutter_device_searcher")
        channel.setMethodCallHandler(methodHandler)

        usbReadChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "hk.gogovan.flutter_device_searcher.usbRead")
        usbReadChannel.setStreamHandler(usbReadStreamHandler)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)

        usbReadStreamHandler?.close()
        usbReadStreamHandler = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        usbSearcher?.setCurrentActivity(binding.activity)
        usbReadStreamHandler?.setCurrentActivity(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        usbReadStreamHandler?.setCurrentActivity(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        usbReadStreamHandler?.setCurrentActivity(binding.activity)
    }

    override fun onDetachedFromActivity() {
        usbReadStreamHandler?.setCurrentActivity(null)
    }
}
