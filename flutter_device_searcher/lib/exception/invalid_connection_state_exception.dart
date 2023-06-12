import 'package:flutter_device_searcher/exception/label_printer_exception.dart';

/// InvalidConnectionStateException: When the client is not at a valid connection state to perform the operation.
/// For example, trying to close a connection when the connection is not open.
class InvalidConnectionStateException extends DeviceSearcherException {
  const InvalidConnectionStateException(super.message, super.cause);
}
