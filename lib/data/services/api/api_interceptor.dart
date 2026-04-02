import 'package:bookmarks_manager/data/services/storage/storage_keys.dart';
import 'package:bookmarks_manager/data/services/storage/storage_service.dart';
import 'package:bookmarks_manager/data/utils/dio_error_mapper.dart';
import 'package:bookmarks_manager/domain/error/app_exception.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor({
    required this.localStorage,
    required this.onSessionExpired,
  });

  final LocalStorageService localStorage;
  final Future<void> Function(String message) onSessionExpired;

  bool _isLoggingOut = false;
  void reset() => _isLoggingOut = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final transformedError = extractDioError(err, err.stackTrace);

    if (transformedError case Authentication()) {
      if (transformedError.requiresReauthentication && !_isLoggingOut) {
        _isLoggingOut = true;
        await onSessionExpired(
          'Your session has expired. Please log in again.',
        );
      }
    }

    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authToken = localStorage.getStringData(StorageKeys.authToken);
    if (authToken != null) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }
    return handler.next(options);
  }
}
