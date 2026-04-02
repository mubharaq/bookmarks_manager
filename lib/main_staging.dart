import 'package:bookmarks_manager/app/config/app_config.dart';
import 'package:bookmarks_manager/bootstrap.dart';

Future<void> main() async {
  await bootstrap(AppEnvironment.staging);
}
