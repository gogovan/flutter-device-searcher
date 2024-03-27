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
    companion object {
        const val SHARED_PREF_NAME = "hk.gogovan.flutter_device_searcher"
        const val SHARED_PREF_PAPER_TYPE = "paper_type"
    }

    private var currentPaperType: Int? = null

    private var paperTypeSet = false
    private var areaSizeSet = false

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (currentPaperType == null) {
            val pref = context.getSharedPreferences(SHARED_PREF_NAME, Context.MODE_PRIVATE)
            currentPaperType = pref.getInt(SHARED_PREF_PAPER_TYPE, 0)
        }

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
            }
        }  catch (e: PluginException) {
            result.error(e.code.toString(), e.message, e.stackTraceToString())
        } catch (e: Exception) {
            result.error("1000", e.message, e.stackTraceToString())
        }
    }

}