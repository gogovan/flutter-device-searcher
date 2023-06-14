// ignore_for_file: no-magic-number, this file documents all error codes.

import 'package:flutter_device_searcher/exception/connection_exception.dart';
import 'package:flutter_device_searcher/exception/connection_id_exception.dart';
import 'package:flutter_device_searcher/exception/connection_timeout_exception.dart';
import 'package:flutter_device_searcher/exception/image_io_exception.dart';
import 'package:flutter_device_searcher/exception/invalid_argument_exception.dart';
import 'package:flutter_device_searcher/exception/invalid_connection_state_exception.dart';
import 'package:flutter_device_searcher/exception/device_searcher_exception.dart';
import 'package:flutter_device_searcher/exception/missing_phone_capability_exception.dart';
import 'package:flutter_device_searcher/exception/missing_search_permission_exception.dart';
import 'package:flutter_device_searcher/exception/no_current_activity_exception.dart';
import 'package:flutter_device_searcher/exception/search_failed_exception.dart';
import 'package:flutter_device_searcher/exception/text_io_exception.dart';
import 'package:flutter_device_searcher/exception/unknown_label_printer_exception.dart';

DeviceSearcherException getExceptionFromCode(
    int code,
    String message,
    String stacktrace,
    ) {
  switch (code) {
    case 1000:
      return UnknownDeviceSearcherException(message, stacktrace);
    case 1001:
      return MissingPhoneCapabilityException(message, stacktrace);
    case 1002:
      return MissingSearchPermissionException(message, stacktrace);
    case 1003:
      return NoCurrentActivityException(message, stacktrace);
    case 1004:
      return SearchFailedException(message, stacktrace);
    case 1005:
      return InvalidConnectionStateException(message, stacktrace);
    case 1006:
      return ConnectionException(message, stacktrace);
    case 1007:
      return ConnectionIdException(message, stacktrace);
    case 1008:
      return ConnectionTimeoutException(message, stacktrace);
    case 1009:
      return InvalidArgumentException(message, stacktrace);
    case 1010:
      return ImageIOException(message, stacktrace);
    case 1011:
      return TextIOException(message, stacktrace);
  }

  // All codes should be covered. This should not happen. Fallback.
  return UnknownDeviceSearcherException(message, stacktrace);
}
