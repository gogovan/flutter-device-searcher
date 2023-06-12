import 'package:flutter/services.dart';
import 'package:flutter_device_searcher/flutter_device_searcher_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MethodChannelFlutterDeviceSearcher platform = MethodChannelFlutterDeviceSearcher();
  const MethodChannel channel = MethodChannel('flutter_device_searcher');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async => '42');
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
