import 'dart:async';

import 'package:bookmarks_manager/app/providers/auth/auth_state_provider.dart';
import 'package:bookmarks_manager/data/repositories/user/user_repository.dart';
import 'package:bookmarks_manager/domain/models/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  User? build() {
    final authState = ref.read(authenticationStateProvider);
    final cachedUser = switch (authState) {
      Authenticated(:final user) => user,
      _ => null,
    };

    if (cachedUser != null) {
      unawaited(_refreshInBackground());
    }

    return cachedUser;
  }

  Future<void> _refreshInBackground() async {
    final repository = ref.read(userRepositoryProvider);
    final response = await repository.profile();

    await response.fold(
      onOk: (freshUser) async {
        state = freshUser;
        await ref
            .read(authenticationStateProvider.notifier)
            .updateUser(freshUser);
      },
      onError: (error) {},
    );
  }
}
