import 'package:bookmarks_manager/app/providers/settings/app_settings_provider.dart';
import 'package:bookmarks_manager/app/routing/app_routes.dart';
import 'package:bookmarks_manager/gen/assets.gen.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_button.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  Future<void> completeOnboarding() async {
    await ref
        .read(appSettingsStateProvider.notifier)
        .updateOnboardingStatus(completedOnboarding: true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              AppImage(
                imageUrl: Assets.images.icon.path,
                height: 342.h,
              ),
              24.verticalSpace,
              Text(
                'THE DIGITAL CURATOR',
                style: AppTextStyles.text.md.semibold.copyWith(
                  letterSpacing: 2,
                ),
              ),
              24.verticalSpace,
              Text(
                '''A serene sanctuary for your digital discoveries. Save articles, media, and insights into a beautifully organized editorial archive.''',
                style: AppTextStyles.text.sm.regular.copyWith(
                  height: 1.6,
                ),
              ),
              32.verticalSpace,
              AppButton(
                onPressed: () async {
                  await completeOnboarding();
                  if (!context.mounted) return;
                  context.go(const RegisterScreenRoute().location);
                },
                label: 'Get Started',
              ),
              4.verticalSpace,
              AppButton(
                onPressed: () async {
                  await completeOnboarding();
                  if (!context.mounted) return;
                  context.go(const LoginScreenRoute().location);
                },
                label: 'Sign in',
                variant: .secondary,
                backgroundColor: colorScheme.tertiaryContainer,
                textColor: colorScheme.onTertiaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
