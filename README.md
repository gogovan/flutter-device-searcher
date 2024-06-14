# flutter_device_searcher

A generic library to search for external device using various connection technologies. Support Bluetooth LE and USB (Android, device search only).

## Getting Started

1. Update your app `android/app/build.gradle` and update minSdkVersion to at least 21
```groovy
defaultConfig {
    applicationId "com.example.app"
    minSdkVersion 21
    // ...
}
```
2. Setup required permissions according to OS and technology:

## Bluetooth
### Android

1. Add the following to your main `AndroidManifest.xml`.
   See [Android Developers](https://developer.android.com/guide/topics/connectivity/bluetooth/permissions)
   and [this StackOverflow answer](https://stackoverflow.com/a/70793272)
   for more information about permission settings.

```xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.flutter_device_searcher_example">

    <uses-feature android:name="android.hardware.bluetooth" android:required="true" />

    <uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN"
        android:usesPermissionFlags="neverForLocation" tools:targetApi="s" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"
        android:maxSdkVersion="30" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"
        android:maxSdkVersion="30" />
    <!-- ... -->
</manifest>
```

### iOS

1. Include usage description keys for Bluetooth into `info.plist`.
   ![iOS XCode Bluetooth permission instruction](README_img/ios-bluetooth-perm.png)

## USB
### Android

1. Add the following to your main `AndroidManifest.xml`.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.flutter_device_searcher_example">

    <uses-feature android:name="android.hardware.usb.host" android:required="true" />
    
    <uses-permission android:name="hk.gogovan.flutter_device_searcher.USB_PERMISSION" />
    <!-- ... -->
</manifest>
```

# Usage

## Connect to device
1. Create a searcher according to connection technology desired. All searchers implement `DeviceSearcherInterface`.
   - For BLE, use `BluetoothSearcher`
2. Invoke and listen to the Dart `Stream` returned from `search()` method. Subclasses of `DeviceSearchResult`s are sent to your listener.
   - For BLE, you will receive a `BluetoothResult`. 
     - `id` is an identifier for the device, it being a MAC address (may be randomized) in Android and a random UUID in iOS.
     - `name` is the display name for the device.
```dart
final searchStream = btSearcher?.search().listen(cancelOnError: true, (event) {
  final id = event.id;
  // Store the event for later connection.
});
```
3. Stop the search before connecting to a device, by cancelling the search stream. Failure to stop the search may cause inability to connect to devices in some phones.
```dart
   await searchStream.cancel();
```
4. To connect a device, create a `DeviceInterface` implementation such as `BluetoothDevice`, passing the device you want to connect. Then call `connect` to connect to the device.
```dart
  final btDevice = BluetoothDevice(deviceSearcher, searchedBtResult[index]);
  await btDevice.connect();
```

## Transfer data after connection
### Bluetooth
- After connecting to device, you may query available services and characteristics.
```dart
  final list = await btDevice.getServices();
```
- Synchronous read/write from/to the device is done by `read` and `write` call respectively.
- Asynchronous read is done by `readAsStream` method, which returns a Dart `Stream`. Listen to stream to receive results.

### USB
- Set interface index and then endpoint number before sending or receiving data. Details of these can be found in the UsbResult. For details refer to [Android documentation](https://developer.android.com/develop/connectivity/usb)
```
await usbDevice?.setInterfaceIndex(index);
await usbDevice?.setEndpointIndex(index);
```
- After interface and endpoint is set, use `transfer` to either read or write data, depending on whether the interface is read or write.
```
List<int> result = await usbDevice?.transfer(Uint8List(0));
```

## Disconnect from device
- To disconnect from the device, call `disconnect` on the device.
```dart
  await btDevice.disconnect();
```

## BluetoothConnectionMixin

If you are using Bluetooth, you can also elect to use the provided `BluetoothConnectionMixin`, which handles device searching and connection management.

Override the methods `includeResult`, `includeService` and `includeCharacteristic` methods to specify which Bluetooth device, service and characteristic you are interested in. It should filter results, services and characteristics down to one of each.

