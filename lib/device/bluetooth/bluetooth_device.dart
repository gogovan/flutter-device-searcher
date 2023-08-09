import 'dart:async';

import 'package:flutter_device_searcher/device/bluetooth/bluetooth_service.dart';
import 'package:flutter_device_searcher/device/device_interface.dart';
import 'package:flutter_device_searcher/device_searcher/device_searcher_interface.dart';
import 'package:flutter_device_searcher/exception/device_connection_error.dart';
import 'package:flutter_device_searcher/exception/invalid_connection_state_error.dart';
import 'package:flutter_device_searcher/exception/invalid_device_result_error.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:rxdart/rxdart.dart';

// A Bluetooth LE device.
class BluetoothDevice extends DeviceInterface {
  BluetoothDevice(this.searcher, super.device);

  final DeviceSearcherInterface searcher;
  BluetoothResult? device;

  StreamSubscription<bool>? connection;

  @override
  Future<bool> connectImpl(DeviceSearchResult inDevice) {
    if (inDevice is! BluetoothResult) {
      throw InvalidDeviceResultError(
        'Expected BluetoothResult. Received ${inDevice.runtimeType}',
      );
    }

    if (searcher.isSearching()) {
      // Some phones may misbehave when trying to connect a bluetooth device while scanning.
      // Ref https://github.com/dariuszseweryn/RxAndroidBle/wiki/FAQ:-Cannot-connect#connect-while-scanning.
      searcher.logger.warning(
        'There is a ongoing device scan. Connecting a device while a scan is ongoing may fail in some phones.',
      );
    }

    device = inDevice;

    searcher.logger.fine('Connecting to device $device');

    final completer = Completer<bool>();

    // Some phones may misbehave when trying to connect a bluetooth device right after stopping scan.
    // Adding a 1 sec delay make it more reliable.
    // Ref https://github.com/dariuszseweryn/RxAndroidBle/wiki/FAQ:-Cannot-connect#connect-right-after-scanning.
    connection =
        TimerStream<bool>(false, const Duration(seconds: 1)).concatWith(
      [
        searcher.flutterBle
            .connectToDevice(id: inDevice.id)
            .where((event) => event.deviceId == inDevice.id)
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
    ).listen((event) {
      if (event) {
        completer.complete(true);
      }
    });

    return completer.future;
  }

  @override
  Future<bool> disconnectImpl() async {
    await connection?.cancel();
    return true;
  }

  Future<List<BluetoothService>> getServices() async {
    final id = device?.id;
    if (!isConnected() || id == null) {
      throw const InvalidConnectionStateError('Device not connected.');
    }

    final serviceIds = device?.serviceIds;
    if (serviceIds == null || serviceIds.isEmpty) {
      return [];
    }

    searcher.logger
        .finer('Getting services of Device $id with services $serviceIds');

    await searcher.flutterBle.statusStream
        .firstWhere((element) => element == BleStatus.ready);
    final service = await searcher.flutterBle.discoverServices(id);

    return service
        .map(
          (s) => BluetoothService(
            serviceId: s.serviceId.toString(),
            characteristics: s.characteristics
                .map(
                  (c) => BluetoothCharacteristic(
                    serviceId: s.serviceId.toString(),
                    characteristicId: c.characteristicId.toString(),
                    isReadable: c.isReadable,
                    isNotifiable: c.isNotifiable,
                    isWritableWithResponse: c.isWritableWithResponse,
                    isWritableWithoutResponse: c.isWritableWithoutResponse,
                    isIndicatable: c.isIndicatable,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  Future<List<int>> read(String serviceId, String characteristicId) async {
    final id = device?.id;
    if (!isConnected() || id == null) {
      throw const InvalidConnectionStateError('Device not connected.');
    }

    final characteristic = QualifiedCharacteristic(
      characteristicId: Uuid.parse(characteristicId),
      serviceId: Uuid.parse(serviceId),
      deviceId: id,
    );

    return searcher.flutterBle.readCharacteristic(characteristic);
  }

  Stream<List<int>> readAsStream(String serviceId, String characteristicId) {
    final id = device?.id;
    if (!isConnected() || id == null) {
      throw const InvalidConnectionStateError('Device not connected.');
    }

    final characteristic = QualifiedCharacteristic(
      characteristicId: Uuid.parse(characteristicId),
      serviceId: Uuid.parse(serviceId),
      deviceId: id,
    );

    return searcher.flutterBle.subscribeToCharacteristic(characteristic);
  }

  Future<void> write(
    List<int> value,
    String serviceId,
    String characteristicId,
  ) async {
    final id = device?.id;
    if (!isConnected() || id == null) {
      throw const InvalidConnectionStateError('Device not connected.');
    }

    final characteristic = QualifiedCharacteristic(
      characteristicId: Uuid.parse(characteristicId),
      serviceId: Uuid.parse(serviceId),
      deviceId: id,
    );

    return searcher.flutterBle
        .writeCharacteristicWithoutResponse(characteristic, value: value);
  }
}
