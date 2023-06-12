import 'package:flutter_device_searcher/exception/label_printer_exception.dart';

/// MissingPhoneCapabilityException: When the client's phone do not have the capability to search the printer.
/// For example, if the printer uses Bluetooth to connect to phone but the phone have no Bluetooth capability.
class MissingPhoneCapabilityException extends DeviceSearcherException {
  const MissingPhoneCapabilityException(super.message, super.cause);
}
