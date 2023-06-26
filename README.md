# flutter_device_searcher

A generic library to search for external device using various connection technologies. Support Bluetooth LE.

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
    package="com.example.flutter_label_printer_example">

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

# Usage

1. Create a searcher according to connection technology desired. All searchers implement `DeviceSearcherInterface`.
   - For BLE, use `BluetoothSearcher`
2. Invoke and listen to the `Stream` returned from `search()` method. `DeviceSearchResult`s are sent to your listener.
```dart
final _searchStream = btSearcher?.search().listen(cancelOnError: true, (event) {
  final id = event.id;
});
```