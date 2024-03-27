import 'dart:async';

import 'package:flutter_device_searcher/device_searcher/device_searcher_interface.dart';
import 'package:flutter_device_searcher/flutter_device_searcher_platform_interface.dart';
import 'package:flutter_device_searcher/search_result/usb_result.dart';

class UsbSearcher extends DeviceSearcherInterface<UsbResult> {
  @override
  Stream<List<UsbResult>> search({
    Duration timeout = Duration.zero,
    void Function()? onTimeout,
  }) async* {
    await FlutterDeviceSearcherPlatform.instance.searchUsb();
    /*
    var start = DateTime.now();
    while (true) {
      if (timeout > Duration.zero && DateTime.now().difference(start) > timeout) {
        onTimeout?.call();
        break;
      }
      final devices = await QuickUsb.getDevicesWithDescription(requestPermission: false);
      final result = devices
          .map(
            (e) => UsbResult(
              id: e.device.identifier,
              manufacturer: e.manufacturer,
              product: e.product,
            ),
          )
          .toList();
      if (result.isNotEmpty) {
        start = DateTime.now();
      }
      yield result;

      await Future.delayed(const Duration(seconds: 1));
    }
    */
  }
}
