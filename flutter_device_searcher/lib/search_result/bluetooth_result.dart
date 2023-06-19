import 'package:flutter/foundation.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';

@immutable
class BluetoothResult implements DeviceSearchResult {
  const BluetoothResult({required this.id, this.name});

  final String id;
  final String? name;

  @override
  String toString() => 'BluetoothResult{address: $id, name: $name}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothResult &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
