import 'package:flutter/services.dart';
import 'package:flutter_device_searcher/device_searcher/device_searcher_interface.dart';
import 'package:flutter_device_searcher/flutter_device_searcher_platform_interface.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';
import 'package:flutter_device_searcher/src/exception_codes.dart';

/// Searcher for devices using Classic Bluetooth.
class BluetoothSearcher extends DeviceSearcherInterface {
  /// Scan for Bluetooth printers.
  /// Will request for Bluetooth permission if none was granted yet.
  @override
  Stream<List<DeviceSearchResult>> search() {
    try {
      return FlutterDeviceSearcherPlatform.instance.searchBluetooth();
    } on PlatformException catch (ex, st) {
      Error.throwWithStackTrace(
        getExceptionFromCode(int.parse(ex.code), ex.message ?? '', ex.details),
        st,
      );
    }
  }

  @override
  Future<bool> stopSearch() {
    try {
      return FlutterDeviceSearcherPlatform.instance.stopSearchBluetooth();
    } on PlatformException catch (ex, st) {
      Error.throwWithStackTrace(
        getExceptionFromCode(int.parse(ex.code), ex.message ?? '', ex.details),
        st,
      );
    }
  }
}
