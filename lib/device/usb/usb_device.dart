import 'package:flutter_device_searcher/device/device_interface.dart';
import 'package:flutter_device_searcher/search_result/usb_result.dart';

class UsbDevice extends DeviceInterface<UsbResult> {
  UsbDevice(super.device);

  @override
  Future<bool> connectImpl(UsbResult inSearchResult) {
    // TODO: implement connectImpl
    throw UnimplementedError();
  }

  @override
  Future<bool> disconnectImpl() {
    // TODO: implement disconnectImpl
    throw UnimplementedError();
  }
}
