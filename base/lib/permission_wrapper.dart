import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionWrapper {
  Future<Map<Permission, PermissionStatus>>
      requestBluetoothPermissions() async => [
            if (defaultTargetPlatform == TargetPlatform.android)
              Permission.bluetoothScan,
            if (defaultTargetPlatform == TargetPlatform.android)
              Permission.bluetoothConnect,
            if (defaultTargetPlatform == TargetPlatform.android)
              Permission.locationWhenInUse,
            if (defaultTargetPlatform == TargetPlatform.iOS)
              Permission.bluetooth,
          ].request();
}
