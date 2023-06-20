import 'dart:async';

import 'package:flutter_device_searcher/device_searcher/device_searcher_interface.dart';
import 'package:flutter_device_searcher/exception/permission_denied_error.dart';
import 'package:flutter_device_searcher/flutter_device_searcher.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

/// Searcher for devices using Bluetooth.
class BluetoothSearcher extends DeviceSearcherInterface {
  BluetoothSearcher(this.searcher);

  final FlutterDeviceSearcher searcher;
  final Set<BluetoothResult> foundDevices = {};

  /// Scan for Bluetooth devices.
  /// Will request for Bluetooth permission if none was granted yet.
  @override
  Stream<List<DeviceSearchResult>> search() => [
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request().asStream().map((event) {
      if (event.values.any((element) => !element.isGranted)) {
        throw const PermissionDeniedError(
          'Permission for Bluetooth denied.',
        );
      } else {
        return <DeviceSearchResult>[];
      }
    }).concatWith([
      searcher.flutterBle.scanForDevices(withServices: []).map((e) {
        final newResult = BluetoothResult(id: e.id, name: e.name);

        // ignore: avoid-ignoring-return-values, not needed.
        foundDevices.add(newResult);

        return foundDevices.toList();
      }),
    ]);
}
