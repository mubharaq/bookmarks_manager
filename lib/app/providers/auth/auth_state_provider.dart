import 'package:bookmarks_manager/data/services/auth_storage/auth_storage_service.dart';
import 'package:bookmarks_manager/domain/models/user/user.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_provider.g.dart';

sealed class AuthState {
  const AuthState._();
  const factory AuthState.authenticated({
    required User user,
  }) = Authenticated;
  const factory AuthState.unauthenticated({String? errorMessage}) =
      Unauthenticated;
}

final class Authenticated extends AuthState {
  const Authenticated({
    required this.user,
  }) : super._();

  final User user;
  Authenticated copyWith({User? user}) {
    return Authenticated(
      user: user ?? this.user,
    );
  }
}

final class Unauthenticated extends AuthState {
  const Unauthenticated({this.errorMessage}) : super._();
  final String? errorMessage;
}

@riverpod
class AuthenticationState extends _$AuthenticationState {
  final _log = Logger('AuthenticationState');

  @override
  AuthState build() {
    final storage = ref.read(authStorageServiceProvider);
    final saved = storage.loadAuthState();

    if (saved == null) return const AuthState.unauthenticated();

    return AuthState.authenticated(user: saved.user);
  }

  Future<void> login(({User user, String token}) data) async {
    final storage = ref.read(authStorageServiceProvider);
    try {
      await storage.saveAuthState(user: data.user, token: data.token);
      state = AuthState.authenticated(user: data.user);
    } on Exception catch (error) {
      _log.severe('Failed to persist auth state', error);
      rethrow;
    }
  }

  Future<void> updateUser(User user) async {
    final storage = ref.read(authStorageServiceProvider);
    try {
      await storage.saveUser(user);
      final current = state;
      if (current is Authenticated) {
        state = current.copyWith(user: user);
      }
    } on Exception catch (error) {
      _log.severe('Failed to update user', error);
      rethrow;
    }
  }

  Future<void> logout({String? errorMessage}) async {
    final storage = ref.read(authStorageServiceProvider);
    await storage.clearUser();
    state = AuthState.unauthenticated(errorMessage: errorMessage);
  }

  Future<void> clearAll() async {
    final storage = ref.read(authStorageServiceProvider);
    await storage.clearAll();
    state = const AuthState.unauthenticated();
  }
}
