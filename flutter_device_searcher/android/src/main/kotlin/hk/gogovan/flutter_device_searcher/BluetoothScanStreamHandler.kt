package hk.gogovan.flutter_device_searcher

import android.app.Activity
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class BluetoothScanStreamHandler(
    private val bluetoothSearcher: BluetoothSearcher?,
) : EventChannel.StreamHandler {
    private val pluginExceptionFlow = MutableSharedFlow<PluginException>()
    private val coroutineScope: CoroutineScope = CoroutineScope(Dispatchers.IO)

    private var currentActivity: Activity? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        coroutineScope.launch {
            try {
                bluetoothSearcher?.scan(currentActivity)?.collect { valueOrError ->
                    Handler(Looper.getMainLooper()).post {
                        if (valueOrError.value != null) {
                            val devices = valueOrError.value
                            val result = devices.map { d ->
                                mapOf<String, String>(
                                    "address" to d.address,
                                    "name" to d.name,
                                )
                            }

                            events?.success(result)
                        } else {
                            if (valueOrError.error is PluginException) {
                                events?.error(
                                    valueOrError.error.code.toString(),
                                    valueOrError.error.message,
                                    valueOrError.error.stackTraceToString()
                                )
                            } else {
                                events?.error(
                                    "1004",
                                    valueOrError.error?.message,
                                    valueOrError.error?.stackTraceToString()
                                )
                            }
                        }
                    }
                }
            } catch (ex: PluginException) {
                Handler(Looper.getMainLooper()).post {
                    events?.error(ex.code.toString(), ex.message, ex.stackTraceToString())
                }
            }
        }

        coroutineScope.launch {
            pluginExceptionFlow.collect { ex ->
                Handler(Looper.getMainLooper()).post {
                    events?.error(ex.code.toString(), ex.message, ex.stackTraceToString())
                }
            }
        }
    }

    override fun onCancel(arguments: Any?) {

    }

    fun setCurrentActivity(activity: Activity?) {
        currentActivity = activity
    }

    fun close() {
        coroutineScope.cancel()
        currentActivity = null
    }
}