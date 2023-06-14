import 'package:flutter_device_searcher/exception/device_searcher_exception.dart';

/// MissingSearchPermissionException: When the client does not have permission to search for devices.
/// Typically this is thrown when the user denied the permissions required to search a device.
/// For example, BLUETOOTH permission is denied when trying to scan for Bluetooth devices.
class MissingSearchPermissionException extends DeviceSearcherException {
  const MissingSearchPermissionException(super.message, super.cause);
}
