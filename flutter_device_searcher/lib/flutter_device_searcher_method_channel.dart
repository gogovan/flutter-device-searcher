import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_device_searcher/flutter_device_searcher_platform_interface.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';

/// An implementation of [FlutterDeviceSearcherPlatform] that uses method channels.
class MethodChannelFlutterDeviceSearcher extends FlutterDeviceSearcherPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(
    'hk.gogovan.flutter_device_searcher',);

  final _scanBluetoothEventChannel = const EventChannel(
    'hk.gogovan.flutter_device_searcher.bluetoothScan',);

  @override
  Stream<List<BluetoothResult>> searchBluetooth() =>
      _scanBluetoothEventChannel.receiveBroadcastStream().map(
            (event) =>
            (event as List<dynamic>).map((e) => BluetoothResult(e.toString())).toList(),
      );

  @override
  Future<bool> stopSearchBluetooth() async {
    final result = await methodChannel
        .invokeMethod<bool>('hk.gogovan.flutter_device_searcher.stopSearchBluetooth');

    return result ?? false;
  }

  @override
  Future<bool> connectBluetooth(BluetoothResult connectTo) async {
    final result = await methodChannel.invokeMethod<bool>(
      'hk.gogovan.flutter_device_searcher.connectBluetooth',
      <String, dynamic>{
        'address': connectTo.address,
      },
    );

    return result ?? false;
  }

  @override
  Future<bool> disconnectBluetooth() async {
    final result = await methodChannel
        .invokeMethod<bool>('hk.gogovan.flutter_device_searcher.disconnectBluetooth');

    return result ?? false;
  }
}
