/// This is the parent for all exception classes in this package.
/// Use if you want to catch all exceptions coming out of this package.
abstract class DeviceSearcherException implements Exception {
  const DeviceSearcherException(this.message, this.stacktrace);

  final String message;
  final String stacktrace;
}
