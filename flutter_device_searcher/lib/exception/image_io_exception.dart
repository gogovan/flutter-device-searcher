import 'package:flutter_device_searcher/exception/device_searcher_exception.dart';

/// ImageIOException: The image file is not found, not a supported image file,
/// or otherwise unable to be loaded as a proper image.
class ImageIOException extends DeviceSearcherException {
  const ImageIOException(super.message, super.cause);
}
