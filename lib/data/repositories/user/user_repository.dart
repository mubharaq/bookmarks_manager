import 'package:bookmarks_manager/data/services/api/api_client.dart';
import 'package:bookmarks_manager/data/services/api/api_client_provider.dart';
import 'package:bookmarks_manager/domain/models/user/user.dart';
import 'package:bookmarks_manager/domain/result/result.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

class UserRepository {
  const UserRepository({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  Logger get _log => Logger('UserRepository');

  Future<Result<User>> profile() async {
    final result = await _apiClient.get(
      '/user/profile',
    );
    return result.fold(
      onOk: (data) {
        _log.info('User profile fetched successfully');
        final user = User.fromJson(data as Map<String, dynamic>);
        return Result.ok(user);
      },
      onError: (error) {
        _log.warning('Error fetching user profile');
        return Result.error(error);
      },
    );
  }

  Future<Result<bool>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final request = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'passwordConfirmation': confirmPassword,
    };
    final result = await _apiClient.post(
      '/user/update-password',
      data: request,
    );
    return result.fold(
      onOk: (data) {
        _log.info('User Password changed successfully');
        final message = (data as Map<String, dynamic>)['success'] as bool;
        return Result.ok(message);
      },
      onError: (error) {
        _log.warning('Error updating user password');
        return Result.error(error);
      },
    );
  }

  Future<Result<bool>> logout() async {
    final result = await _apiClient.post('/auth/logout');
    return result.fold(
      onOk: (data) {
        _log.info('User logged out successfully');
        final status = (data as Map<String, dynamic>)['success'] as bool;
        return Result.ok(status);
      },
      onError: (error) {
        _log.warning('Error logging out user');
        return Result.error(error);
      },
    );
  }

  Future<Result<bool>> deleteAccount() async {
    final result = await _apiClient.delete('/user/account');
    return result.fold(
      onOk: (data) {
        _log.info('User account deleted successfully');
        final status = (data as Map<String, dynamic>)['success'] as bool;
        return Result.ok(status);
      },
      onError: (error) {
        _log.warning('Error deleting user account');
        return Result.error(error);
      },
    );
  }
}

@riverpod
UserRepository userRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(apiClient: apiClient);
}
