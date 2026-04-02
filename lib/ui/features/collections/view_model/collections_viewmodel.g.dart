// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CollectionsViewModel)
final collectionsViewModelProvider = CollectionsViewModelProvider._();

final class CollectionsViewModelProvider
    extends $NotifierProvider<CollectionsViewModel, void> {
  CollectionsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionsViewModelHash();

  @$internal
  @override
  CollectionsViewModel create() => CollectionsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$collectionsViewModelHash() =>
    r'2d6c79e8809b50af2a5368eb98a2a5c69ebee3da';

abstract class _$CollectionsViewModel extends $Notifier<void> {
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
