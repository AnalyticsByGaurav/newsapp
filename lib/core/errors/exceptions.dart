class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException(message: $message, statusCode: $statusCode)';
}

class NetworkException extends ApiException {
  const NetworkException() : super('No internet connection');

  @override
  String toString() => 'NetworkException: No internet connection';
}

class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode});

  @override
  String toString() => 'ServerException(message: $message, statusCode: $statusCode)';
}

class CacheException extends ApiException {
  const CacheException(super.message);

  @override
  String toString() => 'CacheException(message: $message)';
}

class AuthException extends ApiException {
  const AuthException(super.message, {super.statusCode});

  @override
  String toString() => 'AuthException(message: $message)';
}

class TimeoutException extends ApiException {
  const TimeoutException() : super('Connection timed out. Please try again.');

  @override
  String toString() => 'TimeoutException: Connection timed out';
}

class ValidationException extends ApiException {
  final Map<String, String>? fieldErrors;

  const ValidationException(super.message, {this.fieldErrors});

  @override
  String toString() => 'ValidationException(message: $message)';
}
