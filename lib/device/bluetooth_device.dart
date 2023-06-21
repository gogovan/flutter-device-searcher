import 'package:flutter_device_searcher/device/device_interface.dart';
import 'package:flutter_device_searcher/exception/device_connection_error.dart';
import 'package:flutter_device_searcher/exception/invalid_connection_state_error.dart';
import 'package:flutter_device_searcher/exception/invalid_device_result_error.dart';
import 'package:flutter_device_searcher/flutter_device_searcher.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:rxdart/rxdart.dart';

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

    if (searcher.searching) {
      // Some phones may misbehave when trying to connect a bluetooth device while scanning.
      // Ref https://github.com/dariuszseweryn/RxAndroidBle/wiki/FAQ:-Cannot-connect#connect-while-scanning.
      searcher.logger.warning(
        'There is a ongoing device scan. Connecting a device while a scan is ongoing may fail in some phones.',
      );
    }

    deviceId = device.id;

    searcher.logger.fine('Connecting to device $device');

    // Some phones may misbehave when trying to connect a bluetooth device right after stopping scan.
    // Adding a 1 sec delay make it more reliable.
    // Ref https://github.com/dariuszseweryn/RxAndroidBle/wiki/FAQ:-Cannot-connect#connect-right-after-scanning.
    return TimerStream<bool>(false, const Duration(seconds: 1)).concatWith(
      [
        searcher.flutterBle
            .connectToDevice(id: device.id)
            .where((event) => event.deviceId == deviceId)
            .map(
          (event) {
            searcher.logger.finer('Detected connect state: $event');

            final failure = event.failure;
            if (failure != null) {
              throw DeviceConnectionError('${failure.code} ${failure.message}');
            }

            return event.connectionState == DeviceConnectionState.connected;
          },
        ),
      ],
    ).firstWhere((x) => x);
  }

  @override
  Future<bool> disconnectImpl() async => false;

  Future<List<DiscoveredService>> getServices() async {
    final id = deviceId;
    if (!isConnected() || id == null) {
      throw const InvalidConnectionStateError('Device not connected.');
    }

    return searcher.flutterBle.discoverServices(id);
  }

  Future<List<int>> read(Uuid serviceId, Uuid characteristicId) async {
    final id = deviceId;
    if (!isConnected() || id == null) {
      throw const InvalidConnectionStateError('Device not connected.');
    }

    final characteristic = QualifiedCharacteristic(
      characteristicId: characteristicId,
      serviceId: serviceId,
      deviceId: id,
    );

    return searcher.flutterBle.readCharacteristic(characteristic);
  }

  Stream<List<int>> readAsStream(Uuid serviceId, Uuid characteristicId) {
    final id = deviceId;
    if (!isConnected() || id == null) {
      throw const InvalidConnectionStateError('Device not connected.');
    }

    final characteristic = QualifiedCharacteristic(
      characteristicId: characteristicId,
      serviceId: serviceId,
      deviceId: id,
    );

    return searcher.flutterBle.subscribeToCharacteristic(characteristic);
  }

  Future<void> write(
    List<int> value,
    Uuid serviceId,
    Uuid characteristicId,
  ) async {
    final id = deviceId;
    if (!isConnected() || id == null) {
      throw const InvalidConnectionStateError('Device not connected.');
    }

    final characteristic = QualifiedCharacteristic(
      characteristicId: characteristicId,
      serviceId: serviceId,
      deviceId: id,
    );

    return searcher.flutterBle
        .writeCharacteristicWithoutResponse(characteristic, value: value);
  }
}
