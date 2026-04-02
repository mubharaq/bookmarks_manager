// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_manager_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fcmTokenRefresh)
final fcmTokenRefreshProvider = FcmTokenRefreshProvider._();

final class FcmTokenRefreshProvider
    extends $FunctionalProvider<AsyncValue<String>, String, Stream<String>>
    with $FutureModifier<String>, $StreamProvider<String> {
  FcmTokenRefreshProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fcmTokenRefreshProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fcmTokenRefreshHash();

  @$internal
  @override
  $StreamProviderElement<String> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String> create(Ref ref) {
    return fcmTokenRefresh(ref);
  }
}

String _$fcmTokenRefreshHash() => r'ef3b1f75fbc027378d4257c7d84fef5cfd322685';

@ProviderFor(onMessage)
final onMessageProvider = OnMessageProvider._();

final class OnMessageProvider
    extends
        $FunctionalProvider<
          AsyncValue<RemoteMessage>,
          RemoteMessage,
          Stream<RemoteMessage>
        >
    with $FutureModifier<RemoteMessage>, $StreamProvider<RemoteMessage> {
  OnMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onMessageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onMessageHash();

  @$internal
  @override
  $StreamProviderElement<RemoteMessage> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<RemoteMessage> create(Ref ref) {
    return onMessage(ref);
  }
}

String _$onMessageHash() => r'8d97b2027f6554733fac84cab797b0202f3616b1';

@ProviderFor(onMessageOpenedApp)
final onMessageOpenedAppProvider = OnMessageOpenedAppProvider._();

final class OnMessageOpenedAppProvider
    extends
        $FunctionalProvider<
          AsyncValue<RemoteMessage>,
          RemoteMessage,
          Stream<RemoteMessage>
        >
    with $FutureModifier<RemoteMessage>, $StreamProvider<RemoteMessage> {
  OnMessageOpenedAppProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onMessageOpenedAppProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onMessageOpenedAppHash();

  @$internal
  @override
  $StreamProviderElement<RemoteMessage> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<RemoteMessage> create(Ref ref) {
    return onMessageOpenedApp(ref);
  }
}

String _$onMessageOpenedAppHash() =>
    r'7e6074da675d7f0a35efdb16335c8892e656f907';

@ProviderFor(PushNotificationManager)
final pushNotificationManagerProvider = PushNotificationManagerProvider._();

final class PushNotificationManagerProvider
    extends $AsyncNotifierProvider<PushNotificationManager, void> {
  PushNotificationManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushNotificationManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushNotificationManagerHash();

  @$internal
  @override
  PushNotificationManager create() => PushNotificationManager();
}

String _$pushNotificationManagerHash() =>
    r'10d40d5ddcabf5bbd72b6892846f3521ea6b58d0';

abstract class _$PushNotificationManager extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
