class InvalidDeviceResultError implements Exception {
  const InvalidDeviceResultError(this.message);

  final String message;

  @override
  String toString() => 'InvalidDeviceResultError{message: $message}';
}
