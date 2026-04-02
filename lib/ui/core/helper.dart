import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final _log = Logger('Helpers');

Future<void> openLink(
  String url, {
  bool? isStore,
}) async {
  final isStoreLink = isStore ?? false;
  if (!url.startsWith('https://')) return;

  try {
    final uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: isStoreLink
          ? LaunchMode.externalApplication
          : LaunchMode.platformDefault,
    )) {
      _log.fine('Could not launch $url');
    }
  } on PlatformException catch (error) {
    _log.fine('Failed to launch $url: $error');
  } on FormatException catch (error) {
    _log.fine('Failed to launch $url: $error');
  }
}

Color hexToColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xff')));
