import 'package:flutter_device_searcher/flutter_device_searcher_platform_interface.dart';

class FlutterDeviceSearcher {
  Future<String?> getPlatformVersion() => FlutterDeviceSearcherPlatform.instance.getPlatformVersion();
}
