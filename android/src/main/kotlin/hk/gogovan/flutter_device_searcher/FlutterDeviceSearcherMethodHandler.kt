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
                        val obj = map?.map { device ->
                            val interfaces = mutableListOf<Map<String, String>>()
                            for (i in 0..(device.getInterfaceCount()-1)) {
                                val endpoints = mutableListOf<Map<String, String>>()

                                for (j in 0..(device.getInterface(i).getEndpointCount()-1)) {
                                    val endpoint = device.getInterface(i).getEndpoint(j)
                                    endpoints.add(mapOf(
                                        "endpointNumber" to endpoint.endpointNumber.toString(),
                                        "direction" to endpoint.direction.toString(),
                                        "type" to endpoint.type.toString(),
                                        "maxPacketSize" to endpoint.maxPacketSize.toString(),
                                        "interval" to endpoint.interval.toString()
                                    ))
                                }

                                interfaces.add(mapOf(
                                    "interfaceClass" to device.getInterface(i).interfaceClass.toString(),
                                    "interfaceSubclass" to device.getInterface(i).interfaceSubclass.toString(),
                                    "interfaceProtocol" to device.getInterface(i).interfaceProtocol.toString(),
                                    "endpoints" to Json.encodeToString(endpoints),
                                ))
                            }

                            mapOf(
                                "deviceName" to device.deviceName,
                                "vendorId" to device.vendorId.toString(),
                                "productId" to device.productId.toString(),
                                "serialNumber" to (device.serialNumber ?: ""),
                                "deviceClass" to device.deviceClass.toString(),
                                "deviceSubclass" to device.deviceSubclass.toString(),
                                "deviceProtocol" to device.deviceProtocol.toString(),
                                "interfaces" to Json.encodeToString(interfaces)
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
                "hk.gogovan.device_searcher.setInterfaceIndex" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        val index = call.argument<Int>("interfaceIndex");
                        if (index == null) {
                            result.error("1001", "index is required", null)
                        } else {
                            usbSearcher?.setInterfaceIndex(index)
                            result.success(true)
                        }
                    }
                }
                "hk.gogovan.device_searcher.setEndpointIndex" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        val endpointNumber = call.argument<Int>("endpointIndex");
                        if (endpointNumber == null) {
                            result.error("1001", "endpointNumber is required", null)
                        } else {
                            usbSearcher?.setEndpointIndex(endpointNumber)
                            result.success(true)
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