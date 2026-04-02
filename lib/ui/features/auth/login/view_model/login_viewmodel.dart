import 'package:bookmarks_manager/app/providers/auth/auth_state_provider.dart';
import 'package:bookmarks_manager/data/repositories/auth/auth_repository.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_viewmodel.g.dart';

final loginMutation = Mutation<void>();

@riverpod
class LoginViewmodel extends _$LoginViewmodel {
  @override
  void build() {}

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);

    return response.fold(
      onOk: (data) async {
        await ref.read(authenticationStateProvider.notifier).login((
          token: data.token,
          user: data.user,
        ));
      },
      onError: (error) => throw error,
    );
  }
}
