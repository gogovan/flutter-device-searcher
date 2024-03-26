import 'dart:io';

import 'package:flutter_device_searcher/device/bluetooth/bluetooth_device.dart';
import 'package:flutter_device_searcher/device/bluetooth/bluetooth_service.dart';
import 'package:flutter_device_searcher/device_searcher/bluetooth_searcher.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide Logger;
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bluetooth_device_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BluetoothSearcher>(),
  MockSpec<FlutterReactiveBle>(),
  MockSpec<Service>(),
  MockSpec<Characteristic>(),
])
void main() {
  const deviceId = '09871234-abcd-dbcd-dddd-123456781234';
  final searcher = MockBluetoothSearcher();
  const btResult =
      BluetoothResult(id: deviceId, name: 'WXL-T12', serviceIds: ['123']);
  final reactiveBle = MockFlutterReactiveBle();

  setUp(() {
    when(searcher.isSearching()).thenReturn(false);
    when(searcher.flutterBle).thenReturn(reactiveBle);
    when(searcher.logger).thenReturn(Logger('logger'));
  });

  group('connect success / disconnect', () {
    final device = BluetoothDevice(searcher, btResult);

    setUp(() {
      when(reactiveBle.connectToDevice(id: deviceId)).thenAnswer(
        (realInvocation) => Stream.fromIterable([
          const ConnectionStateUpdate(
            deviceId: deviceId,
            connectionState: DeviceConnectionState.connecting,
            failure: null,
          ),
          const ConnectionStateUpdate(
            deviceId: deviceId,
            connectionState: DeviceConnectionState.connected,
            failure: null,
          ),
        ]),
      );

      when(searcher.isReady()).thenReturn(true);
      when(searcher.connectStateStream()).thenAnswer((_) => Stream.value(true));
    });

    tearDown(device.dispose);

    test('connect/disconnect success', () async {
      expect(await device.connect(), true);
      expect(device.isConnected(), true);
      await device.disconnect();
      expect(device.isConnected(), false);
      expect(await device.connectStateStream().take(2).toList(), [true, false]);
    });
  });

  group('connect / Bluetooth not connected', () {
    final device = BluetoothDevice(searcher, btResult);

    setUp(() {
      when(reactiveBle.connectToDevice(id: deviceId)).thenAnswer(
            (realInvocation) => Stream.fromIterable([
          const ConnectionStateUpdate(
            deviceId: deviceId,
            connectionState: DeviceConnectionState.connecting,
            failure: null,
          ),
          const ConnectionStateUpdate(
            deviceId: deviceId,
            connectionState: DeviceConnectionState.connected,
            failure: null,
          ),
        ]),
      );

      when(searcher.isReady()).thenReturn(false);
      when(searcher.connectStateStream()).thenAnswer((_) => Stream.value(false));
    });

    tearDown(device.dispose);

    test('connect/disconnect success', () async {
      expect(await device.connect(), true);
      expect(device.isConnected(), false);
      await device.disconnect();
      expect(device.isConnected(), false);
      expect(await device.connectStateStream().take(2).toList(), [false, false]);
    });
  });

  group('device connected', () {
    final device = BluetoothDevice(searcher, btResult);

    setUp(() {
      when(reactiveBle.connectToDevice(id: deviceId)).thenAnswer(
        (realInvocation) => Stream.fromIterable([
          const ConnectionStateUpdate(
            deviceId: deviceId,
            connectionState: DeviceConnectionState.connected,
            failure: null,
          ),
        ]),
      );
      when(reactiveBle.statusStream).thenAnswer(
        (realInvocation) => Stream.value(BleStatus.ready),
      );
      when(searcher.isReady()).thenReturn(true);
    });

    // tearDown(device.dispose);

    group('get services', () {
      const serviceId = '12341234-9876-1234-abcd-12345678abcd';
      final serviceUuid = Uuid.parse(serviceId);
      const characteristicId = '09870987-abcd-defe-ffff-123456789012';
      final characteristicUuid = Uuid.parse(characteristicId);
      final service = MockService();
      final characteristic = MockCharacteristic();

      setUp(() {
        when(service.id).thenReturn(serviceUuid);
        when(service.characteristics).thenReturn([characteristic]);
        when(characteristic.id).thenReturn(characteristicUuid);
        when(characteristic.service).thenReturn(service);
        when(characteristic.isReadable).thenReturn(true);
        when(characteristic.isWritableWithResponse).thenReturn(false);
        when(characteristic.isWritableWithoutResponse).thenReturn(true);
        when(characteristic.isNotifiable).thenReturn(true);
        when(characteristic.isIndicatable).thenReturn(false);

        when(reactiveBle.getDiscoveredServices(deviceId)).thenAnswer(
          (realInvocation) => Future.value([service]),
        );

        when(
          reactiveBle.readCharacteristic(
            QualifiedCharacteristic(
              characteristicId: characteristicUuid,
              serviceId: serviceUuid,
              deviceId: deviceId,
            ),
          ),
        ).thenAnswer((realInvocation) async => [2, 5, 10]);

        when(
          reactiveBle.subscribeToCharacteristic(
            QualifiedCharacteristic(
              characteristicId: characteristicUuid,
              serviceId: serviceUuid,
              deviceId: deviceId,
            ),
          ),
        ).thenAnswer((realInvocation) => Stream.value([3, 4, 5]));
      });

      test('get service', () async {
        expect(await device.connect(), true);
        expect(await device.getServices(), [
          const BluetoothService(
            serviceId: serviceId,
            characteristics: [
              BluetoothCharacteristic(
                serviceId: serviceId,
                characteristicId: characteristicId,
                isReadable: true,
                isWritableWithoutResponse: true,
                isNotifiable: true,
              ),
            ],
          ),
        ]);
      });

      test('read', () async {
        expect(await device.connect(), true);
        expect(
          await device.read(serviceId, characteristicId),
          [2, 5, 10],
        );
      });

      test('readAsStream', () async {
        expect(await device.connect(), true);
        await expectLater(
          device.readAsStream(serviceId, characteristicId),
          emitsInOrder([
            [3, 4, 5],
          ]),
        );
      });

      test('write', () async {
        expect(await device.connect(), true);
        await device.write([7, 24, 25], serviceId, characteristicId);
        verify(
          reactiveBle.writeCharacteristicWithoutResponse(
            QualifiedCharacteristic(
              characteristicId: Uuid.parse(characteristicId),
              serviceId: Uuid.parse(serviceId),
              deviceId: deviceId,
            ),
            value: [7, 24, 25],
          ),
        ).called(1);
      });
    });
  });

  group('device connect error', () {
    final device = BluetoothDevice(searcher, btResult);

    setUp(() {
      when(reactiveBle.connectToDevice(id: deviceId)).thenAnswer(
        (realInvocation) => Stream.error(const HandshakeException('error')),
      );
    });

    test('connect error', () async {
      await expectLater(
        device.connect,
        throwsA(isA<HandshakeException>()),
      );
    });
  });
}
