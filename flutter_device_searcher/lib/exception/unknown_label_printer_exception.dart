import 'package:flutter_device_searcher/exception/device_searcher_exception.dart';

/// UnknownLabelPrinterException: When an unknown error occurs.
/// This should not be thrown in normal circumstances. Report an issue if you received this exception.
class UnknownDeviceSearcherException extends DeviceSearcherException {
  const UnknownDeviceSearcherException(super.message, super.cause);
}
