import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_device_searcher/flutter_device_searcher_platform_interface.dart';

/// An implementation of [FlutterDeviceSearcherPlatform] that uses method channels.
class MethodChannelFlutterDeviceSearcher extends FlutterDeviceSearcherPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_device_searcher');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
