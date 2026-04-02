// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginViewmodel)
final loginViewmodelProvider = LoginViewmodelProvider._();

final class LoginViewmodelProvider
    extends $NotifierProvider<LoginViewmodel, void> {
  LoginViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginViewmodelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginViewmodelHash();

  @$internal
  @override
  LoginViewmodel create() => LoginViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$loginViewmodelHash() => r'e1df5a8ecaed530d4e2562c52f56fbcd2ed5ce7f';

abstract class _$LoginViewmodel extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
