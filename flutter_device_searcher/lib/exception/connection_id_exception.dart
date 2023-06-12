import 'package:flutter_device_searcher/exception/label_printer_exception.dart';

/// ConnectionAddressException: Unable to connect to the printer due to wrong id format.
class ConnectionIdException extends DeviceSearcherException {
  const ConnectionIdException(super.message, super.cause);
}
