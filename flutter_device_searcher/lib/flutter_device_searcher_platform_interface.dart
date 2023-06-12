import 'package:flutter_device_searcher/flutter_device_searcher_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterDeviceSearcherPlatform extends PlatformInterface {
  /// Constructs a FlutterDeviceSearcherPlatform.
  FlutterDeviceSearcherPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterDeviceSearcherPlatform _instance =
      MethodChannelFlutterDeviceSearcher();

  /// The default instance of [FlutterDeviceSearcherPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterDeviceSearcher].
  static FlutterDeviceSearcherPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterDeviceSearcherPlatform] when
  /// they register themselves.
  static set instance(FlutterDeviceSearcherPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
