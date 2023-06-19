import 'package:flutter_device_searcher/device/device_interface.dart';
import 'package:flutter_device_searcher/exception/device_connection_error.dart';
import 'package:flutter_device_searcher/exception/invalid_device_result_error.dart';
import 'package:flutter_device_searcher/flutter_device_searcher.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

// A Bluetooth LE device.
class BluetoothDevice extends DeviceInterface {
  BluetoothDevice(this.searcher, super.device);

  final FlutterDeviceSearcher searcher;

  @override
  Future<bool> connectImpl(DeviceSearchResult device) {
    if (device is! BluetoothResult) {
      throw InvalidDeviceResultError(
        'Expected BluetoothResult. Received ${device.runtimeType}',
      );
    }

    return searcher.flutterBle
        .connectToDevice(id: device.id, connectionTimeout: searcher.timeout)
        .map((event) {
      final failure = event.failure;
      if (failure != null) {
        throw DeviceConnectionError('${failure.code} ${failure.message}');
      }

      return event.connectionState == DeviceConnectionState.connected;
    }).where((x) => x).first;
  }

  @override
  Future<bool> disconnectImpl() async => false;

  @override
  Future<List<int>> read() async {
    return [];
  }

  @override
  Future<bool> write(List<int> bytes) async {
    return false;
  }
}
