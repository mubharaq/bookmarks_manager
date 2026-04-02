enum AppEnvironment { dev, staging, prod }

class EnvInfo {
  static AppEnvironment _environment = AppEnvironment.dev;

  static set environment(AppEnvironment environment) {
    EnvInfo._environment = environment;
  }

  static String get baseUrl => _environment._baseUrl;
  static AppEnvironment get environment => _environment;
  static bool get isProd => _environment == AppEnvironment.prod;
}

extension EnvProperties on AppEnvironment {
  static const Map<AppEnvironment, String> _connectionStrings = {
    AppEnvironment.dev: 'https://bookmark-api-vdep.onrender.com',
    AppEnvironment.staging: 'https://bookmark-api-vdep.onrender.com',
    AppEnvironment.prod: 'https://bookmark-api-vdep.onrender.com',
  };
  String get _baseUrl => _connectionStrings[this]!;
}
