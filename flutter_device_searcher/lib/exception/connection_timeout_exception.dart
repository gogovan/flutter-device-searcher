import 'package:flutter_device_searcher/exception/device_searcher_exception.dart';

/// ConnectionTimeoutException: When connecting to the device timed out.
class ConnectionTimeoutException extends DeviceSearcherException {
  const ConnectionTimeoutException(super.message, super.cause);
}
