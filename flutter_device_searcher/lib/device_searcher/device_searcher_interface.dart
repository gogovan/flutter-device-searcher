import 'package:flutter_device_searcher/search_result/device_search_result.dart';

/// Interface all device searchers should implement.
abstract class DeviceSearcherInterface {
  /// Initiate a search for nearby device.
  /// Returns a list of `SearchResult`, allowing client to select one to be passed to the `connect` method on a compatible DeviceSearcherInterface class.
  ///
  /// Implementors should search for devices (using USB, WiFi, BLE etc) and return a list of found compatible devices.
  /// These devices should be indicated by an ID stored in a `PrinterSearchResult` instance.
  /// Such IDs should be able to be used to connect a specified printer.
  Stream<List<DeviceSearchResult>> search();

  /// Stop searching for nearby printers.
  ///
  /// If the searching method needs to be disconnected or otherwise closed, implement this method.
  /// Return true if closing is successful.
  Future<bool> stopSearch() => Future.value(true);
}
