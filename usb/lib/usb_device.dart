import 'dart:typed_data';

import 'package:flutter_device_searcher/device/device_interface.dart';
import 'usb_result.dart';
import 'package:flutter_device_searcher_usb/usb_platform_interface.dart';
import 'package:rxdart/streams.dart';

class UsbDevice extends DeviceInterface<UsbResult> {
  UsbDevice(super.device);

  @override
  Future<bool> isConnected() async =>
      await super.isConnected() && await UsbPlatform.instance.isConnected();

  @override
  Stream<bool> connectStateStream() => CombineLatestStream(
        [
          super.connectStateStream(),
          Stream.periodic(const Duration(seconds: 1))
              .asyncMap((event) => isConnected()),
        ],
        (values) => values[0] && values[1],
      );

  @override
  Future<bool> connectImpl(UsbResult inSearchResult) =>
      UsbPlatform.instance.connect(inSearchResult.index.toString());

  @override
  Future<bool> disconnectImpl() => UsbPlatform.instance.disconnect();

  Future<bool> setInterfaceIndex(int interfaceIndex) =>
      UsbPlatform.instance.setInterfaceIndex(interfaceIndex);

  Future<bool> setEndpointIndex(int endpointIndex) =>
      UsbPlatform.instance.setEndpointIndex(endpointIndex);

  Future<Uint8List> read(int? length) => UsbPlatform.instance.read(length);

  Stream<Uint8List> readStream() => UsbPlatform.instance.readStream();

  Future<bool> write(Uint8List buffer) => UsbPlatform.instance.write(buffer);
}
