import 'dart:io' show SocketException;

import 'package:bookmarks_manager/domain/error/app_exception.dart';
import 'package:dio/dio.dart';

///helper method to convert [DioException] to [AppException]
AppException extractDioError(DioException error, StackTrace trace) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return AppException.connection(
        'Connection timeout. Please check your internet connection.',
        trace,
      );

    case DioExceptionType.connectionError:
      return AppException.connection(
        'Network connection failed. Please try again.',
        trace,
      );

    case DioExceptionType.badCertificate:
      return AppException.server(
        'Security certificate error. Please contact support.',
        trace,
      );

    case DioExceptionType.badResponse:
      return _transformDioBadResponse(error, trace);

    case DioExceptionType.cancel:
      return AppException.connection('Request was cancelled', trace);

    case DioExceptionType.unknown:
      if (error.error is SocketException) {
        return AppException.connection(
          'Network connection failed. Please check your internet connection.',
          trace,
        );
      }
      return AppException.unknown(
        'An unexpected network error occurred',
        trace,
      );
  }
}

/// Creates an error message from a Laravel validation response
///
/// Example Laravel response:
/// ```json
/// {
///   "message": "The given data was invalid.",
///   "errors": {
///     "email": ["The email field is required."],
///     "password": ["The password must be at least 8 characters."]
///   }
/// }
/// ```
String _extractValidationError(
  Map<String, dynamic>? responseData,
) {
  final errorData = responseData?['errors'];
  if (responseData == null) {
    return 'Validation failed';
  }
  if (errorData != null && errorData is Map<String, dynamic>) {
    final allErrors = <String>[];
    for (final fieldErrors in errorData.values) {
      if (fieldErrors is List) {
        allErrors.addAll(fieldErrors.map((e) => e.toString()));
      }
    }
    if (allErrors.isNotEmpty) {
      return allErrors.join('\n');
    }
  }
  if (responseData['message'] != null) {
    return responseData['message'] as String;
  }
  return 'Validation failed';
}

AppException _transformDioBadResponse(DioException error, StackTrace trace) {
  final statusCode = error.response?.statusCode;
  final errorData = error.response?.data;

  switch (statusCode) {
    case 400:
      if (errorData is Map<String, dynamic>) {
        return AppException.validation(
          _extractValidationError(errorData),
          trace,
        );
      }
      return AppException.connection('Invalid request', trace);

    case 401:
      final isTokenExpired = _isTokenExpiredError(errorData);
      return AppException.authentication(
        isTokenExpired
            ? 'Session expired. Please login again.'
            : 'Authentication failed.',
        trace,
        requiresReauthentication: isTokenExpired,
      );

    case 403:
      return AppException.authentication(
        _extractAuthenticationError(errorData) ??
            "You don't have permission to perform this action.",
        trace,
      );
    case 404:
      return AppException.server(
        'The requested resource was not found.',
        trace,
      );
    case 406:
      if (errorData is Map<String, dynamic>) {
        return AppException.validation(
          _extractValidationError(errorData),
          trace,
        );
      }
      return AppException.unknown('Unable to complete operation', trace);
    case 422:
      if (errorData is Map<String, dynamic>) {
        return AppException.validation(
          _extractValidationError(errorData),
          trace,
        );
      }
      return AppException.validation('Validation failed', trace);
    case 429:
      return AppException.server(
        'Too many requests. Please try again later.',
        trace,
      );
    case 500:
    case 501:
    case 502:
    case 503:
      return AppException.server(
        'Server error. Please try again later.',
        trace,
      );
    default:
      return AppException.unknown('An unexpected error occurred', trace);
  }
}

String? _extractAuthenticationError(dynamic error) {
  if (error == null) return null;
  if (error is String) return error;
  if (error is Map<String, dynamic>) {
    if (error['message'] != null) {
      return error['message'] as String?;
    }
    if (error['error'] != null) {
      return error['error'] as String?;
    }
    return error['error_description'] as String?;
  }
  return null;
}

bool _isTokenExpiredError(dynamic error) {
  if (error is Map<String, dynamic>) {
    final message = error['message']?.toString().toLowerCase() ?? '';
    final errorMessage = error['error']?.toString().toLowerCase() ?? '';

    return message.contains('token expired') ||
        message.contains('unauthenticated') ||
        errorMessage.contains('token expired') ||
        errorMessage.contains('unauthenticated');
  }
  return false;
}
