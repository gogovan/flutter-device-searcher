import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide Logger;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class FlutterDeviceSearcher {
  FlutterDeviceSearcher();

  /// Indicates whether a device search is ongoing.
  bool searching = false;

  /// Logger for Flutter Device Searcher.
  final logger = Logger('flutter_device_searcher');

  @internal
  final flutterBle = FlutterReactiveBle();
}
