import 'package:flutter_device_searcher/search_result/device_search_result.dart';

class UsbResult implements DeviceSearchResult {
  const UsbResult({
    required this.id,
    this.manufacturer,
    this.product,
  });

  final String id;
  final String? manufacturer;
  final String? product;
}
