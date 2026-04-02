import 'dart:async';

import 'package:bookmarks_manager/app/providers/push_notifications/push_notification_manager_provider.dart';
import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationPromptSheet extends ConsumerStatefulWidget {
  const NotificationPromptSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool?>(
      context: context,
      builder: (_) => const NotificationPromptSheet(),
    );
  }

  @override
  ConsumerState<NotificationPromptSheet> createState() =>
      _NotificationPromptSheetState();
}

class _NotificationPromptSheetState
    extends ConsumerState<NotificationPromptSheet> {
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(
        ref.read(pushNotificationManagerProvider.notifier).recordPromptShown(),
      );
    });
  }

  Future<void> _enableNotifications() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final manager = ref.read(pushNotificationManagerProvider.notifier);
      await manager.ensureTokenSynced(requestIfNeeded: true);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _maybeLater() {
    if (_isSubmitting) return;
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _isSubmitting,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: _isSubmitting ? 0.7 : 1,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 40.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  color: AppColors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  size: 32.sp,
                  color: AppColors.green.shade700,
                ),
              ),
              20.verticalSpace,
              Text(
                'Stay in the loop',
                style: AppTextStyles.text.xl.bold.copyWith(
                  color: AppColors.neutrals.shade900,
                ),
              ),
              8.verticalSpace,
              Text(
                'Enable notifications to get timely updates on your saved bookmarks and collections.',
                textAlign: TextAlign.center,
                style: AppTextStyles.text.sm.regular.copyWith(
                  color: AppColors.neutrals.shade600,
                ),
              ),
              32.verticalSpace,
              AppButton(
                label: _isSubmitting
                    ? 'Enabling notifications...'
                    : 'Enable notifications',
                onPressed: _enableNotifications,
              ),
              6.verticalSpace,
              AppButton(
                label: 'Maybe later',
                variant: ButtonVariant.secondary,
                onPressed: _maybeLater,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
