/// JsonlogicException is the base exception raised by all the functions
/// in this library.
class JsonlogicException implements Exception {
  final String message;
  const JsonlogicException(this.message);

  @override
  String toString() => 'JsonlogicException: $message';
}
