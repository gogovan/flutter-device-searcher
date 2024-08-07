import 'dart:typed_data';

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

  Future<bool> connect(String deviceName) {
    throw UnimplementedError('connect() has not been implemented.');
  }

  Future<bool> setInterfaceIndex(int interfaceIndex) {
    throw UnimplementedError('setInterfaceIndex() has not been implemented.');
  }

  Future<bool> setEndpointIndex(int endpointIndex) {
    throw UnimplementedError('setEndpointIndex() has not been implemented.');
  }

  Future<bool> isConnected() {
    throw UnimplementedError('isConnected() has not been implemented.');
  }

  Future<bool> disconnect() {
    throw UnimplementedError('disconnect() has not been implemented.');
  }

  Future<Uint8List> read(int? length) {
    throw UnimplementedError('read() has not been implemented.');
  }

  Stream<Uint8List> readStream() {
    throw UnimplementedError('readStream() has not been implemented.');
  }

  Future<bool> write(Uint8List data) {
    throw UnimplementedError('write() has not been implemented.');
  }
}
