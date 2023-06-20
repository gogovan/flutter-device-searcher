class InvalidConnectionStateError implements Exception {
  const InvalidConnectionStateError(this.message);

  final String message;

  @override
  String toString() => 'InvalidConnectionStateError{message: $message}';
}
