import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide Logger;
import 'package:logging/logging.dart';

class FlutterDeviceSearcher {
  FlutterDeviceSearcher({
    this.timeout = const Duration(seconds: 10),
  });

  final Duration timeout;

  final flutterBle = FlutterReactiveBle();

  final logger = Logger('flutter_device_searcher');
}
