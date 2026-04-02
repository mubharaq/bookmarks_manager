// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppSettingsState)
final appSettingsStateProvider = AppSettingsStateProvider._();

final class AppSettingsStateProvider
    extends $NotifierProvider<AppSettingsState, AppSettings> {
  AppSettingsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSettingsStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSettingsStateHash();

  @$internal
  @override
  AppSettingsState create() => AppSettingsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSettings>(value),
    );
  }
}

String _$appSettingsStateHash() => r'fd3a1b76548d35ce2ebac993e741e0db8e71c39d';

abstract class _$AppSettingsState extends $Notifier<AppSettings> {
  AppSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppSettings, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppSettings, AppSettings>,
              AppSettings,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
