import 'package:flutter_device_searcher/exception/label_printer_exception.dart';

/// ConnectionException: Unable to connect to the printer due to unspecified reasons.
class ConnectionException extends DeviceSearcherException {
  const ConnectionException(super.message, super.cause);
}
