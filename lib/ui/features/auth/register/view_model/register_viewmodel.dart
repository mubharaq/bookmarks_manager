import 'package:bookmarks_manager/app/providers/auth/auth_state_provider.dart';
import 'package:bookmarks_manager/data/repositories/auth/auth_repository.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_viewmodel.g.dart';

final registerMutation = Mutation<void>();

@riverpod
class RegisterViewmodel extends _$RegisterViewmodel {
  @override
  void build() {}

  Future<void> createAccount({
    required String firstName,
    required String lastName,
    required String password,
    required String email,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    final response = await authRepository.createAccount(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    return await response.fold(
      onOk: (data) async {
        await ref.read(authenticationStateProvider.notifier).login((
          token: data.token,
          user: data.user,
        ));
      },
      onError: (error) {
        throw error;
      },
    );
  }
}
