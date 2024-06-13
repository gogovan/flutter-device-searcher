package hk.gogovan.flutter_device_searcher

import android.content.Context
import android.graphics.BitmapFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.lang.Integer.max
import java.lang.Integer.min
import java.util.Locale

class FlutterDeviceSearcherMethodHandler(
    private val context: Context,
    private val usbSearcher: UsbSearcher?,
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "hk.gogovan.device_searcher.searchUsb" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        val map = usbSearcher?.getUsbDevices()
                        val obj = map?.map {
                            mapOf(
                                "deviceName" to it.deviceName,
                                "vendorId" to it.vendorId.toString(),
                                "productId" to it.productId.toString(),
                                "serialNumber" to (it.serialNumber ?: ""),
                                "deviceClass" to it.deviceClass.toString(),
                                "deviceSubclass" to it.deviceSubclass.toString(),
                                "deviceProtocol" to it.deviceProtocol.toString(),
                                "interfaceClass" to it.getInterface(0).interfaceClass.toString(),
                                "interfaceSubclass" to it.getInterface(0).interfaceSubclass.toString(),
                            )
                        }
                        result.success(Json.encodeToString(obj))
                    }
                }
                "hk.gogovan.device_searcher.connectUsb" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        val deviceName = call.argument<String>("deviceName");
                        if (deviceName == null) {
                            result.error("1001", "deviceName is required", null)
                        } else {
                            val device = usbSearcher?.getUsbDevices()?.find { it.deviceName == deviceName }
                            if (device == null) {
                                result.error("1002", "device not found", null)
                            } else {
                                usbSearcher?.connectDevice(device)
                                result.success(true)
                            }
                        }
                    }
                }
                "hk.gogovan.device_searcher.disconnectUsb" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        usbSearcher?.disconnectDevice()
                        result.success(true)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }  catch (e: PluginException) {
            result.error(e.code.toString(), e.message, e.stackTraceToString())
        } catch (e: Exception) {
            result.error("1000", e.message, e.stackTraceToString())
        }
    }

}