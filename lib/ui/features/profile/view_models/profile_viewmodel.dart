import 'package:bookmarks_manager/app/providers/auth/auth_state_provider.dart';
import 'package:bookmarks_manager/app/providers/user/current_user_provider.dart';
import 'package:bookmarks_manager/data/repositories/user/user_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';
part 'profile_viewmodel.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    required bool isLoading,
    String? errorMessage,
  }) = _ProfileState;

  factory ProfileState.initial() => const ProfileState(
    isLoading: false,
  );
}

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  ProfileState build() => ProfileState.initial();

  Future<bool> deleteAccount() async {
    final repository = ref.read(
      userRepositoryProvider,
    );
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await repository.deleteAccount();
    return result.fold(
      onOk: (_) async {
        await ref.read(authenticationStateProvider.notifier).clearAll();
        state = state.copyWith(isLoading: false, errorMessage: null);
        return true;
      },
      onError: (error) {
        state = state.copyWith(
          errorMessage: error.errorMessage,
          isLoading: false,
        );
        return false;
      },
    );
  }

  Future<bool> logOut() async {
    final repository = ref.read(
      userRepositoryProvider,
    );
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await repository.logout();
    return result.fold(
      onOk: (_) async {
        ref.invalidate(currentUserProvider);
        await ref.read(authenticationStateProvider.notifier).logout();
        state = state.copyWith(isLoading: false, errorMessage: null);
        return true;
      },
      onError: (error) {
        state = state.copyWith(
          errorMessage: error.errorMessage,
          isLoading: false,
        );
        return false;
      },
    );
  }
}
