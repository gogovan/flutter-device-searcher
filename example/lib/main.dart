import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:flutter_device_searcher/device/bluetooth/bluetooth_device.dart';
import 'package:flutter_device_searcher/device/bluetooth/bluetooth_service.dart';
import 'package:flutter_device_searcher/device/usb/usb_device.dart';
import 'package:flutter_device_searcher/device_searcher/bluetooth_searcher.dart';
import 'package:flutter_device_searcher/device_searcher/usb_searcher.dart';
import 'package:flutter_device_searcher/search_result/bluetooth_result.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';
import 'package:flutter_device_searcher/search_result/usb_result.dart';
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
  BluetoothSearcher? btSearcher;

  final writeController = TextEditingController();
  BluetoothDevice? btDevice;
  UsbDevice? usbDevice;

  final indexController = TextEditingController();

  bool _searching = false;
  var searchedResult = <DeviceSearchResult>[];
  String connectedResult = 'Pending connection...';

  List<BluetoothService> serviceList = <BluetoothService>[];
  String selectedServiceUuid = "";
  String selectedCharacteristicUuid = "";

  UsbSearcher? usbSearcher;

  var readResult = 'Read Result';
  var readStreamResult = '';
  StreamSubscription<List<int>>? readStreamSubscription;

  @override
  void initState() {
    super.initState();

    hierarchicalLoggingEnabled = true;
    btSearcher = BluetoothSearcher();
    btSearcher?.logger.level = Level.FINEST;
    btSearcher?.logger.onRecord.listen(print);

    usbSearcher = UsbSearcher();
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
                  onPressed: _searchUsb, child: const Text('Search for USB')),
              ElevatedButton(
                  onPressed: _stopSearch, child: const Text('Stop Searching')),
              Text('Searching = $_searching'),
              ...searchedResult
                  .toList()
                  .asMap()
                  .entries
                  .map((item) => Column(children: [
                        Row(
                          children: [
                            Expanded(child: Text(item.value.toString())),
                            ElevatedButton(
                                onPressed: () => _connect(item.key),
                                child: const Text('Connect')),
                          ],
                        ),
                        Container(color: Colors.blue, height: 1)
                      ])),
              Row(children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Interface Index',
                    ),
                    controller: indexController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                  onPressed: _setInterfaceIndex,
                  child: const Text('Set Interface Index'),
                ),
                ElevatedButton(
                  onPressed: _setEndpointIndex,
                  child: const Text('Set Endpoint Index'),
                )
              ]),
              ElevatedButton(
                  onPressed: _disconnect, child: const Text('Disconnect')),
              Text(connectedResult),
              ElevatedButton(
                  onPressed: _getServices,
                  child: const Text('Get Bluetooth Services')),
              ...serviceList
                  .expand((element) => element.characteristics)
                  .toList()
                  .map((item) => Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text('''
Service ${item.serviceId}
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
                    onPressed: _isBtConnected,
                    child: const Text(
                      'Check BT is connected',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isUsbConnected,
                    child: const Text(
                      'Check USB is connected',
                    ),
                  )
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
          searchedResult =
              event.where((e) => e.name?.isNotEmpty == true).toList();
        });
      });
    } catch (ex) {
      setState(() {
        connectedResult = ex.toString();
      });
    }
  }

  void _searchUsb() {
    setState(() {
      _searching = true;
    });

    try {
      _searchStream =
          usbSearcher?.search().listen(cancelOnError: true, (event) {
        setState(() {
          searchedResult = event.toList();
        });
      });
    } catch (ex) {
      setState(() {
        connectedResult = ex.toString();
      });
    }
  }

  Future<void> _setInterfaceIndex() async {
    try {
      final index = int.parse(indexController.text);
      await usbDevice?.setInterfaceIndex(index);
      setState(() {
        connectedResult = 'Set interface $index';
      });
    } catch (ex) {
      setState(() {
        connectedResult = ex.toString();
      });
    }
  }

  Future<void> _setEndpointIndex() async {
    try {
      final index = int.parse(indexController.text);
      await usbDevice?.setEndpointIndex(index);
      setState(() {
        connectedResult = 'Set endpoint $index';
      });
    } catch (ex) {
      setState(() {
        connectedResult = ex.toString();
      });
    }
  }

  Future<void> _stopSearch() async {
    try {
      await _searchStream?.cancel();
    } catch (ex) {
      setState(() {
        connectedResult = ex.toString();
      });
    }
    setState(() {
      _searching = false;
    });
  }

  Future<void> _connect(int index) async {
    if (searchedResult[index] is BluetoothResult) {
      await _connectBluetooth(index);
    } else if (searchedResult[index] is UsbResult) {
      await _connectUsb(index);
    } else {
      setState(() {
        connectedResult = 'Unknown device at index $index';
      });
    }
  }

  Future<void> _connectBluetooth(int index) async {
    try {
      setState(() {
        connectedResult = 'Connecting to device $index';
      });

      btDevice = BluetoothDevice(
        btSearcher!,
        searchedResult[index] as BluetoothResult,
      );
      await btDevice?.connect();

      setState(() {
        connectedResult = 'Connected to device $index';
      });
    } catch (ex) {
      setState(() {
        connectedResult = ex.toString();
      });
    }
  }

  Future<void> _connectUsb(int index) async {
    try {
      setState(() {
        connectedResult = 'Connecting to device $index';
      });

      usbDevice = UsbDevice(searchedResult[index] as UsbResult);
      await usbDevice?.connect();

      setState(() {
        connectedResult = 'Connected to device $index';
      });
    } catch (ex) {
      setState(() {
        connectedResult = ex.toString();
      });
    }
  }

  Future<void> _isBtConnected() async {
    try {
      final connected = await btDevice?.isConnected() ?? false;
      setState(() {
        connectedResult = 'BT Connected: $connected';
      });
    } catch (ex) {
      setState(() {
        connectedResult = ex.toString();
      });
    }
  }

  Future<void> _isUsbConnected() async {
    try {
      final connected = await usbDevice?.isConnected() ?? false;
      setState(() {
        connectedResult = 'USB Connected: $connected';
      });
    } catch (ex) {
      setState(() {
        connectedResult = ex.toString();
      });
    }
  }

  Future<void> _disconnect() async {
    try {
      await btDevice?.disconnect();
      await usbDevice?.disconnect();

      setState(() {
        connectedResult = "Disconnected from device";
      });
    } catch (ex) {
      setState(() {
        connectedResult = ex.toString();
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
        connectedResult = ex.toString();
      });
    }
  }

  Future<void> _write() async {
    try {
      if (btDevice != null) {
        await btDevice?.write(writeController.text.codeUnits,
            selectedServiceUuid, selectedCharacteristicUuid);
      } else if (usbDevice != null) {
        await usbDevice?.transfer(
          Uint8List.fromList(writeController.text.codeUnits),
          null,
        );
      }
    } catch (ex) {
      setState(() {
        connectedResult = ex.toString();
      });
    }
  }

  Future<void> _read() async {
    try {
      List<int>? result;
      if (btDevice != null) {
        result = await btDevice?.read(selectedServiceUuid.toString(),
            selectedCharacteristicUuid.toString());
      } else if (usbDevice != null) {
        result = await usbDevice?.transfer(Uint8List(0), 0);
      }

      setState(() {
        if (result != null) {
          readResult = String.fromCharCodes(result);
        } else {
          readResult = 'No data';
        }
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
      readStreamSubscription = btDevice
          ?.readAsStream(selectedServiceUuid.toString(),
              selectedCharacteristicUuid.toString())
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
