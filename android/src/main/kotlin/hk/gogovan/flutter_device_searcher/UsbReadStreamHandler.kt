package hk.gogovan.flutter_device_searcher

import android.app.Activity
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.VisibleForTesting
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class UsbReadStreamHandler(
    private val usbSearcher: UsbSearcher?,
) : EventChannel.StreamHandler {
    @VisibleForTesting
    var coroutineScope: CoroutineScope = CoroutineScope(Dispatchers.IO)

    private var currentActivity: Activity? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        coroutineScope.launch {
            try {

            } catch (ex: PluginException) {
                Handler(Looper.getMainLooper()).post {
                    events?.error(ex.code.toString(), ex.message, ex.stackTraceToString())
                }
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        coroutineScope.cancel()
        currentActivity = null
    }

    fun setCurrentActivity(activity: Activity?) {
        currentActivity = activity
    }

    fun close() {
        coroutineScope.cancel()
        currentActivity = null
    }
}