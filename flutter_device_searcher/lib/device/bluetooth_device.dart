import 'package:flutter/services.dart';
import 'package:flutter_device_searcher/device/device_interface.dart';
import 'package:flutter_device_searcher/flutter_device_searcher_platform_interface.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';
import 'package:flutter_device_searcher/exception_codes.dart';

// A Blutetooth Classic device.
class BluetoothDevice extends DeviceInterface {
  BluetoothDevice(super.device);

  @override
  Future<bool> connectImpl(DeviceSearchResult device) {
    try {
      return FlutterDeviceSearcherPlatform.instance
          .connectBluetooth(device as BluetoothResult);
    } on PlatformException catch (ex, st) {
      Error.throwWithStackTrace(
        getExceptionFromCode(int.parse(ex.code), ex.message ?? '', ex.details),
        st,
      );
    }
  }

  @override
  Future<bool> disconnectImpl() {
    try {
      return FlutterDeviceSearcherPlatform.instance.disconnectBluetooth();
    } on PlatformException catch (ex, st) {
      Error.throwWithStackTrace(
        getExceptionFromCode(int.parse(ex.code), ex.message ?? '', ex.details),
        st,
      );
    }
  }

  @override
  Future<List<int>> read() {
    try {
      return FlutterDeviceSearcherPlatform.instance.read();
    } on PlatformException catch (ex, st) {
      Error.throwWithStackTrace(
        getExceptionFromCode(int.parse(ex.code), ex.message ?? '', ex.details),
        st,
      );
    }
  }

  @override
  Future<bool> write(List<int> bytes) {
    try {
      return FlutterDeviceSearcherPlatform.instance.write(bytes);
    } on PlatformException catch (ex, st) {
      Error.throwWithStackTrace(
        getExceptionFromCode(int.parse(ex.code), ex.message ?? '', ex.details),
        st,
      );
    }
  }
}
