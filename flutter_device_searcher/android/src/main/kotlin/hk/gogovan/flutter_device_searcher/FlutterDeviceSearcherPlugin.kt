package hk.gogovan.flutter_device_searcher

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterDeviceSearcherPlugin */
class FlutterDeviceSearcherPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var bluetoothScanChannel: EventChannel

    private var bluetoothSearcher: BluetoothSearcher? = null
    private var bluetoothScanStreamHandler: BluetoothScanStreamHandler? = null
    private var methodHandler: FlutterDeviceSearcherMethodHandler? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val context = flutterPluginBinding.applicationContext

        bluetoothSearcher = BluetoothSearcher(context)
        bluetoothScanStreamHandler = BluetoothScanStreamHandler(bluetoothSearcher)
        methodHandler = FlutterDeviceSearcherMethodHandler(bluetoothSearcher)

        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "hk.gogovan.flutter_device_searcher")
        channel.setMethodCallHandler(methodHandler)

        bluetoothScanChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "hk.gogovan.flutter_device_searcher.bluetoothScan")
        bluetoothScanChannel.setStreamHandler(bluetoothScanStreamHandler)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)

        bluetoothSearcher?.close()
        bluetoothSearcher = null

        bluetoothScanStreamHandler?.close()
        bluetoothScanStreamHandler = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        bluetoothScanStreamHandler?.setCurrentActivity(binding.activity)

        binding.addActivityResultListener { requestCode, resultCode, _ ->
            bluetoothSearcher?.handleActivityResult(
                requestCode,
                resultCode
            )
            true
        }
        binding.addRequestPermissionsResultListener { requestCode, permissions, grantResults ->
            bluetoothSearcher?.handlePermissionResult(
                requestCode,
                permissions,
                grantResults
            )
            true
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        bluetoothScanStreamHandler?.setCurrentActivity(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        bluetoothScanStreamHandler?.setCurrentActivity(binding.activity)
    }

    override fun onDetachedFromActivity() {
        bluetoothScanStreamHandler?.setCurrentActivity(null)
    }
}
