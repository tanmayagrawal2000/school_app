/// Typed exceptions thrown by repositories and the API client.
///
/// BLoCs should catch [AppException] and map it to an error state.
/// All subtypes carry a human-readable [message].
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// The device has no internet connection or the server is unreachable.
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection.']);
}

/// The server responded with a non-2xx status code.
class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode});
}

/// The server returned data that could not be parsed.
class ParseException extends AppException {
  const ParseException([super.message = 'Failed to parse server response.']);
}

/// The user is not authenticated or the session has expired.
class AuthException extends AppException {
  const AuthException(
      [super.message = 'Session expired. Please log in again.']);
}

/// A requested resource was not found (404).
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found.']);
}
