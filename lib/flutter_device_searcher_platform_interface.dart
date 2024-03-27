import 'package:flutter_device_searcher/flutter_device_searcher_method_channel.dart';
import 'package:meta/meta.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterDeviceSearcherPlatform extends PlatformInterface {
  /// Constructs a FlutterLabelPrinterPlatform.
  FlutterDeviceSearcherPlatform() : super(token: token);

  @visibleForTesting
  // ignore: no-object-declaration, needed, directly from Flutter template code.
  static final Object token = Object();

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
    PlatformInterface.verifyToken(instance, token);
    _instance = instance;
  }

  Future<String> searchUsb() {
    throw UnimplementedError('searchUsb() has not been implemented.');
  }
}
