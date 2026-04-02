import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final class ProviderLogger extends ProviderObserver {
  final log = Logger('Riverpod');
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    log.info('''
      {
        "provider": "${context.provider}",
        "Value Created": "$value"
      }''');
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    log.info('''
      {
        "provider": "${context.provider}",
        "Error": "$error at $stackTrace"
      }''');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    log.info('''
      {
        "provider": "${context.provider}",
        "previousValue": "$previousValue"
        "newValue": "$newValue",
        "mutation": "${context.mutation}"
      }''');
  }

  @override
  void didDisposeProvider(
    ProviderObserverContext context,
  ) {
    log.info('''
      {
        "provider": "${context.provider}",
        "newValue": "disposed"
      }''');
  }
}
