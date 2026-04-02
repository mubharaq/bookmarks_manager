import 'package:bookmarks_manager/data/services/api/api_client.dart';
import 'package:bookmarks_manager/data/services/api/api_client_provider.dart';
import 'package:bookmarks_manager/domain/result/result.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'misc_repository.g.dart';

class MiscRepository {
  const MiscRepository({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  Logger get _log => Logger('MiscRepository');

  Future<Result<bool>> saveFcmToken({
    required String fcmToken,
    required String platform,
  }) async {
    final result = await _apiClient.post(
      '/devices/fcm-token',
      data: {'fcmToken': fcmToken, 'platform': platform},
    );
    return result.fold(
      onOk: (data) {
        _log.info('fcm token saved successfully');
        final responseData = (data as Map<String, dynamic>)['success'] as bool;
        return Result.ok(responseData);
      },
      onError: (error) {
        _log.warning('Error saving fcm token');
        return Result.error(error);
      },
    );
  }
}

@riverpod
MiscRepository miscRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MiscRepository(apiClient: apiClient);
}
