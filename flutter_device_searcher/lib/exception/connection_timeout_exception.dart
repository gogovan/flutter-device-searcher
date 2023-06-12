import 'package:flutter_device_searcher/exception/label_printer_exception.dart';

/// ConnectionTimeoutException: When connecting to the device timed out.
class ConnectionTimeoutException extends DeviceSearcherException {
  const ConnectionTimeoutException(super.message, super.cause);
}
