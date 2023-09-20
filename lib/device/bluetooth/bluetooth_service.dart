import 'package:flutter/foundation.dart';

/// Denotes a Bluetooth LE Service.
/// Refer to [Bluetooth documentation](https://www.bluetooth.com/blog/a-developers-guide-to-bluetooth/) and
/// [iOS Core Bluetooth Overview](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html#//apple_ref/doc/uid/TP40013257-CH2-SW19) for details.
@immutable
class BluetoothService {
  const BluetoothService({
    required this.serviceId,
    required this.characteristics,
  });

  final String serviceId;
  final List<BluetoothCharacteristic> characteristics;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothService &&
          runtimeType == other.runtimeType &&
          serviceId == other.serviceId &&
          listEquals(characteristics, other.characteristics);

  @override
  int get hashCode => serviceId.hashCode ^ characteristics.hashCode;

  @override
  String toString() =>
      'BluetoothService{serviceId: $serviceId, characteristics: $characteristics}';
}

/// Denotes a Bluetooth LE Characteristic.
/// Refer to [Bluetooth documentation](https://www.bluetooth.com/blog/a-developers-guide-to-bluetooth/) and
/// [iOS Core Bluetooth Overview](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html#//apple_ref/doc/uid/TP40013257-CH2-SW19) for details.
@immutable
class BluetoothCharacteristic {
  const BluetoothCharacteristic({
    required this.serviceId,
    required this.characteristicId,
    this.isReadable = false,
    this.isWritableWithResponse = false,
    this.isWritableWithoutResponse = false,
    this.isNotifiable = false,
    this.isIndicatable = false,
  });

  final String serviceId;
  final String characteristicId;
  final bool isReadable;
  final bool isWritableWithResponse;
  final bool isWritableWithoutResponse;
  final bool isNotifiable;
  final bool isIndicatable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothCharacteristic &&
          runtimeType == other.runtimeType &&
          serviceId == other.serviceId &&
          characteristicId == other.characteristicId &&
          isReadable == other.isReadable &&
          isWritableWithResponse == other.isWritableWithResponse &&
          isWritableWithoutResponse == other.isWritableWithoutResponse &&
          isNotifiable == other.isNotifiable &&
          isIndicatable == other.isIndicatable;

  @override
  int get hashCode =>
      serviceId.hashCode ^
      characteristicId.hashCode ^
      isReadable.hashCode ^
      isWritableWithResponse.hashCode ^
      isWritableWithoutResponse.hashCode ^
      isNotifiable.hashCode ^
      isIndicatable.hashCode;

  @override
  String toString() =>
      'BluetoothCharacteristic{serviceId: $serviceId, characteristicId: $characteristicId, isReadable: $isReadable, isWritableWithResponse: $isWritableWithResponse, isWritableWithoutResponse: $isWritableWithoutResponse, isNotifiable: $isNotifiable, isIndicatable: $isIndicatable}';
}
