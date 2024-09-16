import 'dart:async';

import 'package:flutter_device_searcher/device_searcher/device_searcher_interface.dart';
import 'package:flutter_device_searcher/exception/permission_denied_error.dart';
import 'package:flutter_device_searcher/permission_wrapper.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

/// Searcher for devices using Bluetooth.
class BluetoothSearcher extends DeviceSearcherInterface<BluetoothResult> {
  BluetoothSearcher()
      : flutterBle = FlutterReactiveBle(),
        permissionWrapper = PermissionWrapper();

  @visibleForTesting
  BluetoothSearcher.withBle(this.flutterBle, this.permissionWrapper);

  @internal
  final FlutterReactiveBle flutterBle;

  final PermissionWrapper permissionWrapper;

  final Set<BluetoothResult> _foundDevices = {};

  /// Scan for Bluetooth devices.
  /// Will request for Bluetooth permission if none was granted yet.
  @override
  Stream<List<BluetoothResult>> search({
    Duration timeout = Duration.zero,
    void Function()? onTimeout,
  }) =>
      permissionWrapper.requestBluetoothPermissions().asStream().map((event) {
        if (event.values.any((element) => !element.isGranted)) {
          throw const PermissionDeniedError(
            'Permission for Bluetooth denied.',
          );
        } else {
          return <BluetoothResult>[];
        }
      }).doOnListen(() {
        logger.fine('Start scanning Bluetooth devices.');
        searching = true;
      }).concatWith([
        if (timeout > Duration.zero)
          flutterBle.statusStream
              .firstWhere((element) => element == BleStatus.ready)
              .asStream()
              .timeout(
            timeout,
            onTimeout: (_) {
              onTimeout?.call();
            },
          ).map((event) => []),
        if (timeout <= Duration.zero)
          flutterBle.statusStream
              .firstWhere((element) => element == BleStatus.ready)
              .asStream()
              .map((event) => []),
        if (timeout > Duration.zero)
          flutterBle.scanForDevices(withServices: []).timeout(
            timeout,
            onTimeout: (_) {
              onTimeout?.call();
            },
          ).map(_deviceToResult),
        if (timeout <= Duration.zero)
          flutterBle.scanForDevices(withServices: []).map(_deviceToResult),
      ]).doOnCancel(() {
        logger.fine('Stop scanning Bluetooth devices.');
        searching = false;
      });

  bool isReady() => flutterBle.status == BleStatus.ready;

  Stream<bool> connectStateStream() => flutterBle.statusStream
      .map((event) => event == BleStatus.ready)
      .asBroadcastStream();

  List<BluetoothResult> _deviceToResult(DiscoveredDevice e) {
    final newResult = BluetoothResult(
      id: e.id,
      name: e.name,
      serviceIds: e.serviceUuids.map((e) => e.toString()).toList(),
    );

    // ignore: avoid-ignoring-return-values, not needed.
    _foundDevices.add(newResult);
    logger.finer('Found device $newResult');

    return _foundDevices.toList();
  }
}
