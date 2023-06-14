import 'package:flutter_device_searcher/flutter_device_searcher_method_channel.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterDeviceSearcherPlatform extends PlatformInterface {
  /// Constructs a FlutterDeviceSearcherPlatform.
  FlutterDeviceSearcherPlatform() : super(token: _token);

  // ignore: no-object-declaration, needed, directly from Flutter template code.
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

  Future<bool> setLogLevel() {
    throw UnimplementedError('setLogLevel() has not been implemented.');
  }

  Stream<List<BluetoothResult>> searchBluetooth() {
    throw UnimplementedError('searchBluetooth() has not been implemented.');
  }

  Future<bool> stopSearchBluetooth() async {
    throw UnimplementedError('stopSearchBluetooth() has not been implemented.');
  }

  Future<bool> connectBluetooth(BluetoothResult connectTo) {
    throw UnimplementedError('connectBluetooth() has not been implemented.');
  }

  Future<bool> disconnectBluetooth() {
    throw UnimplementedError('disconnectBluetooth() has not been implemented.');
  }

  Future<List<int>> read() {
    throw UnimplementedError('disconnectBluetooth() has not been implemented.');
  }

  Future<bool> write(List<int> bytes) {
    throw UnimplementedError('disconnectBluetooth() has not been implemented.');
  }
}
