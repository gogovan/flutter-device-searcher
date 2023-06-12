import 'package:flutter/foundation.dart';

@immutable
class BluetoothResult {
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
