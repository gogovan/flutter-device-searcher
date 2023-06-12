import 'package:flutter/foundation.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';

@immutable
class BluetoothResult implements DeviceSearchResult {
  const BluetoothResult(this.address);

  final String address;

  @override
  String toString() => 'BluetoothResult{address: $address}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothResult &&
          runtimeType == other.runtimeType &&
          address == other.address;

  @override
  int get hashCode => address.hashCode;
}
