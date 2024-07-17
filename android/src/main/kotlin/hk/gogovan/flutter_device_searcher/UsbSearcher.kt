package hk.gogovan.flutter_device_searcher

import android.annotation.SuppressLint
import android.app.Activity
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbConstants
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbDeviceConnection
import android.hardware.usb.UsbManager
import android.os.Build
import com.hoho.android.usbserial.driver.UsbSerialProber
import com.hoho.android.usbserial.driver.UsbSerialDriver
import com.hoho.android.usbserial.driver.UsbSerialPort
import java.io.IOException

class UsbSearcher(private val context: Context) {
    companion object {
        private const val ACTION_USB_PERMISSION = "hk.gogovan.flutter_device_searcher.USB_PERMISSION"

        private const val WRITE_WAIT_MILLIS = 30000
        private const val READ_WAIT_MILLIS = 5000

        private const val BAUD_RATE = 9600
    }

    private val usbReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (ACTION_USB_PERMISSION == intent?.action) {
                onPermission()
            }
        }
    }

    private var currentActivity: Activity? = null
    private var permissionIntent: PendingIntent? = null

    var port: UsbSerialPort? = null
        private set

    private var onPermission: () -> Unit = { }

    private var searchedDrivers: Map<Int, UsbSerialDriver> = mapOf()

    @SuppressLint("UnspecifiedRegisterReceiverFlag")
    fun setCurrentActivity(activity: Activity) {
        currentActivity = activity

        permissionIntent = PendingIntent.getBroadcast(
            activity, 0, Intent(ACTION_USB_PERMISSION),
            PendingIntent.FLAG_IMMUTABLE
        )
        val filter = IntentFilter(ACTION_USB_PERMISSION)
        if (Build.VERSION.SDK_INT >= 33) {
            activity.registerReceiver(usbReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            activity.registerReceiver(usbReceiver, filter)
        }
    }

    suspend fun searchUsbDevices(): Map<Int, UsbDevice> {
        var permissionPendingChecks = false

        val manager = context.getSystemService(UsbManager::class.java)
        val availableDrivers = UsbSerialProber.getDefaultProber().findAllDrivers(manager)
        if (availableDrivers.isEmpty()) {
            return emptyMap()
        }

        val map = mutableMapOf<Int, UsbSerialDriver>()
        availableDrivers.forEachIndexed { index, driver ->
            permissionPendingChecks = true
            checkPermission(driver) { granted, inDevice ->
                if (inDevice != null && granted) {
                    map[index] = driver
                }
                permissionPendingChecks = false
            }

            while (permissionPendingChecks) {
                kotlinx.coroutines.delay(100)
            }
        }

        searchedDrivers = map

        return map.mapValues { it.value.device }
    }

    private fun checkPermission(driver: UsbSerialDriver, onPerm: (Boolean, UsbDevice?) -> Unit): Boolean {
        val manager = context.getSystemService(UsbManager::class.java)
        val device = driver.device

        return if (manager.hasPermission(device)) {
            onPerm(true, device)
            true
        } else {
            onPermission = {
                onPerm(manager.hasPermission(device), device)
            }
            manager.requestPermission(device, permissionIntent)
            false
        }
    }

    suspend fun connectDevice(deviceIndex: Int): Boolean {
        val driver = searchedDrivers[deviceIndex]
        val manager = context.getSystemService(UsbManager::class.java)

        if (driver == null) {
            return false
        } else {
            val device = driver.device
            if (!manager.hasPermission(device)) {
                return false
            }
            val connection = manager.openDevice(device)

            port = driver.ports[0]
            port?.open(connection)
            port?.setParameters(BAUD_RATE, 8, UsbSerialPort.STOPBITS_1, UsbSerialPort.PARITY_NONE)
            return true
        }
    }

    suspend fun read(length: Int?): ByteArray {
        val response = ByteArray(length ?: 1024)
        port?.read(response, READ_WAIT_MILLIS)
        return response
    }

    suspend fun write(buffer: ByteArray): Boolean {
        if (port == null) {
            return false
        }
        port?.write(buffer, WRITE_WAIT_MILLIS)
        return true
    }

    suspend fun isConnected(): Boolean {
        if (port?.isOpen != true) {
            return false
        }
        try {
            // Attempt to read control info to determine whether the connection is active.
            port?.controlLines
            return true
        } catch (e: IOException) {
            port?.close()
            return false
        }
    }

    suspend fun disconnectDevice() {
        port?.close()
    }
    
}
