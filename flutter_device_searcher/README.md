# flutter_device_searcher

A generic library to search for external device using various connection technologies. Support Bluetooth Classic.

## Getting Started

1. Update your app `android/app/build.gradle` and update minSdkVersion to at least 19
```groovy
defaultConfig {
    applicationId "com.example.app"
    minSdkVersion 19
    // ...
}
```
2. Request required permissions according to OS and technology. [Permission Handler](https://pub.dev/packages/permission_handler) is recommended for handling permissions in Flutter.

## Permission instructions

### Bluetooth
