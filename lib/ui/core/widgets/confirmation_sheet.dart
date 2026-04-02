import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ConfirmationVariant { danger, warning }

class ConfirmationSheet extends StatelessWidget {
  const ConfirmationSheet({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.variant = ConfirmationVariant.danger,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final ConfirmationVariant variant;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirm,
    ConfirmationVariant variant = ConfirmationVariant.danger,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => ConfirmationSheet(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        variant: variant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final (iconData, iconBg, iconColor) = switch (variant) {
      .danger => (
        Icons.delete_outline,
        AppColors.error.shade0,
        AppColors.error.shade300,
      ),
      .warning => (
        Icons.logout,
        AppColors.secondary.shade0,
        AppColors.secondary.shade600,
      ),
    };

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 40.h),
      child: Column(
        mainAxisSize: .min,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: iconBg,
              shape: .circle,
            ),
            child: Icon(iconData, size: 26.sp, color: iconColor),
          ),
          16.verticalSpace,
          Text(
            title,
            textAlign: .center,
            style: AppTextStyles.text.lg.bold.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          8.verticalSpace,
          Text(
            message,
            textAlign: .center,
            style: AppTextStyles.text.sm.regular.copyWith(
              color: colorScheme.outline,
            ),
          ),
          28.verticalSpace,
          AppButton(
            label: confirmLabel,
            variant: variant == .danger
                ? ButtonVariant.destructive
                : ButtonVariant.primary,
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
          12.verticalSpace,
          AppButton(
            label: 'Cancel',
            variant: .neutral,
            backgroundColor: colorScheme.tertiaryContainer,
            textColor: colorScheme.onSurface,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
