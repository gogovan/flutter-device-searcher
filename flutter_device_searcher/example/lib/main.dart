import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_device_searcher/device/bluetooth_device.dart';
import 'package:flutter_device_searcher/device_searcher/bluetooth_searcher.dart';
import 'package:flutter_device_searcher/search_result/device_search_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final btSearcher = BluetoothSearcher();
  final connectIndexController = TextEditingController();
  BluetoothDevice? btDevice;

  bool _searching = false;
  var searchedBtResult = <DeviceSearchResult>[];
  String connectedBtResult = "Pending connection";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    connectIndexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            ElevatedButton(child: Text('Search for Bluetooth'), onPressed: _searchBluetooth),
            Text('Searching = $_searching'),
            Text(searchedBtResult.toString()),
            ElevatedButton(child: Text('Stop Searching for Bluetooth'), onPressed: _stopSearchBluetooth),
            TextField(
              decoration: const InputDecoration(
                hintText:
                'Index of Search result to Connect Bluetooth to',
              ),
              keyboardType: TextInputType.number,
              controller: connectIndexController,
            ),
            ElevatedButton(child: Text('Connect Bluetooth'), onPressed: _connectBluetooth),
            ElevatedButton(child: Text('Disconnect Bluetooth'), onPressed: _disconnectBluetooth),
            Text(connectedBtResult),
          ],
        ),
      ),
    );
  }

  void _searchBluetooth() {
    setState(() {
      _searching = true;
    });

    btSearcher.search().listen((event) {
      setState(() {
        searchedBtResult = event;
      });
    });
  }

  Future<void> _stopSearchBluetooth() async {
    await btSearcher.stopSearch();
    setState(() {
      _searching = false;
    });
  }

  Future<void> _connectBluetooth() async {
    final index = int.parse(connectIndexController.text);
    btDevice = BluetoothDevice(searchedBtResult[index]);
    await btDevice?.connect();
    setState(() {
      connectedBtResult = "connected to device ${searchedBtResult[index]}";
    });
  }

  Future<void> _disconnectBluetooth() async {
    await btDevice?.disconnect();
    setState(() {
      connectedBtResult = "Disconnected from device";
    });
  }
}
