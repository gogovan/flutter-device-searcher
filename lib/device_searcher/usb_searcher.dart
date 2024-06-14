import 'dart:async';
import 'dart:convert';

import 'package:flutter_device_searcher/device_searcher/device_searcher_interface.dart';
import 'package:flutter_device_searcher/flutter_device_searcher_platform_interface.dart';
import 'package:flutter_device_searcher/search_result/usb_result.dart';

class UsbSearcher extends DeviceSearcherInterface<UsbResult> {
  @override
  Stream<List<UsbResult>> search({
    Duration timeout = Duration.zero,
    void Function()? onTimeout,
  }) async* {
    var start = DateTime.now();
    while (true) {
      if (timeout > Duration.zero &&
          DateTime.now().difference(start) > timeout) {
        onTimeout?.call();
        break;
      }
      final devicesJson =
          await FlutterDeviceSearcherPlatform.instance.searchUsb();
      final devicesObj = jsonDecode(devicesJson) as List<dynamic>;
      final result = devicesObj
          .map(
            (e) => UsbResult(
              deviceName: e['deviceName'] as String,
              vendorId: e['vendorId'] as String?,
              productId: e['productId'] as String?,
              serialNumber: e['serialNumber'] as String?,
              deviceClass: e['deviceClass'] as String?,
              deviceSubclass: e['deviceSubclass'] as String?,
              deviceProtocol: e['deviceProtocol'] as String?,
              interfaces: (jsonDecode(e['interfaces']) as List<dynamic>?)
                  ?.map(
                    (e) => UsbInterfaceResult(
                      interfaceClass: e['interfaceClass'] as String?,
                      interfaceSubclass: e['interfaceSubclass'] as String?,
                      interfaceProtocol: e['interfaceProtocol'] as String?,
                      endpoints: (jsonDecode(e['endpoints']) as List<dynamic>?)
                          ?.map(
                            (e) => UsbEndpointResult(
                              endpointNumber: int.tryParse(
                                e['endpointNumber'] as String? ?? '',
                              ),
                              direction: e['direction'] as String?,
                              type: e['type'] as String?,
                              maxPacketSize: int.tryParse(
                                e['maxPacketSize'] as String? ?? '',
                              ),
                              interval:
                                  int.tryParse(e['interval'] as String? ?? ''),
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList();

      if (result.isNotEmpty) {
        start = DateTime.now();
      }
      yield result;

      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
