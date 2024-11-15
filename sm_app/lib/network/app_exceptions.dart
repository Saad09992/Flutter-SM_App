// ignore_for_file: prefer_typing_uninitialized_variables, annotate_overrides

class AppExceptions implements Exception {
  final String? _message;
  final String? _prefix;
  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

// Exception for general communication errors, like no internet or server errors
class FetchDataException extends AppExceptions {
  FetchDataException([String? message])
      : super(message, 'Error during communication: ');
}

// Exception for invalid requests
class BadRequestException extends AppExceptions {
  BadRequestException([String? message]) : super(message, 'Invalid request: ');
}

// Exception for unauthorized requests
class UnauthorizedException extends AppExceptions {
  UnauthorizedException([String? message]) : super(message, 'Unauthorized: ');
}

// Exception for input validation errors
class InvalidInputException extends AppExceptions {
  InvalidInputException([String? message]) : super(message, 'Invalid input: ');
}

// New: Generic error to handle backend errors with 'status': 'error' responses
class BackendErrorException extends AppExceptions {
  BackendErrorException([String? message]) : super(message, 'Backend error: ');
}
