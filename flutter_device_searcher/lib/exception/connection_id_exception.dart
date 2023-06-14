import 'package:flutter_device_searcher/exception/device_searcher_exception.dart';

/// ConnectionAddressException: Unable to connect to the printer due to wrong id format.
class ConnectionIdException extends DeviceSearcherException {
  const ConnectionIdException(super.message, super.cause);
}
