import 'package:flutter_device_searcher/device/device_interface.dart';
import 'package:flutter_device_searcher/flutter_device_searcher_platform_interface.dart';
import 'package:flutter_device_searcher/search_result/usb_result.dart';

class UsbDevice extends DeviceInterface<UsbResult> {
  UsbDevice(super.device);

  @override
  Future<bool> connectImpl(UsbResult inSearchResult) =>
      FlutterDeviceSearcherPlatform.instance.connect(inSearchResult.deviceName);

  @override
  Future<bool> disconnectImpl() =>
      FlutterDeviceSearcherPlatform.instance.disconnect();
}
