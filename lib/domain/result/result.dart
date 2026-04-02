import 'package:bookmarks_manager/domain/error/app_exception.dart';

/// Utility class to wrap result data
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Ok(): {
///     print(result.value);
///   }
///   case Error(): {
///     print(result.error);
///   }
/// }
/// ```
sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok._;

  const factory Result.error(AppException error) = Error._;

  /// Maps the result to a new value using [onOk] for success or
  /// [onError] for failure.
  R fold<R>({
    required R Function(T) onOk,
    required R Function(AppException) onError,
  }) {
    switch (this) {
      case Ok(:final value):
        return onOk(value);
      case Error(:final error):
        return onError(error);
    }
  }

  /// Returns the success value or [defaultValue] if the result is an error.
  T getOrElse(T defaultValue) =>
      fold(onOk: (value) => value, onError: (_) => defaultValue);

  /// Unwraps the Result.
  /// Returns the value if [Ok], otherwise throws the error if [Error].
  T getOrThrow() {
    return switch (this) {
      Ok(value: final v) => v,
      Error(error: final e) => throw e,
    };
  }
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

final class Error<T> extends Result<T> {
  const Error._(this.error);
  final AppException error;

  @override
  String toString() => 'Result<$T>.error($error)';
}
