import 'package:flutter_device_searcher/device/device_interface.dart';
import 'package:flutter_device_searcher/exception/device_connection_error.dart';
import 'package:flutter_device_searcher/exception/invalid_connection_state.dart';
import 'package:flutter_device_searcher/exception/invalid_device_result_error.dart';
import 'package:flutter_device_searcher/flutter_device_searcher.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

// A Bluetooth LE device.
class BluetoothDevice extends DeviceInterface {
  BluetoothDevice(this.searcher, super.device);

  final FlutterDeviceSearcher searcher;
  String? deviceId;

  @override
  Future<bool> connectImpl(DeviceSearchResult device) {
    if (device is! BluetoothResult) {
      throw InvalidDeviceResultError(
        'Expected BluetoothResult. Received ${device.runtimeType}',
      );
    }

    deviceId = device.id;

    return searcher.flutterBle
        .connectToDevice(id: device.id, connectionTimeout: searcher.timeout)
        .where((event) => event.deviceId == deviceId)
        .map((event) {
          final failure = event.failure;
          if (failure != null) {
            throw DeviceConnectionError('${failure.code} ${failure.message}');
          }

          return event.connectionState == DeviceConnectionState.connected;
        })
        .where((x) => x)
        .first;
  }

  @override
  Future<bool> disconnectImpl() async => false;

  Future<List<DiscoveredService>> getServices() async {
    final id = deviceId;
    if (!isConnected() || id == null) {
      throw const InvalidConnectionState('Device not connected.');
    }

    return searcher.flutterBle.discoverServices(id);
  }

  Future<List<int>> read(Uuid characteristicId, Uuid serviceId) async {
    final id = deviceId;
    if (!isConnected() || id == null) {
      throw const InvalidConnectionState('Device not connected.');
    }

    final characteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: id);

    return searcher.flutterBle.readCharacteristic(characteristic);
  }

  Future<void> write(List<int> value, Uuid characteristicId, Uuid serviceId) async
  {
    final id = deviceId;
    if (!isConnected() || id == null) {
      throw const InvalidConnectionState('Device not connected.');
    }

    final characteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: id);

    return searcher.flutterBle.writeCharacteristicWithoutResponse(characteristic, value: value);
  }
}
