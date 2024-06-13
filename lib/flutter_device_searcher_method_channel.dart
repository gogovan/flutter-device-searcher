import 'package:flutter/services.dart';
import 'package:flutter_device_searcher/flutter_device_searcher_platform_interface.dart';
import 'package:meta/meta.dart';

class MethodChannelFlutterDeviceSearcher extends FlutterDeviceSearcherPlatform {
  MethodChannelFlutterDeviceSearcher()
      : methodChannel = const MethodChannel(
          'hk.gogovan.flutter_device_searcher',
        );

  @visibleForTesting
  MethodChannelFlutterDeviceSearcher.mocked(
    this.methodChannel,
  );

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel;

  @override
  Future<String> searchUsb() async {
    final result = await methodChannel
        .invokeMethod<String>('hk.gogovan.device_searcher.searchUsb');

    return result ?? '';
  }

  @override
  Future<bool> connect(String deviceName) async {
    final result = await methodChannel.invokeMethod<bool>(
      'hk.gogovan.device_searcher.connectUsb',
      <String, dynamic>{'deviceName': deviceName},
    );

    return result ?? false;
  }

  @override
  Future<bool> disconnect() async {
    final result = await methodChannel
        .invokeMethod<bool>('hk.gogovan.device_searcher.disconnectUsb');

    return result ?? false;
  }
}
