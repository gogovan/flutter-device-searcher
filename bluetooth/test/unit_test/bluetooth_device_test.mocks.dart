// Mocks generated by Mockito 5.4.4 from annotations
// in flutter_device_searcher_bluetooth/test/unit_test/bluetooth_device_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:flutter_device_searcher/permission_wrapper.dart' as _i3;
import 'package:flutter_device_searcher_bluetooth/bluetooth_result.dart' as _i8;
import 'package:flutter_device_searcher_bluetooth/bluetooth_searcher.dart'
    as _i6;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as _i2;
import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart'
    as _i5;
import 'package:logging/logging.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i9;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFlutterReactiveBle_0 extends _i1.SmartFake
    implements _i2.FlutterReactiveBle {
  _FakeFlutterReactiveBle_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePermissionWrapper_1 extends _i1.SmartFake
    implements _i3.PermissionWrapper {
  _FakePermissionWrapper_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLogger_2 extends _i1.SmartFake implements _i4.Logger {
  _FakeLogger_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDiscoveredDevicesRegistryImpl_3 extends _i1.SmartFake
    implements _i5.DiscoveredDevicesRegistryImpl {
  _FakeDiscoveredDevicesRegistryImpl_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCharacteristic_4 extends _i1.SmartFake
    implements _i2.Characteristic {
  _FakeCharacteristic_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUuid_5 extends _i1.SmartFake implements _i2.Uuid {
  _FakeUuid_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeService_6 extends _i1.SmartFake implements _i2.Service {
  _FakeService_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [BluetoothSearcher].
///
/// See the documentation for Mockito's code generation for more information.
class MockBluetoothSearcher extends _i1.Mock implements _i6.BluetoothSearcher {
  @override
  _i2.FlutterReactiveBle get flutterBle => (super.noSuchMethod(
        Invocation.getter(#flutterBle),
        returnValue: _FakeFlutterReactiveBle_0(
          this,
          Invocation.getter(#flutterBle),
        ),
        returnValueForMissingStub: _FakeFlutterReactiveBle_0(
          this,
          Invocation.getter(#flutterBle),
        ),
      ) as _i2.FlutterReactiveBle);

  @override
  _i3.PermissionWrapper get permissionWrapper => (super.noSuchMethod(
        Invocation.getter(#permissionWrapper),
        returnValue: _FakePermissionWrapper_1(
          this,
          Invocation.getter(#permissionWrapper),
        ),
        returnValueForMissingStub: _FakePermissionWrapper_1(
          this,
          Invocation.getter(#permissionWrapper),
        ),
      ) as _i3.PermissionWrapper);

  @override
  bool get searching => (super.noSuchMethod(
        Invocation.getter(#searching),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set searching(bool? _searching) => super.noSuchMethod(
        Invocation.setter(
          #searching,
          _searching,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Logger get logger => (super.noSuchMethod(
        Invocation.getter(#logger),
        returnValue: _FakeLogger_2(
          this,
          Invocation.getter(#logger),
        ),
        returnValueForMissingStub: _FakeLogger_2(
          this,
          Invocation.getter(#logger),
        ),
      ) as _i4.Logger);

  @override
  _i7.Stream<List<_i8.BluetoothResult>> search({
    Duration? timeout = Duration.zero,
    void Function()? onTimeout,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #search,
          [],
          {
            #timeout: timeout,
            #onTimeout: onTimeout,
          },
        ),
        returnValue: _i7.Stream<List<_i8.BluetoothResult>>.empty(),
        returnValueForMissingStub:
            _i7.Stream<List<_i8.BluetoothResult>>.empty(),
      ) as _i7.Stream<List<_i8.BluetoothResult>>);

  @override
  bool isReady() => (super.noSuchMethod(
        Invocation.method(
          #isReady,
          [],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i7.Stream<bool> connectStateStream() => (super.noSuchMethod(
        Invocation.method(
          #connectStateStream,
          [],
        ),
        returnValue: _i7.Stream<bool>.empty(),
        returnValueForMissingStub: _i7.Stream<bool>.empty(),
      ) as _i7.Stream<bool>);

  @override
  bool isSearching() => (super.noSuchMethod(
        Invocation.method(
          #isSearching,
          [],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
}

/// A class which mocks [FlutterReactiveBle].
///
/// See the documentation for Mockito's code generation for more information.
class MockFlutterReactiveBle extends _i1.Mock
    implements _i2.FlutterReactiveBle {
  @override
  _i5.DiscoveredDevicesRegistryImpl get scanRegistry => (super.noSuchMethod(
        Invocation.getter(#scanRegistry),
        returnValue: _FakeDiscoveredDevicesRegistryImpl_3(
          this,
          Invocation.getter(#scanRegistry),
        ),
        returnValueForMissingStub: _FakeDiscoveredDevicesRegistryImpl_3(
          this,
          Invocation.getter(#scanRegistry),
        ),
      ) as _i5.DiscoveredDevicesRegistryImpl);

  @override
  _i7.Stream<_i2.BleStatus> get statusStream => (super.noSuchMethod(
        Invocation.getter(#statusStream),
        returnValue: _i7.Stream<_i2.BleStatus>.empty(),
        returnValueForMissingStub: _i7.Stream<_i2.BleStatus>.empty(),
      ) as _i7.Stream<_i2.BleStatus>);

  @override
  _i2.BleStatus get status => (super.noSuchMethod(
        Invocation.getter(#status),
        returnValue: _i2.BleStatus.unknown,
        returnValueForMissingStub: _i2.BleStatus.unknown,
      ) as _i2.BleStatus);

  @override
  _i7.Stream<_i2.ConnectionStateUpdate> get connectedDeviceStream =>
      (super.noSuchMethod(
        Invocation.getter(#connectedDeviceStream),
        returnValue: _i7.Stream<_i2.ConnectionStateUpdate>.empty(),
        returnValueForMissingStub:
            _i7.Stream<_i2.ConnectionStateUpdate>.empty(),
      ) as _i7.Stream<_i2.ConnectionStateUpdate>);

  @override
  _i7.Stream<_i2.CharacteristicValue> get characteristicValueStream =>
      (super.noSuchMethod(
        Invocation.getter(#characteristicValueStream),
        returnValue: _i7.Stream<_i2.CharacteristicValue>.empty(),
        returnValueForMissingStub: _i7.Stream<_i2.CharacteristicValue>.empty(),
      ) as _i7.Stream<_i2.CharacteristicValue>);

  @override
  set logLevel(_i2.LogLevel? logLevel) => super.noSuchMethod(
        Invocation.setter(
          #logLevel,
          logLevel,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.LogLevel get logLevel => (super.noSuchMethod(
        Invocation.getter(#logLevel),
        returnValue: _i2.LogLevel.none,
        returnValueForMissingStub: _i2.LogLevel.none,
      ) as _i2.LogLevel);

  @override
  _i7.Future<void> initialize() => (super.noSuchMethod(
        Invocation.method(
          #initialize,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> deinitialize() => (super.noSuchMethod(
        Invocation.method(
          #deinitialize,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<List<int>> readCharacteristic(
          _i2.QualifiedCharacteristic? characteristic) =>
      (super.noSuchMethod(
        Invocation.method(
          #readCharacteristic,
          [characteristic],
        ),
        returnValue: _i7.Future<List<int>>.value(<int>[]),
        returnValueForMissingStub: _i7.Future<List<int>>.value(<int>[]),
      ) as _i7.Future<List<int>>);

  @override
  _i7.Future<void> writeCharacteristicWithResponse(
    _i2.QualifiedCharacteristic? characteristic, {
    required List<int>? value,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #writeCharacteristicWithResponse,
          [characteristic],
          {#value: value},
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> writeCharacteristicWithoutResponse(
    _i2.QualifiedCharacteristic? characteristic, {
    required List<int>? value,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #writeCharacteristicWithoutResponse,
          [characteristic],
          {#value: value},
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<int> requestMtu({
    required String? deviceId,
    required int? mtu,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #requestMtu,
          [],
          {
            #deviceId: deviceId,
            #mtu: mtu,
          },
        ),
        returnValue: _i7.Future<int>.value(0),
        returnValueForMissingStub: _i7.Future<int>.value(0),
      ) as _i7.Future<int>);

  @override
  _i7.Future<void> requestConnectionPriority({
    required String? deviceId,
    required _i2.ConnectionPriority? priority,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #requestConnectionPriority,
          [],
          {
            #deviceId: deviceId,
            #priority: priority,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Stream<_i2.DiscoveredDevice> scanForDevices({
    required List<_i2.Uuid>? withServices,
    _i2.ScanMode? scanMode = _i2.ScanMode.balanced,
    bool? requireLocationServicesEnabled = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #scanForDevices,
          [],
          {
            #withServices: withServices,
            #scanMode: scanMode,
            #requireLocationServicesEnabled: requireLocationServicesEnabled,
          },
        ),
        returnValue: _i7.Stream<_i2.DiscoveredDevice>.empty(),
        returnValueForMissingStub: _i7.Stream<_i2.DiscoveredDevice>.empty(),
      ) as _i7.Stream<_i2.DiscoveredDevice>);

  @override
  _i7.Stream<_i2.ConnectionStateUpdate> connectToDevice({
    required String? id,
    Map<_i2.Uuid, List<_i2.Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #connectToDevice,
          [],
          {
            #id: id,
            #servicesWithCharacteristicsToDiscover:
                servicesWithCharacteristicsToDiscover,
            #connectionTimeout: connectionTimeout,
          },
        ),
        returnValue: _i7.Stream<_i2.ConnectionStateUpdate>.empty(),
        returnValueForMissingStub:
            _i7.Stream<_i2.ConnectionStateUpdate>.empty(),
      ) as _i7.Stream<_i2.ConnectionStateUpdate>);

  @override
  _i7.Stream<_i2.ConnectionStateUpdate> connectToAdvertisingDevice({
    required String? id,
    required List<_i2.Uuid>? withServices,
    required Duration? prescanDuration,
    Map<_i2.Uuid, List<_i2.Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #connectToAdvertisingDevice,
          [],
          {
            #id: id,
            #withServices: withServices,
            #prescanDuration: prescanDuration,
            #servicesWithCharacteristicsToDiscover:
                servicesWithCharacteristicsToDiscover,
            #connectionTimeout: connectionTimeout,
          },
        ),
        returnValue: _i7.Stream<_i2.ConnectionStateUpdate>.empty(),
        returnValueForMissingStub:
            _i7.Stream<_i2.ConnectionStateUpdate>.empty(),
      ) as _i7.Stream<_i2.ConnectionStateUpdate>);

  @override
  _i7.Future<List<_i2.DiscoveredService>> discoverServices(String? deviceId) =>
      (super.noSuchMethod(
        Invocation.method(
          #discoverServices,
          [deviceId],
        ),
        returnValue: _i7.Future<List<_i2.DiscoveredService>>.value(
            <_i2.DiscoveredService>[]),
        returnValueForMissingStub:
            _i7.Future<List<_i2.DiscoveredService>>.value(
                <_i2.DiscoveredService>[]),
      ) as _i7.Future<List<_i2.DiscoveredService>>);

  @override
  _i7.Future<void> discoverAllServices(String? deviceId) => (super.noSuchMethod(
        Invocation.method(
          #discoverAllServices,
          [deviceId],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<List<_i2.Service>> getDiscoveredServices(String? deviceId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDiscoveredServices,
          [deviceId],
        ),
        returnValue: _i7.Future<List<_i2.Service>>.value(<_i2.Service>[]),
        returnValueForMissingStub:
            _i7.Future<List<_i2.Service>>.value(<_i2.Service>[]),
      ) as _i7.Future<List<_i2.Service>>);

  @override
  _i7.Future<void> clearGattCache(String? deviceId) => (super.noSuchMethod(
        Invocation.method(
          #clearGattCache,
          [deviceId],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<int> readRssi(String? deviceId) => (super.noSuchMethod(
        Invocation.method(
          #readRssi,
          [deviceId],
        ),
        returnValue: _i7.Future<int>.value(0),
        returnValueForMissingStub: _i7.Future<int>.value(0),
      ) as _i7.Future<int>);

  @override
  _i7.Stream<List<int>> subscribeToCharacteristic(
          _i2.QualifiedCharacteristic? characteristic) =>
      (super.noSuchMethod(
        Invocation.method(
          #subscribeToCharacteristic,
          [characteristic],
        ),
        returnValue: _i7.Stream<List<int>>.empty(),
        returnValueForMissingStub: _i7.Stream<List<int>>.empty(),
      ) as _i7.Stream<List<int>>);

  @override
  _i7.Future<Iterable<_i2.Characteristic>> resolve(
          _i2.QualifiedCharacteristic? characteristic) =>
      (super.noSuchMethod(
        Invocation.method(
          #resolve,
          [characteristic],
        ),
        returnValue: _i7.Future<Iterable<_i2.Characteristic>>.value(
            <_i2.Characteristic>[]),
        returnValueForMissingStub:
            _i7.Future<Iterable<_i2.Characteristic>>.value(
                <_i2.Characteristic>[]),
      ) as _i7.Future<Iterable<_i2.Characteristic>>);

  @override
  _i7.Future<_i2.Characteristic> resolveSingle(
          _i2.QualifiedCharacteristic? characteristic) =>
      (super.noSuchMethod(
        Invocation.method(
          #resolveSingle,
          [characteristic],
        ),
        returnValue: _i7.Future<_i2.Characteristic>.value(_FakeCharacteristic_4(
          this,
          Invocation.method(
            #resolveSingle,
            [characteristic],
          ),
        )),
        returnValueForMissingStub:
            _i7.Future<_i2.Characteristic>.value(_FakeCharacteristic_4(
          this,
          Invocation.method(
            #resolveSingle,
            [characteristic],
          ),
        )),
      ) as _i7.Future<_i2.Characteristic>);
}

/// A class which mocks [Service].
///
/// See the documentation for Mockito's code generation for more information.
class MockService extends _i1.Mock implements _i2.Service {
  @override
  _i2.Uuid get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: _FakeUuid_5(
          this,
          Invocation.getter(#id),
        ),
        returnValueForMissingStub: _FakeUuid_5(
          this,
          Invocation.getter(#id),
        ),
      ) as _i2.Uuid);

  @override
  String get deviceId => (super.noSuchMethod(
        Invocation.getter(#deviceId),
        returnValue: _i9.dummyValue<String>(
          this,
          Invocation.getter(#deviceId),
        ),
        returnValueForMissingStub: _i9.dummyValue<String>(
          this,
          Invocation.getter(#deviceId),
        ),
      ) as String);

  @override
  List<_i2.Characteristic> get characteristics => (super.noSuchMethod(
        Invocation.getter(#characteristics),
        returnValue: <_i2.Characteristic>[],
        returnValueForMissingStub: <_i2.Characteristic>[],
      ) as List<_i2.Characteristic>);
}

/// A class which mocks [Characteristic].
///
/// See the documentation for Mockito's code generation for more information.
class MockCharacteristic extends _i1.Mock implements _i2.Characteristic {
  @override
  _i2.Uuid get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: _FakeUuid_5(
          this,
          Invocation.getter(#id),
        ),
        returnValueForMissingStub: _FakeUuid_5(
          this,
          Invocation.getter(#id),
        ),
      ) as _i2.Uuid);

  @override
  _i2.Service get service => (super.noSuchMethod(
        Invocation.getter(#service),
        returnValue: _FakeService_6(
          this,
          Invocation.getter(#service),
        ),
        returnValueForMissingStub: _FakeService_6(
          this,
          Invocation.getter(#service),
        ),
      ) as _i2.Service);

  @override
  bool get isReadable => (super.noSuchMethod(
        Invocation.getter(#isReadable),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool get isWritableWithoutResponse => (super.noSuchMethod(
        Invocation.getter(#isWritableWithoutResponse),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool get isWritableWithResponse => (super.noSuchMethod(
        Invocation.getter(#isWritableWithResponse),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool get isNotifiable => (super.noSuchMethod(
        Invocation.getter(#isNotifiable),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool get isIndicatable => (super.noSuchMethod(
        Invocation.getter(#isIndicatable),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i7.Future<List<int>> read() => (super.noSuchMethod(
        Invocation.method(
          #read,
          [],
        ),
        returnValue: _i7.Future<List<int>>.value(<int>[]),
        returnValueForMissingStub: _i7.Future<List<int>>.value(<int>[]),
      ) as _i7.Future<List<int>>);

  @override
  _i7.Future<void> write(
    List<int>? value, {
    bool? withResponse = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #write,
          [value],
          {#withResponse: withResponse},
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Stream<List<int>> subscribe() => (super.noSuchMethod(
        Invocation.method(
          #subscribe,
          [],
        ),
        returnValue: _i7.Stream<List<int>>.empty(),
        returnValueForMissingStub: _i7.Stream<List<int>>.empty(),
      ) as _i7.Stream<List<int>>);
}