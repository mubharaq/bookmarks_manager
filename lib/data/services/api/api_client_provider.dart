import 'package:bookmarks_manager/app/config/app_config.dart';
import 'package:bookmarks_manager/app/providers/auth/auth_state_provider.dart';
import 'package:bookmarks_manager/data/services/api/api_client.dart';
import 'package:bookmarks_manager/data/services/api/api_interceptor.dart';
import 'package:bookmarks_manager/data/services/storage/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_provider.g.dart';

@Riverpod(keepAlive: true)
ApiInterceptor apiInterceptor(Ref ref) {
  return ApiInterceptor(
    localStorage: ref.read(localStorageProvider),
    onSessionExpired: (message) async {
      await ref
          .read(authenticationStateProvider.notifier)
          .logout(
            errorMessage: message,
          );
    },
  );
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dioBaseOptions = BaseOptions(
    baseUrl: EnvInfo.baseUrl,
    headers: {
      'accept': 'application/json',
      'content-type': 'application/json',
    },
  );
  return Dio(dioBaseOptions)
    ..interceptors.add(ref.read(apiInterceptorProvider));
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient(
    dioInstance: ref.watch(dioProvider),
  );
}
