import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class FlutterDeviceSearcher {
  FlutterDeviceSearcher({
    this.timeout = const Duration(seconds: 10),
  });

  final Duration timeout;

  final flutterBle = FlutterReactiveBle();
}
