import 'package:flutter_device_searcher/search_result/device_search_result.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide Logger;
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
  Stream<List<T>> search();

  /// Indicates whether a device search is ongoing.
  bool searching = false;

  /// Logger for Flutter Device Searcher.
  final logger = Logger('flutter_device_searcher');

  @internal
  final flutterBle = FlutterReactiveBle();
}
