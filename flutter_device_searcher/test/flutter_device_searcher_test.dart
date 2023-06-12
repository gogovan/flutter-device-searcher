import 'package:flutter_device_searcher/flutter_device_searcher.dart';
import 'package:flutter_device_searcher/flutter_device_searcher_method_channel.dart';
import 'package:flutter_device_searcher/flutter_device_searcher_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterDeviceSearcherPlatform
    with MockPlatformInterfaceMixin
    implements FlutterDeviceSearcherPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterDeviceSearcherPlatform initialPlatform = FlutterDeviceSearcherPlatform.instance;

  test('$MethodChannelFlutterDeviceSearcher is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterDeviceSearcher>());
  });

  test('getPlatformVersion', () async {
    FlutterDeviceSearcher flutterDeviceSearcherPlugin = FlutterDeviceSearcher();
    MockFlutterDeviceSearcherPlatform fakePlatform = MockFlutterDeviceSearcherPlatform();
    FlutterDeviceSearcherPlatform.instance = fakePlatform;

    expect(await flutterDeviceSearcherPlugin.getPlatformVersion(), '42');
  });
}
