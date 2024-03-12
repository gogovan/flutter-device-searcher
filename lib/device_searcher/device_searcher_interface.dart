import 'package:flutter_device_searcher/search_result/device_search_result.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// Interface all device searchers should implement.
abstract class DeviceSearcherInterface<T extends DeviceSearchResult> {
  /// Initiate a search for nearby device.
  /// Returns a list of `SearchResult`, allowing client to select one to be passed to the `connect` method on a compatible DeviceSearcherInterface class.
  ///
  /// Implementation contract:
  /// 1. Implementors should search for devices (using USB, WiFi, BLE etc) and return a list of found compatible devices.
  /// These devices should be indicated by an ID stored in a `DeviceSearchResult` instance.
  /// Such IDs should be able to be used to connect a specified device.
  /// 2. The search should be stopped when the returned stream is cancelled.
  /// 3. Use the provided timeout, if greater than zero, and stop searching if the timeout is reached.
  Stream<List<T>> search({Duration timeout = Duration.zero});

  /// Indicates whether a device search is ongoing.
  @protected
  bool searching = false;

  bool isSearching() => searching;

  /// Logger for Flutter Device Searcher.
  final logger = Logger('flutter_device_searcher');
}
