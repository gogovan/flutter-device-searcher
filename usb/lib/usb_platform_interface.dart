import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'usb_method_channel.dart';

abstract class UsbPlatform extends PlatformInterface {
  /// Constructs a UsbPlatform.
  UsbPlatform() : super(token: _token);

  static final Object _token = Object();

  static UsbPlatform _instance = MethodChannelUsb();

  /// The default instance of [UsbPlatform] to use.
  ///
  /// Defaults to [MethodChannelUsb].
  static UsbPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UsbPlatform] when
  /// they register themselves.
  static set instance(UsbPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
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
