/// base class for Api exceptions
class _ApiException {
  final String? message;

  /// optional string to identify the exception
  final String? code;

  _ApiException({this.message, this.code});

  @override
  String toString() {
    if (message != null) return message!;
    return "";
  }
}

class FetchDataException extends _ApiException {
  FetchDataException({String? message, String? code})
      : super(message: message, code: code);
}

class BadRequestException extends _ApiException {
  BadRequestException({String? message, String? code})
      : super(message: message, code: code);
}

class ServerException extends _ApiException {
  ServerException({String? message, String? code})
      : super(message: message, code: code);
}
