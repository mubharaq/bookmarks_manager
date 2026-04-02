//we want to catch unexpected errors from the backend
//and return them as AppException
// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bookmarks_manager/data/repositories/auth/models/auth_response.dart';
import 'package:bookmarks_manager/data/services/api/api_client.dart';
import 'package:bookmarks_manager/data/services/api/api_client_provider.dart';
import 'package:bookmarks_manager/domain/error/app_exception.dart';
import 'package:bookmarks_manager/domain/models/user/user.dart';
import 'package:bookmarks_manager/domain/result/result.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  const AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  Logger get _log => Logger('AuthRepository');

  Future<Result<({User user, String token})>> createAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final result = await _apiClient.post(
      '/auth/signup',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      },
    );

    return result.fold(
      onOk: (data) {
        try {
          _log.info('User created successfully');
          final authResponse = AuthResponse.fromJson(
            data as Map<String, dynamic>,
          );
          return Result.ok((
            user: authResponse.user,
            token: authResponse.token,
          ));
        } catch (error, stackTrace) {
          _log.severe('Failed to parse auth response', error, stackTrace);
          return Result.error(
            AppException.parse(
              'Failed to parse authentication response',
              stackTrace,
            ),
          );
        }
      },
      onError: (error) {
        _log.warning('login failed: $error');
        return Result.error(error);
      },
    );
  }

  Future<Result<({User user, String token})>> login({
    required String email,
    required String password,
  }) async {
    final result = await _apiClient.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return result.fold(
      onOk: (data) {
        try {
          _log.info('User authenticated');
          final authResponse = AuthResponse.fromJson(
            data as Map<String, dynamic>,
          );
          return Result.ok((
            user: authResponse.user,
            token: authResponse.token,
          ));
        } catch (error, stackTrace) {
          _log.severe('Failed to parse auth response', error, stackTrace);
          return Result.error(
            AppException.parse(
              'Failed to parse authentication response',
              stackTrace,
            ),
          );
        }
      },
      onError: (error) {
        _log.warning('login failed: $error');
        return Result.error(error);
      },
    );
  }

  Future<Result<bool>> requestPasswordReset({
    required String email,
  }) async {
    final result = await _apiClient.post(
      '/auth/forgot-password',
      data: {'email': email},
    );

    return result.fold(
      onOk: (_) {
        _log.info('OTP sent to $email');
        return const Result.ok(true);
      },
      onError: (error) {
        _log.warning('Failed to request password reset: $error');
        return Result.error(error);
      },
    );
  }

  Future<Result<bool>> resetPassword({
    required String otp,
    required String password,
    required String confirmedPassword,
  }) async {
    final result = await _apiClient.post(
      '/auth/reset-password',
      data: {
        'otp': otp,
        'newPassword': password,
        'passwordConfirmation': confirmedPassword,
      },
    );

    return result.fold(
      onOk: (data) {
        _log.info('Password reset successful $data');
        final status = (data as Map<String, dynamic>)['success'] as bool;
        return Result.ok(status);
      },
      onError: (error) {
        _log.warning('Password reset failed: $error');
        return Result.error(error);
      },
    );
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient: apiClient);
}
