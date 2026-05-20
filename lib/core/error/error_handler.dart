import 'app_exception.dart';

class ErrorHandler {
  static AppException handle(dynamic error) {
    if (error is AppException) {
      return error;
    }

    if (error is FormatException) {
      return ValidationException(
        message: error.message,
        code: 'FORMAT_ERROR',
      );
    }

    return UnknownException(
      message: error.toString(),
      code: 'UNKNOWN_ERROR',
    );
  }
}

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class AppFailure extends Failure {
  final String? code;
  const AppFailure(super.message, {this.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}
