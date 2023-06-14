import 'package:flutter_device_searcher/exception/device_searcher_exception.dart';

/// ConnectionException: Unable to connect to the printer due to unspecified reasons.
class ConnectionException extends DeviceSearcherException {
  const ConnectionException(super.message, super.cause);
}
