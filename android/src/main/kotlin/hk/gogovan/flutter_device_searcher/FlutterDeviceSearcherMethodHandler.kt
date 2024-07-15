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
                        val map = usbSearcher?.searchUsbDevices()
                        val obj = map?.mapValues { v ->
                            val device = v.value
                            mapOf(
                                "deviceName" to device.deviceName,
                                "vendorId" to device.vendorId.toString(),
                                "productId" to device.productId.toString(),
                                "serialNumber" to (device.serialNumber ?: ""),
                                "deviceClass" to device.deviceClass.toString(),
                                "deviceSubclass" to device.deviceSubclass.toString(),
                                "deviceProtocol" to device.deviceProtocol.toString(),
                            )
                        }

                        result.success(Json.encodeToString(obj))
                    }
                }
                "hk.gogovan.device_searcher.connectUsb" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        val deviceIndex = call.argument<String>("index")?.toIntOrNull()
                        if (deviceIndex == null) {
                            result.error("1001", "index is required", null)
                        } else {
                            result.success(usbSearcher?.connectDevice(deviceIndex))
                        }
                    }
                }
                "hk.gogovan.device_searcher.read" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        val length = call.argument<Int>("length");
                        val response = usbSearcher?.read(length)
                        result.success(response)
                    }
                }
                "hk.gogovan.device_searcher.write" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        val buffer = call.argument<ByteArray>("buffer") ?: byteArrayOf();
                        val r = usbSearcher?.write(buffer)
                        result.success(r)
                    }
                }
                "hk.gogovan.device_searcher.isConnected" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        val isConnected = usbSearcher?.isConnected()
                        result.success(isConnected)
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
        } catch (e: PluginException) {
            result.error(e.code.toString(), e.message, e.stackTraceToString())
        } catch (e: Exception) {
            result.error("1000", e.message, e.stackTraceToString())
        }
    }

}