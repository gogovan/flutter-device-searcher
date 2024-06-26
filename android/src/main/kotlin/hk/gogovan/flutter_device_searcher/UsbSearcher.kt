package hk.gogovan.flutter_device_searcher

import android.util.Log
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

class UsbSearcher(private val context: Context) {
    companion object {
        private const val ACTION_USB_PERMISSION = "hk.gogovan.flutter_device_searcher.USB_PERMISSION"
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

    private var currentConnection: UsbDeviceConnection? = null
    private var currentDevice: UsbDevice? = null
    private var currentInterface: Int = -1
    private var currentEndpoint: Int = -1

    private var onPermission: () -> Unit = { }

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

    suspend fun getUsbDevices(): List<UsbDevice> {
        val result = mutableListOf<UsbDevice>()
        var permissionPendingChecks = false

        val manager = context.getSystemService(UsbManager::class.java)
        for (device in manager.deviceList.values) {
            permissionPendingChecks = true
            checkPermission(device) { granted, inDevice ->
                if (inDevice != null && granted) {
                    result.add(inDevice)
                }
                permissionPendingChecks = false
            }

            while (permissionPendingChecks) {
                kotlinx.coroutines.delay(100)
            }
        }

        return result
    }

    private fun checkPermission(device: UsbDevice, onPerm: (Boolean, UsbDevice?) -> Unit): Boolean {
        val manager = context.getSystemService(UsbManager::class.java)

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

    suspend fun connectDevice(device: UsbDevice) {
        if (currentConnection != null) {
            currentConnection?.close()
            currentConnection = null
        }

        val manager = context.getSystemService(UsbManager::class.java)

        currentDevice = device;
        currentConnection = manager.openDevice(device)
    }

    suspend fun setInterfaceIndex(index: Int): Boolean {
        if (currentInterface >= 0) {
            currentDevice?.getInterface(currentInterface)?.let {
                currentConnection?.releaseInterface(it)
            }
        }

        currentDevice?.getInterface(index)?.let {
            currentConnection?.claimInterface(it, true)?.let {
                currentInterface = index
                return true;
            }
        }
        return false;
    }

    suspend fun setEndpointIndex(index: Int): Boolean {
        if (currentInterface < 0) throw Exception("No interface selected")
        currentDevice?.getInterface(currentInterface)?.getEndpoint(index)?.let {
            currentEndpoint = index
            return true;
        }
        return false;
    }

    suspend fun transfer(dataArray: ByteArray?, length: Int?): ByteArray {
        if (currentInterface < 0 || currentEndpoint < 0) throw Exception("No interface/endpoint selected")
        val endpoint = currentDevice?.getInterface(currentInterface)?.getEndpoint(currentEndpoint)
        val packetSize = if (length == null) (endpoint?.maxPacketSize ?: 0) else length
        if (endpoint?.direction == UsbConstants.USB_DIR_IN) {
            // read
            val response = ByteArray(packetSize)
            val result = currentConnection?.bulkTransfer(endpoint, response, response.size, 0)
            return response
        } else if (endpoint?.direction == UsbConstants.USB_DIR_OUT) {
            if (dataArray == null) throw Exception("No data to write")
            // write
            currentConnection?.bulkTransfer(currentDevice?.getInterface(currentInterface)?.getEndpoint(currentEndpoint), dataArray, minOf(packetSize, dataArray.size), 0)
            return ByteArray(0)
        } else {
            throw Exception("No endpoint selected")
        }
    }

    suspend fun isConnected(): Boolean {
        val c = currentConnection;
        return c != null && c.serial != null
    }

    suspend fun disconnectDevice() {
        currentConnection?.close()
        currentConnection = null
    }
    
}
