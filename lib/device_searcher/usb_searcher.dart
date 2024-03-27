import 'package:flutter_device_searcher/device_searcher/device_searcher_interface.dart';
import 'package:flutter_device_searcher/search_result/usb_result.dart';
import 'package:usb_serial/usb_serial.dart';

class UsbSearcher extends DeviceSearcherInterface<UsbResult> {
  @override
  Stream<List<UsbResult>> search({
    Duration timeout = Duration.zero,
    void Function()? onTimeout,
  }) =>
      UsbSerial.listDevices()
          .asStream()
          .map(
            (event) => event
                .map(
                  (e) => UsbResult(
                    id: e.deviceId?.toString() ?? '',
                    name: e.deviceName,
                  ),
                )
                .toList(),
          )
          .timeout(
        timeout,
        onTimeout: (_) {
          onTimeout?.call();
        },
      );
}
