import 'package:bookmarks_manager/data/repositories/auth/auth_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password_viewmodel.freezed.dart';
part 'reset_password_viewmodel.g.dart';

@freezed
abstract class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    required bool isLoading,
    required bool isResending,
    String? errorMessage,
  }) = _ResetPasswordState;

  factory ResetPasswordState.initial() => const ResetPasswordState(
    isLoading: false,
    isResending: false,
  );
}

@riverpod
class ResetPasswordViewmodel extends _$ResetPasswordViewmodel {
  @override
  ResetPasswordState build() => ResetPasswordState.initial();

  Future<bool> requestOtp({required String email}) =>
      _sendOtp(email: email, isResend: false);

  Future<bool> resendOtp({required String email}) =>
      _sendOtp(email: email, isResend: true);

  Future<bool> _sendOtp({required String email, required bool isResend}) async {
    state = state.copyWith(
      isLoading: !isResend,
      isResending: isResend,
      errorMessage: null,
    );
    final response = await ref
        .read(authRepositoryProvider)
        .requestPasswordReset(email: email);

    return response.fold(
      onOk: (_) {
        state = state.copyWith(isLoading: false, isResending: false);
        return true;
      },
      onError: (error) {
        state = state.copyWith(
          isLoading: false,
          isResending: false,
          errorMessage: error.errorMessage,
        );
        return false;
      },
    );
  }

  Future<bool> resetPassword({
    required String otp,
    required String password,
    required String confirmedPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final response = await ref
        .read(authRepositoryProvider)
        .resetPassword(
          otp: otp,
          password: password,
          confirmedPassword: confirmedPassword,
        );

    return response.fold(
      onOk: (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
      onError: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.errorMessage,
        );
        return false;
      },
    );
  }
}
