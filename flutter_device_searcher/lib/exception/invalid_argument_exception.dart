import 'package:flutter_device_searcher/exception/device_searcher_exception.dart';

/// InvalidArgumentException: Invalid arguments are passed to a print call.
/// E.g. A string is passed to a parameter that only accept integers.
class InvalidArgumentException extends DeviceSearcherException {
  const InvalidArgumentException(super.message, super.cause);
}
