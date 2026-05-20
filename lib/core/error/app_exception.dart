abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException({required this.message, this.code});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException({required String message, String? code})
      : super(message: message, code: code);
}

class StorageException extends AppException {
  StorageException({required String message, String? code})
      : super(message: message, code: code);
}

class ValidationException extends AppException {
  ValidationException({required String message, String? code})
      : super(message: message, code: code);
}

class NotFoundException extends AppException {
  NotFoundException({required String message, String? code})
      : super(message: message, code: code);
}

class UnknownException extends AppException {
  UnknownException({required String message, String? code})
      : super(message: message, code: code);
}
