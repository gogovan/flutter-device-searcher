import 'dart:async';

import 'bluetooth_device.dart';
import 'bluetooth_service.dart';
import 'bluetooth_searcher.dart';
import 'bluetooth_result.dart';
import 'package:flutter_device_searcher/exception/device_connection_error.dart';
import 'package:meta/meta.dart';

mixin BluetoothConnectionMixin {
  BluetoothSearcher get btSearcher;
  StreamSubscription<Iterable<BluetoothResult>>? _searchedDevices;

  /// current bluetooth device. null if no device is connected or already been disconnected.
  @protected
  BluetoothDevice? btDevice;

  /// current bluetooth characteristic. null if no device is connected or already been disconnected.
  @protected
  BluetoothCharacteristic? btCharacteristic;

  /// Create a BluetoothDevice instance.
  BluetoothDevice createBluetoothDevice(
    BluetoothSearcher searcher,
    BluetoothResult result,
  ) =>
      BluetoothDevice(searcher, result);

  /// Whether to include the Bluetooth result during searching of available bluetooth devices.
  bool includeResult(BluetoothResult result);

  /// Whether to include the Bluetooth service during searching of available bluetooth services.
  bool includeService(BluetoothService service);

  /// Whether to include the Bluetooth characteristic during searching of available bluetooth characteristics.
  bool includeCharacteristic(BluetoothCharacteristic characteristic);

  /// Initialize the Bluetooth connection.
  Future<void> connect({
    Duration timeout = Duration.zero,
    required void Function() onConnected,
    void Function()? onTimeout,
  }) async {
    final stream = btSearcher
        .search(timeout: timeout, onTimeout: onTimeout)
        .map(
          (event) => event.where(includeResult),
        )
        .where((event) => event.isNotEmpty);

    _searchedDevices = stream.listen(cancelOnError: true, (event) async {
      await _searchedDevices?.cancel();
      final newDevice = createBluetoothDevice(btSearcher, event.first);
      if (await newDevice.connect()) {
        // 1 second delay added because otherwise getServices would fail with device already connected error. (Not sure why).
        // ignore: avoid-ignoring-return-values, not needed.
        await Future.delayed(const Duration(seconds: 1));

        final services = await newDevice.getServices();
        final service = services.where(includeService);

        if (service.isNotEmpty) {
          final selectedService = service.first;

          btDevice = newDevice;
          btCharacteristic = selectedService.characteristics
              .where(includeCharacteristic)
              .first;

          onConnected();
          await _searchedDevices?.cancel();
        }
      } else {
        return Future.error(
          const DeviceConnectionError('Failed to connect to device'),
        );
      }
    });
  }

  /// Disconnect from the connected Bluetooth device.
  Future<void> disconnect() async {
    await _searchedDevices?.cancel();
    await btDevice?.disconnect();
    btDevice = null;
    btCharacteristic = null;
  }

  /// Check if the Bluetooth device is connected.
  Future<bool> isConnected() => btDevice?.isConnected() ?? Future.value(false);

  /// Stream of the connection state of the Bluetooth device.
  Stream<bool> connectStateStream() =>
      btDevice?.connectStateStream() ?? Stream.value(false);

  /// Dispose the resources used by the Bluetooth device.
  Future<void> dispose() async {
    await btDevice?.dispose();
  }
}
