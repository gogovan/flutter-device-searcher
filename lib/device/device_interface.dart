import 'package:flutter/foundation.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';

/// Interface all connectable devices should implement.
abstract class DeviceInterface {
  DeviceInterface(this.searchResult);

  /// PrinterSearchResult indicating the device this instance is representing.
  @protected
  DeviceSearchResult searchResult;

  bool _connected = false;

  /// Whether the device has been connected.
  /// Implementors: This method only check if `connect()` is called and `disconnect()` has not been called.
  /// If there is a underlying connection to maintain, override this method to return the actual connection status,
  /// in conjunction to the state maintained by the DeviceInterface.
  @mustCallSuper
  bool isConnected() => _connected;

  /// Return a stream that provide the status of the connection continuously.
  /// Default implementation ping the connect state every few seconds.
  /// Implementors: If your connection service provides a stream for connection status, use that instead.
  Stream<bool> connectStateStream() =>
      Stream.periodic(const Duration(seconds: 5)).map((_) => isConnected());

  /// Connect to the specified device.
  /// The device should be one of the devices returned by the `search` method from a compatible DeviceSearcherInterface class.
  /// Return true if connection successful or already connected, false otherwise.
  @nonVirtual
  Future<bool> connect() async {
    if (!_connected) {
      final result = await connectImpl(searchResult);
      _connected = true;

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
  Future<bool> connectImpl(DeviceSearchResult inDevice);

  /// Disconnect to the currently connected device.
  /// Return true if disconnection successful or already disconnected, false otherwise.
  @nonVirtual
  Future<bool> disconnect() async {
    if (_connected) {
      final result = await disconnectImpl();
      _connected = false;

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
}
