package hk.gogovan.flutter_device_searcher

import android.bluetooth.BluetoothSocket
import android.content.Context
import hk.gogovan.flutter_device_searcher.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class FlutterDeviceSearcherMethodHandler(
    private val bluetoothSearcher: BluetoothSearcher?,
) : MethodChannel.MethodCallHandler {
    private val log = Log()

    private var socket: BluetoothSocket? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "hk.gogovan.flutter_device_searcher.setLogLevel" -> {
                    try {
                        val level = call.argument<Int>("level") ?: 2
                        log.setLogLevel(level)
                    } catch (e: ClassCastException) {
                        result.error(
                            "1009",
                            "Unable to extract arguments",
                            Throwable().stackTraceToString()
                        )
                    }
                }
                "hk.gogovan.flutter_device_searcher.stopSearchBluetooth" -> {
                    val response = bluetoothSearcher?.stopScan()
                    result.success(response)
                }
                "hk.gogovan.flutter_device_searcher.connectBluetooth" -> {
                    if (socket?.isConnected == true) {
                        result.error(
                            "1005",
                            "Device already connected.",
                            Throwable().stackTraceToString()
                        )
                    } else {
                        val address = call.argument<String>("address")
                        val uuid = call.argument<String>("uuid") ?: "00001101-0000-1000-8000-00805F9B34FB"
                        if (address == null) {
                            result.error(
                                "1000",
                                "Unable to extract arguments.",
                                Throwable().stackTraceToString()
                            )
                        } else {
                            val device = bluetoothSearcher?.getDevice(address)
                            if (device == null) {
                                result.error(
                                    "1007",
                                    "Bluetooth address incorrect.",
                                    Throwable().stackTraceToString()
                                )
                            } else {
                                try {
                                    socket = device.createInsecureRfcommSocketToServiceRecord(UUID.fromString(uuid))
                                    try {
                                        socket?.connect()
                                    } catch (ex: Exception) {
                                        result.error(
                                            "1008",
                                            "Connection timed out.",
                                            "${ex.message}\n${Throwable().stackTraceToString()}}"
                                        )
                                    }
                                } catch (ex: Exception) {
                                    result.error(
                                        "1006",
                                        "Connection error.",
                                        "${ex.message}\n${Throwable().stackTraceToString()}}"
                                    )
                                }
                            }
                        }
                    }
                }
                "hk.gogovan.flutter_device_searcher.disconnectBluetooth" -> {
                    if (socket?.isConnected != true) {
                        result.error(
                            "1005",
                            "Device is not connected.",
                            Throwable().stackTraceToString()
                        )
                    } else {
                        try {
                            socket?.inputStream?.close()
                            socket?.outputStream?.close()
                            socket?.close()
                        } catch (ex: Exception) {
                            result.error(
                                "1011",
                                "Unable to close connection.",
                                "${ex.message}\n${Throwable().stackTraceToString()}}"
                            )
                        }
                    }
                }
                "hk.gogovan.flutter_device_searcher.read" -> {
                    if (socket?.isConnected != true) {
                        result.error(
                            "1005",
                            "Device is not connected.",
                            Throwable().stackTraceToString()
                        )
                    } else {
                        try {
                            val length = call.argument<Int>("length") ?: 0
                            val bytes = ByteArray(length)
                            socket?.inputStream?.read(bytes)
                            result.success(bytes)
                        } catch (ex: Exception) {
                            result.error(
                                "1011",
                                "Failed to read bytes",
                                "${ex.message}\n${Throwable().stackTraceToString()}}"
                            )
                        }
                    }
                }
                "hk.gogovan.flutter_device_searcher.write" -> {
                    if (socket?.isConnected != true) {
                        result.error(
                            "1005",
                            "Device is not connected.",
                            Throwable().stackTraceToString()
                        )
                    } else {
                        try {
                            val bytes = call.argument<ByteArray>("bytes") ?: ByteArray(0)
                            socket?.outputStream?.write(bytes)
                            result.success(true)
                        } catch (ex: Exception) {
                        result.error(
                            "1011",
                            "Failed to write bytes",
                            "${ex.message}\n${Throwable().stackTraceToString()}}"
                        )
                    }
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