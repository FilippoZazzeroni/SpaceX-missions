/// base class for Api exceptions
class _ApiException {
  final String? message;

  _ApiException({this.message});

  @override
  String toString() {
    if (message != null) return message!;
    return "";
  }
}

//TODO inserire codice errore
class FetchDataException extends _ApiException {
  FetchDataException({String? message}) : super(message: message);
}

class BadRequestException extends _ApiException {
  BadRequestException({String? message}) : super(message: message);
}

class UnauthorisedException extends _ApiException {
  UnauthorisedException({String? message}) : super(message: message);
}

class InvalidInputException extends _ApiException {
  InvalidInputException({String? message}) : super(message: message);
}
