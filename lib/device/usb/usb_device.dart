import 'dart:typed_data';

import 'package:flutter_device_searcher/device/device_interface.dart';
import 'package:flutter_device_searcher/flutter_device_searcher_platform_interface.dart';
import 'package:flutter_device_searcher/search_result/usb_result.dart';

class UsbDevice extends DeviceInterface<UsbResult> {
  UsbDevice(super.device);

  @override
  Future<bool> isConnected() async =>
      await super.isConnected() &&
      await FlutterDeviceSearcherPlatform.instance.isConnected();

  @override
  Future<bool> connectImpl(UsbResult inSearchResult) =>
      FlutterDeviceSearcherPlatform.instance
          .connect(inSearchResult.index.toString());

  @override
  Future<bool> disconnectImpl() =>
      FlutterDeviceSearcherPlatform.instance.disconnect();

  Future<bool> setInterfaceIndex(int interfaceIndex) =>
      FlutterDeviceSearcherPlatform.instance.setInterfaceIndex(interfaceIndex);

  Future<bool> setEndpointIndex(int endpointIndex) =>
      FlutterDeviceSearcherPlatform.instance.setEndpointIndex(endpointIndex);

  Future<Uint8List> read(int? length) =>
      FlutterDeviceSearcherPlatform.instance.read(length);

  Stream<Uint8List> readStream() =>
      FlutterDeviceSearcherPlatform.instance.readStream();

  Future<bool> write(Uint8List buffer) =>
      FlutterDeviceSearcherPlatform.instance.write(buffer);
}
