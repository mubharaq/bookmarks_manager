// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisterViewmodel)
final registerViewmodelProvider = RegisterViewmodelProvider._();

final class RegisterViewmodelProvider
    extends $NotifierProvider<RegisterViewmodel, void> {
  RegisterViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerViewmodelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerViewmodelHash();

  @$internal
  @override
  RegisterViewmodel create() => RegisterViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$registerViewmodelHash() => r'd0a87a2d973bf6fc5625b644390607858ce1e659';

abstract class _$RegisterViewmodel extends $Notifier<void> {
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
