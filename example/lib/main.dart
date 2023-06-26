import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_device_searcher/device/bluetooth/bluetooth_device.dart';
import 'package:flutter_device_searcher/device/bluetooth/bluetooth_service.dart';
import 'package:flutter_device_searcher/device_searcher/bluetooth_searcher.dart';
import 'package:flutter_device_searcher/flutter_device_searcher.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final deviceSearcher = FlutterDeviceSearcher();
  BluetoothSearcher? btSearcher;

  final writeController = TextEditingController();
  BluetoothDevice? btDevice;

  bool _searching = false;
  var searchedBtResult = <DeviceSearchResult>[];
  String connectedBtResult = 'Pending connection...';

  List<BluetoothService> serviceList = <BluetoothService>[];
  String selectedServiceUuid = "";
  String selectedCharacteristicUuid = "";

  var readResult = 'Read Result';
  var readStreamResult = '';
  StreamSubscription<List<int>>? readStreamSubscription;

  @override
  void initState() {
    super.initState();

    deviceSearcher.logger.onRecord.listen(print);

    btSearcher = BluetoothSearcher(deviceSearcher);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: _searchBluetooth,
                  child: const Text('Search for Bluetooth')),
              ElevatedButton(
                  onPressed: _stopSearchBluetooth,
                  child: const Text('Stop Searching for Bluetooth')),
              Text('Searching = $_searching'),
              ...searchedBtResult
                  .toList()
                  .asMap()
                  .entries
                  .map((item) => Column(children: [
                        Row(
                          children: [
                            Expanded(child: Text(item.value.toString())),
                            ElevatedButton(
                                onPressed: () => _connectBluetooth(item.key),
                                child: const Text('Connect')),
                          ],
                        ),
                        Container(color: Colors.blue, height: 1)
                      ])),
              ElevatedButton(
                  onPressed: _disconnectBluetooth,
                  child: const Text('Disconnect Bluetooth')),
              Text(connectedBtResult),
              ElevatedButton(
                  onPressed: _getServices, child: const Text('Get Services')),
              ...serviceList
                  .expand((element) => element.characteristics)
                  .toList()
                  .map((item) => Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text('''
Characteristic ${item.characteristicId}
Readable: ${item.isReadable}
Indicatable: ${item.isIndicatable}
Notifiable: ${item.isNotifiable}
Writable w/ response: ${item.isWritableWithResponse}
Writable w/o response: ${item.isWritableWithoutResponse}
                  ''')),
                              ElevatedButton(
                                  onPressed: () {
                                    selectedServiceUuid = item.serviceId;
                                    selectedCharacteristicUuid =
                                        item.characteristicId;
                                  },
                                  child: Text('Use for R/W'))
                            ],
                          ),
                          Container(color: Colors.blue, height: 1)
                        ],
                      )),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Write bytes',
                      ),
                      controller: writeController,
                    ),
                  ),
                  ElevatedButton(onPressed: _write, child: const Text('Write')),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: _read, child: const Text('Read')),
                  Text(readResult),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: _readStream, child: const Text('Read Stream')),
                  ElevatedButton(
                      onPressed: _stopReadStream, child: const Text('Stop')),
                ],
              ),
              Text(readStreamResult),
            ],
          ),
        ),
      ),
    );
  }

  StreamSubscription<List<DeviceSearchResult>>? _searchStream;

  void _searchBluetooth() {
    setState(() {
      _searching = true;
    });

    try {
      _searchStream = btSearcher?.search().listen(cancelOnError: true, (event) {
        setState(() {
          searchedBtResult = event
              .where((e) => e.name?.isNotEmpty == true)
              .toList();
        });
      });
    } catch (ex) {
      setState(() {
        connectedBtResult = ex.toString();
      });
    }
  }

  Future<void> _stopSearchBluetooth() async {
    try {
      await _searchStream?.cancel();
    } catch (ex) {
      setState(() {
        connectedBtResult = ex.toString();
      });
    }
    setState(() {
      _searching = false;
    });
  }

  Future<void> _connectBluetooth(int index) async {
    try {
      setState(() {
        connectedBtResult = 'Connecting to device $index';
      });

      btDevice = BluetoothDevice(deviceSearcher, searchedBtResult[index]);
      await btDevice?.connect();

      setState(() {
        connectedBtResult = 'Connected to device $index';
      });
    } catch (ex) {
      setState(() {
        connectedBtResult = ex.toString();
      });
    }
  }

  Future<void> _disconnectBluetooth() async {
    try {
      await btDevice!.disconnect();

      setState(() {
        connectedBtResult = "Disconnected from device";
      });
    } catch (ex) {
      setState(() {
        connectedBtResult = ex.toString();
      });
    }
  }

  Future<void> _getServices() async {
    try {
      final list = await btDevice?.getServices() ?? [];

      setState(() {
        serviceList = list;
      });
    } catch (ex) {
      setState(() {
        connectedBtResult = ex.toString();
      });
    }
  }

  Future<void> _write() async {
    try {
      await btDevice!.write(writeController.text.codeUnits, selectedServiceUuid,
          selectedCharacteristicUuid);
    } catch (ex) {
      setState(() {
        connectedBtResult = ex.toString();
      });
    }
  }

  Future<void> _read() async {
    try {
      final result =
          await btDevice!.read(selectedServiceUuid.toString(), selectedCharacteristicUuid.toString());
      print('_read: ${result.toString()}');
      setState(() {
        readResult = String.fromCharCodes(result);
      });
    } catch (ex) {
      setState(() {
        readResult = ex.toString();
      });
    }
  }

  void _readStream() {
    try {
      readStreamSubscription?.cancel();
      readStreamSubscription = btDevice!
          .readAsStream(selectedServiceUuid.toString(), selectedCharacteristicUuid.toString())
          .listen((event) {
        print('_readStream ${event.toString()}');
        setState(() {
          readStreamResult = String.fromCharCodes(event);
        });
      });
    } catch (ex) {
      setState(() {
        readStreamResult = ex.toString();
      });
    }
  }

  void _stopReadStream() {
    readStreamSubscription?.cancel();
  }
}
