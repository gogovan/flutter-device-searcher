package hk.gogovan.flutter_device_searcher.util.exception

import hk.gogovan.flutter_device_searcher.PluginException

class BluetoothScanException(code: Int): PluginException(1004, "Bluetooth Scan exception: code $code")