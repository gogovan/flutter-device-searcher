class PermissionDeniedError implements Exception {
  const PermissionDeniedError(this.message);

  final String message;

  @override
  String toString() => 'PermissionDeniedError{message: $message}';
}
