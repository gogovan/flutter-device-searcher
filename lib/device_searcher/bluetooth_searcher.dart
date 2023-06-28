import 'dart:async';

import 'package:flutter_device_searcher/device_searcher/device_searcher_interface.dart';
import 'package:flutter_device_searcher/exception/permission_denied_error.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

/// Searcher for devices using Bluetooth.
class BluetoothSearcher extends DeviceSearcherInterface<BluetoothResult> {
  BluetoothSearcher();

  final Set<BluetoothResult> _foundDevices = {};

  /// Scan for Bluetooth devices.
  /// Will request for Bluetooth permission if none was granted yet.
  @override
  Stream<List<BluetoothResult>> search() => [
        Permission.location,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request().asStream().map((event) {
        if (event.values.any((element) => !element.isGranted)) {
          throw const PermissionDeniedError(
            'Permission for Bluetooth denied.',
          );
        } else {
          return <BluetoothResult>[];
        }
      }).concatWith([
        flutterBle.scanForDevices(withServices: []).map((e) {
          logger.fine('Start scanning Bluetooth devices.');
          searching = true;

          final newResult = BluetoothResult(id: e.id, name: e.name);

          // ignore: avoid-ignoring-return-values, not needed.
          _foundDevices.add(newResult);
          logger.finer('Found device $newResult');

          return _foundDevices.toList();
        }),
      ]).doOnCancel(() {
        logger.fine('Stop scanning Bluetooth devices.');
        searching = false;
      });
}
