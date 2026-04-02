import 'package:bookmarks_manager/app/providers/settings/app_settings_provider.dart';
import 'package:bookmarks_manager/app/providers/user/current_user_provider.dart';
import 'package:bookmarks_manager/ui/core/extensions/datetime_extension.dart';
import 'package:bookmarks_manager/ui/core/extensions/toast_extension.dart';
import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_button.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_scaffold.dart';
import 'package:bookmarks_manager/ui/core/widgets/confirmation_sheet.dart';
import 'package:bookmarks_manager/ui/features/profile/view_models/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final themeMode = ref.watch(appSettingsStateProvider).themeMode;
    final colorScheme = Theme.of(context).colorScheme;
    final initials = '${user?.firstName[0]}${user?.lastName[0]}'.toUpperCase();
    final isLoading = ref.watch(profileViewModelProvider).isLoading;
    ref.listen(profileViewModelProvider.select((state) => state.errorMessage), (
      previous,
      next,
    ) {
      if (next != null) {
        context.showErrorToast(next);
      }
    });

    return AppScaffold(
      showLoader: isLoading,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              32.verticalSpace,
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.green.shade700,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: AppTextStyles.display.xs.bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    Text(
                      '${user?.firstName} ${user?.lastName}',
                      style: AppTextStyles.text.xl.bold.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      user?.email ?? '',
                      style: AppTextStyles.text.sm.regular.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'Member since ${user?.createdAt.date()}',
                      style: AppTextStyles.text.xs.regular.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              32.verticalSpace,
              Divider(color: colorScheme.outline),
              24.verticalSpace,
              Text(
                'Appearance',
                style: AppTextStyles.text.sm.semibold.copyWith(
                  color: colorScheme.outline,
                ),
              ),
              12.verticalSpace,
              SegmentedButton<ThemeMode>(
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: colorScheme.primary,
                  selectedForegroundColor: colorScheme.onPrimary,
                  foregroundColor: colorScheme.onSurface,
                ),
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(
                      'System',
                      style: AppTextStyles.text.sm.medium,
                    ),
                    icon: const Icon(Icons.brightness_auto_outlined, size: 16),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(
                      'Light',
                      style: AppTextStyles.text.sm.medium,
                    ),
                    icon: const Icon(Icons.light_mode_outlined, size: 16),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(
                      'Dark',
                      style: AppTextStyles.text.sm.medium,
                    ),
                    icon: const Icon(Icons.dark_mode_outlined, size: 16),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (modes) => ref
                    .read(appSettingsStateProvider.notifier)
                    .updateThemeMode(modes.first),
              ),
              24.verticalSpace,
              Divider(color: colorScheme.outline),
              24.verticalSpace,
              Text(
                'Account',
                style: AppTextStyles.text.sm.semibold.copyWith(
                  color: colorScheme.outline,
                ),
              ),
              16.verticalSpace,
              AppButton(
                label: 'Log out',
                variant: ButtonVariant.neutral,
                onPressed: () => ConfirmationSheet.show(
                  context,
                  variant: ConfirmationVariant.warning,
                  title: 'Log out?',
                  message:
                      '''You will need to sign in again to access your bookmarks.''',
                  confirmLabel: 'Log out',
                  onConfirm: () async {
                    final isSuccess = await ref
                        .read(profileViewModelProvider.notifier)
                        .logOut();
                    if (isSuccess && context.mounted) {
                      context.showSuccessToast('Logged out successfully');
                    }
                  },
                ),
              ),
              12.verticalSpace,
              AppButton(
                label: 'Delete account',
                variant: ButtonVariant.destructive,
                onPressed: () => ConfirmationSheet.show(
                  context,
                  title: 'Delete account?',
                  message:
                      '''This will permanently delete your account and all saved bookmarks. This action cannot be undone.''',
                  confirmLabel: 'Delete account',
                  onConfirm: () async {
                    final isSuccess = await ref
                        .read(profileViewModelProvider.notifier)
                        .deleteAccount();
                    if (isSuccess && context.mounted) {
                      context.showSuccessToast('Account deleted successfully');
                    }
                  },
                ),
              ),
              32.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
