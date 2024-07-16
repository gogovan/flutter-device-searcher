package hk.gogovan.flutter_device_searcher

import android.app.Activity
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.VisibleForTesting
import com.hoho.android.usbserial.util.SerialInputOutputManager
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

    class ReadChannelListener(private val events: EventChannel.EventSink?) :
        SerialInputOutputManager.Listener {

        override fun onNewData(data: ByteArray) {
            Handler(Looper.getMainLooper()).post {
                events?.success(data)
            }
        }

        override fun onRunError(p: Exception) {
            Handler(Looper.getMainLooper()).post {
                events?.error(p.message, p.stackTraceToString(), p)
            }
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        val channelListener = ReadChannelListener(events)

        coroutineScope = CoroutineScope(Dispatchers.IO)
        coroutineScope.launch {
            try {
                val usbIoManager = SerialInputOutputManager(usbSearcher?.port, channelListener)
                usbIoManager.start()
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