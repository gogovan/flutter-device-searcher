package hk.gogovan.flutter_device_searcher

import android.content.Context
import hk.gogovan.flutter_device_searcher.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FlutterDeviceSearcherMethodHandler(
    private val context: Context,
    private val bluetoothSearcher: BluetoothSearcher?,
) : MethodChannel.MethodCallHandler {
    private val log = Log()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "hk.gogovan.label_printer.setLogLevel" -> {
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
                "hk.gogovan.label_printer.stopSearchHMA300L" -> {
                    val response = bluetoothSearcher?.stopScan()
                    result.success(response)
                }
                "hk.gogovan.label_printer.connectHMA300L" -> {
/*
                    if (PrinterHelper.IsOpened()) {
                        result.error(
                            "1005",
                            "Printer already connected.",
                            Throwable().stackTraceToString()
                        )
                    } else {
                        val address = call.argument<String>("address")
                        if (address == null) {
                            result.error(
                                "1000",
                                "Unable to extract arguments.",
                                Throwable().stackTraceToString()
                            )
                        } else {
                            when (PrinterHelper.portOpenBT(context, address)) {
                                0 -> {
                                    result.success(true)
                                }
                                -1 -> {
                                    result.error(
                                        "1008",
                                        "Connection timed out.",
                                        Throwable().stackTraceToString()
                                    )
                                }
                                -2 -> {
                                    result.error(
                                        "1007",
                                        "Bluetooth address incorrect.",
                                        Throwable().stackTraceToString()
                                    )
                                }
                                else -> {
                                    result.error(
                                        "1006",
                                        "Connection error.",
                                        Throwable().stackTraceToString()
                                    )
                                }
                            }
                        }
                    }

 */
                }
                "hk.gogovan.label_printer.disconnectHMA300L" -> {
                    /*
                    if (!PrinterHelper.IsOpened()) {
                        result.error(
                            "1005",
                            "Printer not connected.",
                            Throwable().stackTraceToString()
                        )
                    } else {
                        result.success(PrinterHelper.portClose())
                    }

                     */
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