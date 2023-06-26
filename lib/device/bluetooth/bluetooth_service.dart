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
}
