// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResetPasswordViewmodel)
final resetPasswordViewmodelProvider = ResetPasswordViewmodelProvider._();

final class ResetPasswordViewmodelProvider
    extends $NotifierProvider<ResetPasswordViewmodel, ResetPasswordState> {
  ResetPasswordViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetPasswordViewmodelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordViewmodelHash();

  @$internal
  @override
  ResetPasswordViewmodel create() => ResetPasswordViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResetPasswordState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResetPasswordState>(value),
    );
  }
}

String _$resetPasswordViewmodelHash() =>
    r'584749d17b22acd9ce4a9d2978959129f43e4bf1';

abstract class _$ResetPasswordViewmodel extends $Notifier<ResetPasswordState> {
  ResetPasswordState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ResetPasswordState, ResetPasswordState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ResetPasswordState, ResetPasswordState>,
              ResetPasswordState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
