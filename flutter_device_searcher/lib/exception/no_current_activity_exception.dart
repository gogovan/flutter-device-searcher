import 'package:flutter_device_searcher/exception/label_printer_exception.dart';

/// NoActiveActivityException: When there are no activity being active on the current app.
/// Check that there is an activity in the foreground when calling the method.
class NoCurrentActivityException extends DeviceSearcherException {
  const NoCurrentActivityException(super.message, super.cause);
}
