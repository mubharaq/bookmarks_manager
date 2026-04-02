import 'package:bookmarks_manager/data/utils/dio_error_mapper.dart';
import 'package:bookmarks_manager/domain/error/app_exception.dart';
import 'package:bookmarks_manager/domain/result/result.dart';
import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({required this.dioInstance});

  final Dio dioInstance;

  Future<Result<dynamic>> _executeRequest(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Result.ok(response.data);
      }
      return Result.error(
        AppException.server(
          'Unexpected status code: ${response.statusCode}',
          StackTrace.current,
        ),
      );
    } on DioException catch (error, stackTrace) {
      return Result.error(extractDioError(error, stackTrace));
    }
  }

  Future<Result<dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    CancelToken? requestCancelToken,
  }) async {
    return _executeRequest(
      () => dioInstance.delete(
        endpoint,
        data: data,
        cancelToken: requestCancelToken,
      ),
    );
  }

  Future<Result<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    CancelToken? requestCancelToken,
  }) {
    return _executeRequest(
      () => dioInstance.get(
        endpoint,
        queryParameters: queryParameters,
        cancelToken: requestCancelToken,
      ),
    );
  }

  Future<Result<dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    FormData? formData,
    CancelToken? requestCancelToken,
  }) {
    return _executeRequest(
      () => dioInstance.post(
        endpoint,
        data: formData ?? data,
        cancelToken: requestCancelToken,
      ),
    );
  }

  Future<Result<dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    CancelToken? requestCancelToken,
  }) {
    return _executeRequest(
      () => dioInstance.put(
        endpoint,
        data: data,
        cancelToken: requestCancelToken,
      ),
    );
  }

  Future<Result<dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? data,
    FormData? formData,
    CancelToken? requestCancelToken,
  }) {
    return _executeRequest(
      () => dioInstance.patch(
        endpoint,
        data: formData ?? data,
        cancelToken: requestCancelToken,
      ),
    );
  }
}
