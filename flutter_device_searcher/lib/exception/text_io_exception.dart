import 'package:flutter_device_searcher/exception/device_searcher_exception.dart';

/// TextIOException: Generic I/O Exception concerning text and byte streams.
class TextIOException extends DeviceSearcherException {
  const TextIOException(super.message, super.cause);
}
