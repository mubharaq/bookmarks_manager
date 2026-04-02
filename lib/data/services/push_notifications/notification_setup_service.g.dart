// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_setup_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationSetupService)
final notificationSetupServiceProvider = NotificationSetupServiceProvider._();

final class NotificationSetupServiceProvider
    extends
        $FunctionalProvider<
          NotificationSetupService,
          NotificationSetupService,
          NotificationSetupService
        >
    with $Provider<NotificationSetupService> {
  NotificationSetupServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSetupServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSetupServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationSetupService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationSetupService create(Ref ref) {
    return notificationSetupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationSetupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationSetupService>(value),
    );
  }
}

String _$notificationSetupServiceHash() =>
    r'fa5415957fe8f95624838ed6ba659d7931eea4d9';
