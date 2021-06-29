/// base class for Api exceptions
class _ApiException implements Exception {
  final String message;

  /// optional string to identify the exception
  final String? code;

  _ApiException({required this.message, this.code});
}

class FetchDataException extends _ApiException {
  FetchDataException({required String message, String? code})
      : super(message: message, code: code);
}

class ServerException extends _ApiException {
  ServerException({required String message, String? code})
      : super(message: message, code: code);
}
