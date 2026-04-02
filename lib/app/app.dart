import 'dart:io' show Platform;

import 'package:bookmarks_manager/app/providers/initialization/app_initialization.dart';
import 'package:bookmarks_manager/app/providers/settings/app_settings_provider.dart';
import 'package:bookmarks_manager/app/routing/app_router.dart';
import 'package:bookmarks_manager/ui/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(appSettingsStateProvider).themeMode;
    ref.listen(appInitializationProvider, (previous, next) {
      next.whenData(router.go);
    });

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      ensureScreenSize: true,
      enableScaleText: () => false,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: ToastificationWrapper(
            config: ToastificationConfig(
              marginBuilder: (context, alignment) => EdgeInsets.zero,
              alignment: AlignmentDirectional.topCenter,
            ),
            child: MaterialApp.router(
              routerConfig: router,
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              builder: (context, child) {
                final theme = Theme.of(context);
                final brightness = Theme.brightnessOf(context);
                final androidStatusBarBrightness =
                    brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light;

                final androidIconBrightness =
                    Theme.brightnessOf(context) == Brightness.light
                    ? Brightness.dark
                    : Brightness.light;
                return AnnotatedRegion(
                  value: SystemUiOverlayStyle(
                    systemNavigationBarColor: theme.colorScheme.surface,
                    systemNavigationBarDividerColor: theme.colorScheme.outline,
                    statusBarColor: theme.colorScheme.surface,
                    systemStatusBarContrastEnforced: false,
                    systemNavigationBarContrastEnforced: false,
                    statusBarBrightness: Platform.isIOS
                        ? brightness
                        : androidStatusBarBrightness,
                    statusBarIconBrightness: androidIconBrightness,
                    systemNavigationBarIconBrightness: androidIconBrightness,
                  ),
                  child: child!,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
