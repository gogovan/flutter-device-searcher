import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_device_searcher/device_searcher/bluetooth_searcher.dart';

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
  var searchedBtResult = [];

  @override
  void initState() {
    super.initState();
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
            ElevatedButton(child: Text('Search Bluetooth'), onPressed: _searchBluetooth),
            Text(searchedBtResult.toString()),
          ],
        ),
      ),
    );
  }

  void _searchBluetooth() {
    btSearcher.search().listen((event) {
      setState(() {
        searchedBtResult = event;
      });
    });
  }
}
