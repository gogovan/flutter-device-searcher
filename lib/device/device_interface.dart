import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';

/// Interface all connectable devices should implement.
abstract class DeviceInterface<T extends DeviceSearchResult> {
  DeviceInterface(this.searchResult);

  final StreamController<bool> _connectedController =
      StreamController.broadcast();

  /// DeviceSearchResult indicating the device this instance is representing.
  @protected
  T searchResult;

  bool _connected = false;

  /// Whether the device has been connected.
  ///
  /// For USB, the connection is closed once the device has been found disconnected
  /// when calling this method due to the OS no longer maintaining the connection once disconnected.
  ///
  /// Implementors: This method only check if `connect()` is called and `disconnect()` has not been called.
  /// If there is a underlying connection to maintain, override this method to return the actual connection status,
  /// in conjunction to the state maintained by the DeviceInterface.
  @mustCallSuper
  Future<bool> isConnected() async => _connected;

  /// Return a stream that provide the status of the connection continuously.
  /// This should be in sync with `isConnected()` method.
  ///
  /// For USB, the connection is closed once the device has been found disconnected
  /// when calling this method due to the OS no longer maintaining the connection once disconnected.
  @mustCallSuper
  Stream<bool> connectStateStream() => _connectedController.stream;

  /// Connect to the specified device.
  /// The device should be one of the devices returned by the `search` method from a compatible DeviceSearcherInterface class.
  /// Return true if connection successful or already connected, false otherwise.
  @nonVirtual
  Future<bool> connect() async {
    if (!_connected) {
      final result = await connectImpl(searchResult);
      _connected = true;
      _connectedController.add(true);

      return result;
    } else {
      return true;
    }
  }

  /// Implementors should implement this method to connect to the device.
  /// Return true if connection successful, false otherwise.
  ///
  /// Implementors should connect to the specified device, and the device should be ready to use when this method returns normally.
  /// This method should be idempotent - multiple invocation of this method should not result in errors or multiple connections.
  @protected
  Future<bool> connectImpl(T inSearchResult);

  /// Disconnect to the currently connected device.
  /// Return true if disconnection successful or already disconnected, false otherwise.
  @nonVirtual
  Future<bool> disconnect() async {
    if (_connected) {
      final result = await disconnectImpl();
      _connected = false;
      _connectedController.add(false);

      return result;
    } else {
      return true;
    }
  }

  /// Implementors should implement this method to disconnect the device.
  /// Return true if connection successful, false otherwise.
  ///
  /// Implementors should disconnect the current device, and do any cleanup needed.
  /// This method should be idempotent - multiple invocation of this method should not result in errors or multiple disconnections.
  @protected
  Future<bool> disconnectImpl();

  /// Dispose this device.
  @mustCallSuper
  Future<void> dispose() async {
    await _connectedController.close();
  }
}
