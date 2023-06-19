class InvalidConnectionState implements Exception {
  const InvalidConnectionState(this.message);

  final String message;

  @override
  String toString() => 'InvalidConnectionState{message: $message}';
}
