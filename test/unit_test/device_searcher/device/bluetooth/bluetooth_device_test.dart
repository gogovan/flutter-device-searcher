import 'package:flutter_device_searcher/device/bluetooth/bluetooth_device.dart';
import 'package:flutter_device_searcher/device/bluetooth/bluetooth_service.dart';
import 'package:flutter_device_searcher/device_searcher/bluetooth_searcher.dart';
import 'package:flutter_device_searcher/exception/device_connection_error.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bluetooth_device_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BluetoothSearcher>(),
  MockSpec<FlutterReactiveBle>(),
])
void main() {
  const deviceId = '09871234-abcd-dbcd-dddd-123456781234';
  final searcher = MockBluetoothSearcher();
  const btResult =
      BluetoothResult(id: deviceId, name: 'WXL-T12', serviceIds: ['123']);
  final reactiveBle = MockFlutterReactiveBle();
  final device = BluetoothDevice(searcher, btResult);

  setUp(() {
    when(searcher.isSearching()).thenReturn(false);
    when(searcher.flutterBle).thenReturn(reactiveBle);
  });

  group('connect success / disconnect', () {
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
    });

    test('connect/disconnect success', () async {
      await expectLater(device.connect(), emitsInOrder([true]));
      expect(device.isConnected(), true);
      await device.disconnect();
      expect(device.isConnected(), false);
    });
  });

  group('connect failure', () {
    setUp(() {
      when(reactiveBle.connectToDevice(id: deviceId)).thenAnswer(
        (realInvocation) => Stream.value(
          const ConnectionStateUpdate(
            deviceId: deviceId,
            connectionState: DeviceConnectionState.connecting,
            failure: GenericFailure<ConnectionError>(
              code: ConnectionError.failedToConnect,
              message: 'failure',
            ),
          ),
        ),
      );
    });

    test('connect failure', () async {
      await expectLater(
        device.connect(),
        emitsError(isA<DeviceConnectionError>()),
      );
    });
  });

  group('device connected', () {
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
    });

    group('get services', () {
      const serviceId = '12341234-9876-1234-abcd-12345678abcd';
      final serviceUuid = Uuid.parse(serviceId);
      const characteristicId = '09870987-abcd-defe-ffff-123456789012';
      final characteristicUuid = Uuid.parse(characteristicId);

      setUp(() {
        when(reactiveBle.discoverServices(deviceId)).thenAnswer(
          (realInvocation) => Future.value(
            [
              DiscoveredService(
                serviceId: serviceUuid,
                characteristicIds: [characteristicUuid],
                characteristics: [
                  DiscoveredCharacteristic(
                    characteristicId: characteristicUuid,
                    serviceId: serviceUuid,
                    isReadable: true,
                    isWritableWithResponse: false,
                    isWritableWithoutResponse: true,
                    isNotifiable: true,
                    isIndicatable: false,
                  ),
                ],
              ),
            ],
          ),
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
        await expectLater(device.connect(), emitsInOrder([true]));
        await expectLater(
          device.getServices(),
          emitsInOrder([
            [
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
            ]
          ]),
        );
      });

      test('read', () async {
        await expectLater(device.connect(), emitsInOrder([true]));
        await expectLater(
          device.read(serviceId, characteristicId),
          emitsInOrder([
            [2, 5, 10],
          ]),
        );
      });

      test('readAsStream', () async {
        await expectLater(device.connect(), emitsInOrder([true]));
        await expectLater(
          device.readAsStream(serviceId, characteristicId),
          emitsInOrder([
            [3, 4, 5],
          ]),
        );
      });

      test('write', () async {
        await expectLater(device.connect(), emitsInOrder([true]));
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
}
