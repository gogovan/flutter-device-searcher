import 'package:flutter/foundation.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';

@immutable
class BluetoothResult implements DeviceSearchResult {
  const BluetoothResult({required this.id, this.name, this.serviceIds = const []});

  final String id;
  final String? name;
  final List<String> serviceIds;

  @override
  String toString() => 'BluetoothResult{id: $id, name: $name, serviceIds: $serviceIds}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothResult &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
