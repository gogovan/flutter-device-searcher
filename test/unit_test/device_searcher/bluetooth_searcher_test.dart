import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_device_searcher/PermissionWrapper.dart';
import 'package:flutter_device_searcher/device_searcher/bluetooth_searcher.dart';
import 'package:flutter_device_searcher/exception/permission_denied_error.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bluetooth_searcher_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FlutterReactiveBle>(),
  MockSpec<PermissionWrapper>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final ble = MockFlutterReactiveBle();
  final permissionWrapper = MockPermissionWrapper();
  final searcher = BluetoothSearcher.withBle(ble, permissionWrapper);

  group('listen for devices', () {
    setUp(() {
      when(permissionWrapper.requestBluetoothPermissions()).thenAnswer(
        (_) => Future.value({
          Permission.bluetooth: PermissionStatus.granted,
          Permission.bluetoothConnect: PermissionStatus.granted,
          Permission.bluetoothScan: PermissionStatus.granted,
        }),
      );

      when(ble.statusStream).thenAnswer((_) => Stream.value(BleStatus.ready));
      when(ble.scanForDevices(withServices: [])).thenAnswer(
        (_) => Stream.value(
          DiscoveredDevice(
            id: '123',
            name: 'WXL-T12',
            manufacturerData: Uint8List(0),
            rssi: 12,
            serviceData: const {},
            serviceUuids: [Uuid.parse('abcd')],
          ),
        ),
      );
    });

    test('search', () async {
      await expectLater(
        searcher.search(),
        mayEmit(
          [
            const BluetoothResult(
              id: '123',
              name: 'WXL-T12',
              serviceIds: ['abcd'],
            ),
          ],
        ),
      );
    });
  });

  group('ble not ready at first, ready later', () {
    setUp(() {
      when(permissionWrapper.requestBluetoothPermissions()).thenAnswer(
        (_) => Future.value({
          Permission.bluetooth: PermissionStatus.granted,
          Permission.bluetoothConnect: PermissionStatus.granted,
          Permission.bluetoothScan: PermissionStatus.granted,
        }),
      );

      when(ble.statusStream).thenAnswer(
        (_) => Stream.fromIterable(
          [BleStatus.unknown, BleStatus.poweredOff, BleStatus.ready],
        ),
      );
      when(ble.scanForDevices(withServices: [])).thenAnswer(
        (_) => Stream.value(
          DiscoveredDevice(
            id: '123',
            name: 'WXL-T12',
            manufacturerData: Uint8List(0),
            rssi: 12,
            serviceData: const {},
            serviceUuids: [Uuid.parse('abcd')],
          ),
        ),
      );
    });

    test('search', () async {
      await expectLater(
        searcher.search(),
        mayEmit(
          [
            const BluetoothResult(
              id: '123',
              name: 'WXL-T12',
              serviceIds: ['abcd'],
            ),
          ],
        ),
      );
    });
  });

  group('permission not granted', () {
    setUp(() {
      when(permissionWrapper.requestBluetoothPermissions()).thenAnswer(
            (_) => Future.value({
          Permission.bluetooth: PermissionStatus.permanentlyDenied,
          Permission.bluetoothConnect: PermissionStatus.permanentlyDenied,
          Permission.bluetoothScan: PermissionStatus.permanentlyDenied,
        }),
      );
    });

    test('search', () async {
      await expectLater(
        searcher.search(),
        emitsError(isA<PermissionDeniedError>()),
      );
    });
  });
}
