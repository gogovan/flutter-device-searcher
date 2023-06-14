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
  final writeController = TextEditingController();
  BluetoothDevice? btDevice;

  bool _searching = false;
  var searchedBtResult = <DeviceSearchResult>[];
  String connectedBtResult = "Pending connection...";
  var readResult = "Read Result";

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: _searchBluetooth,
                  child: const Text('Search for Bluetooth')),
              Text('Searching = $_searching'),
              Text(searchedBtResult.map((e) => "$e\n").toString()),
              ElevatedButton(
                  onPressed: _stopSearchBluetooth,
                  child: const Text('Stop Searching for Bluetooth')),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Index of Search result to Connect Bluetooth to',
                ),
                keyboardType: TextInputType.number,
                controller: connectIndexController,
              ),
              ElevatedButton(
                  onPressed: _connectBluetooth,
                  child: const Text('Connect Bluetooth')),
              ElevatedButton(
                  onPressed: _disconnectBluetooth,
                  child: const Text('Disconnect Bluetooth')),
              Text(connectedBtResult),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  void _searchBluetooth() {
    setState(() {
      _searching = true;
    });

    try {
      btSearcher.search().listen((event) {
        setState(() {
          searchedBtResult = event;
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
      await btSearcher.stopSearch();
    } catch (ex) {
      setState(() {
        connectedBtResult = ex.toString();
      });
    }
    setState(() {
      _searching = false;
    });
  }

  Future<void> _connectBluetooth() async {
    try {
      final index = int.parse(connectIndexController.text);
      btDevice = BluetoothDevice(searchedBtResult[index]);
      await btDevice?.connect();

      setState(() {
        connectedBtResult = "connected to device $index";
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

  Future<void> _write() async {
    try {
      await btDevice!.write(writeController.text.codeUnits);
    } catch (ex) {
      setState(() {
        connectedBtResult = ex.toString();
      });
    }
  }

  Future<void> _read() async {
    try {
      final result = await btDevice!.read();
      setState(() {
        readResult = String.fromCharCodes(result);
      });
    } catch (ex) {
      setState(() {
        connectedBtResult = ex.toString();
      });
    }
  }
}
