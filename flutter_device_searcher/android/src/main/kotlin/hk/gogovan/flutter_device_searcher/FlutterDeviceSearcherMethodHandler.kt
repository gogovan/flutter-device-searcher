package hk.gogovan.flutter_label_printer

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import cpcl.PrinterHelper
import hk.gogovan.flutter_label_printer.searcher.BluetoothSearcher
import hk.gogovan.flutter_label_printer.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.Integer.max
import java.lang.Integer.min

class FlutterLabelPrinterMethodHandler(
    private val context: Context,
    private val bluetoothSearcher: BluetoothSearcher?,
) : MethodChannel.MethodCallHandler {
    companion object {
        const val SHARED_PREF_NAME = "hk.gogovan.label_printer.flutter_label_printer"
        const val SHARED_PREF_PAPER_TYPE = "paper_type"
    }

    private var currentPaperType: Int? = null

    private var paperTypeSet = false
    private var areaSizeSet = false

    private val log = Log()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (currentPaperType == null) {
            val pref = context.getSharedPreferences(SHARED_PREF_NAME, Context.MODE_PRIVATE)
            currentPaperType = pref.getInt(SHARED_PREF_PAPER_TYPE, 0)
        }

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
                }
                "hk.gogovan.label_printer.disconnectHMA300L" -> {
                    if (!PrinterHelper.IsOpened()) {
                        result.error(
                            "1005",
                            "Printer not connected.",
                            Throwable().stackTraceToString()
                        )
                    } else {
                        result.success(PrinterHelper.portClose())
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