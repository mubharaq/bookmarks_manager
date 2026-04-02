sealed class AppException implements Exception {
  const AppException(this.errorMessage, this.stackTrace);
  const factory AppException.server(String value, StackTrace trace) = Server;
  const factory AppException.authentication(
    String message,
    StackTrace trace, {
    bool requiresReauthentication,
  }) = Authentication;
  const factory AppException.parse(String message, StackTrace trace) = Parse;
  const factory AppException.validation(String message, StackTrace trace) =
      Validation;
  const factory AppException.connection(String message, StackTrace trace) =
      Connection;
  const factory AppException.unknown(String message, StackTrace trace) =
      Unknown;
  final String errorMessage;
  final StackTrace stackTrace;
}

final class Server extends AppException {
  const Server(super.errorMessage, super.stackTrace);

  @override
  String toString() => 'AppException.server($errorMessage)';
}

final class Connection extends AppException {
  const Connection(super.errorMessage, super.stackTrace);

  @override
  String toString() => 'AppException.connection($errorMessage)';
}

final class Unknown extends AppException {
  const Unknown(super.errorMessage, super.stackTrace);

  @override
  String toString() => 'AppException.unknown($errorMessage)';
}

final class Authentication extends AppException {
  const Authentication(
    super.errorMessage,
    super.stackTrace, {
    this.requiresReauthentication = false,
  });
  final bool requiresReauthentication;

  @override
  String toString() => 'AppException.authentication($errorMessage)';
}

final class Parse extends AppException {
  const Parse(super.errorMessage, super.stackTrace);

  @override
  String toString() => 'AppException.parse($errorMessage) at $stackTrace';
}

final class Validation extends AppException {
  const Validation(super.errorMessage, super.stackTrace);

  @override
  String toString() => 'AppException.validation($errorMessage)';
}

extension ErrorParsingX on Object {
  String get asErrorMessage {
    if (this is AppException) {
      return (this as AppException).errorMessage;
    }
    return toString().replaceAll('Exception: ', '');
  }
}
