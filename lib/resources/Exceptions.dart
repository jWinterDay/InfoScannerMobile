class AuthException implements Exception {
  final String message;
  final int code;

  AuthException(this.message, this.code);

  String toString() {
    return
      '''
        $code $message
      ''';
  }
}