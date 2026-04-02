import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class RouterObserver extends NavigatorObserver {
  RouterObserver();

  final _log = Logger('RouterObserver');

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logScreen(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _logScreen(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      _logScreen(previousRoute);
    }
  }

  void _logScreen(Route<dynamic> route) {
    final settings = route.settings;
    if (settings.name == null) return;
    final routeName = settings.name!.split('?').first;
    _log.info(_formatRouteName(routeName));
  }

  String _formatRouteName(String routeName) {
    var name = routeName.startsWith('/') ? routeName.substring(1) : routeName;
    name = name
        .split('/')
        .map(
          (part) => part.isEmpty
              ? 'Home'
              : part.split('-').map(_capitalize).join(' '),
        )
        .join(' ');

    return '$name Screen';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
