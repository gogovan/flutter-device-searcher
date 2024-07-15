import 'package:flutter/foundation.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';

@immutable
class UsbInterfaceResult {
  const UsbInterfaceResult({
    required this.interfaceClass,
    required this.interfaceSubclass,
    required this.interfaceProtocol,
    required this.endpoints,
  });

  final String? interfaceClass;
  final String? interfaceSubclass;
  final String? interfaceProtocol;
  final List<UsbEndpointResult>? endpoints;

  @override
  String toString() => 'UsbInterfaceResult('
      'interfaceClass: $interfaceClass, '
      'interfaceSubclass: $interfaceSubclass, '
      'interfaceProtocol: $interfaceProtocol, '
      'endpointCount: $endpoints'
      ')';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UsbInterfaceResult &&
        other.interfaceClass == interfaceClass &&
        other.interfaceSubclass == interfaceSubclass &&
        other.interfaceProtocol == interfaceProtocol &&
        other.endpoints == endpoints;
  }

  @override
  int get hashCode =>
      interfaceClass.hashCode ^
      interfaceSubclass.hashCode ^
      interfaceProtocol.hashCode ^
      endpoints.hashCode;
}

@immutable
class UsbEndpointResult {
  const UsbEndpointResult({
    required this.endpointNumber,
    required this.direction,
    required this.type,
    required this.maxPacketSize,
    required this.interval,
  });

  final int? endpointNumber;
  final String? direction;
  final String? type;
  final int? maxPacketSize;
  final int? interval;

  @override
  String toString() => 'UsbEndpointResult('
      'endpointNumber: $endpointNumber, '
      'direction: $direction, '
      'type: $type, '
      'maxPacketSize: $maxPacketSize, '
      'interval: $interval'
      ')';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UsbEndpointResult &&
        other.endpointNumber == endpointNumber &&
        other.direction == direction &&
        other.type == type &&
        other.maxPacketSize == maxPacketSize &&
        other.interval == interval;
  }

  @override
  int get hashCode =>
      endpointNumber.hashCode ^
      direction.hashCode ^
      type.hashCode ^
      maxPacketSize.hashCode ^
      interval.hashCode;
}

class UsbResult implements DeviceSearchResult {
  const UsbResult({
    required this.index,
    required this.deviceName,
    this.vendorId,
    this.productId,
    this.serialNumber,
    this.deviceClass,
    this.deviceSubclass,
    this.deviceProtocol,
    this.interfaces,
  });

  final int index;
  final String deviceName;
  final String? vendorId;
  final String? productId;
  final String? serialNumber;
  final String? deviceClass;
  final String? deviceSubclass;
  final String? deviceProtocol;
  final List<UsbInterfaceResult>? interfaces;

  @override
  String toString() => 'UsbResult('
      'deviceName: $deviceName, '
      'vendorId: $vendorId, '
      'productId: $productId, '
      'serialNumber: $serialNumber, '
      'deviceClass: $deviceClass, '
      'deviceSubclass: $deviceSubclass, '
      'deviceProtocol: $deviceProtocol, '
      'interfaces: $interfaces'
      ')';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UsbResult &&
        other.deviceName == deviceName &&
        other.vendorId == vendorId &&
        other.productId == productId &&
        other.serialNumber == serialNumber &&
        other.deviceClass == deviceClass &&
        other.deviceSubclass == deviceSubclass &&
        other.deviceProtocol == deviceProtocol &&
        listEquals(other.interfaces, interfaces);
  }

  @override
  int get hashCode =>
      deviceName.hashCode ^
      vendorId.hashCode ^
      productId.hashCode ^
      serialNumber.hashCode ^
      deviceClass.hashCode ^
      deviceSubclass.hashCode ^
      deviceProtocol.hashCode ^
      interfaces.hashCode;
}
