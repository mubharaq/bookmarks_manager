// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(miscRepository)
final miscRepositoryProvider = MiscRepositoryProvider._();

final class MiscRepositoryProvider
    extends $FunctionalProvider<MiscRepository, MiscRepository, MiscRepository>
    with $Provider<MiscRepository> {
  MiscRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'miscRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$miscRepositoryHash();

  @$internal
  @override
  $ProviderElement<MiscRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MiscRepository create(Ref ref) {
    return miscRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MiscRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MiscRepository>(value),
    );
  }
}

String _$miscRepositoryHash() => r'8aa7013600b2eca3852a56730a77aae3c116acc0';
