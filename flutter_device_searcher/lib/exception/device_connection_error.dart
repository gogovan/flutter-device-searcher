class DeviceConnectionError implements Exception {
  const DeviceConnectionError(this.message);

  final String message;

  @override
  String toString() => 'DeviceConnectionError{message: $message}';
}
