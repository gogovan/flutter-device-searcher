import 'package:flutter/foundation.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';

@immutable
class BluetoothResult implements DeviceSearchResult {
  const BluetoothResult({required this.address, this.name});

  final String address;
  final String? name;

  @override
  String toString() => 'BluetoothResult{address: $address, name: $name}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothResult &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          name == other.name;

  @override
  int get hashCode => address.hashCode ^ name.hashCode;
}
