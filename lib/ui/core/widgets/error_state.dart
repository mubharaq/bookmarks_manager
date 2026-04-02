import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'An unexpected error occurred. Please try again.',
    this.onRetry,
    this.isRetrying = false,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final bool isRetrying;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: AppColors.error.shade0,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error,
                size: 32.sp,
                color: AppColors.error.shade300,
              ),
            ),
            20.verticalSpace,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.text.lg.semibold.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            8.verticalSpace,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.text.sm.regular.copyWith(
                color: colorScheme.outline,
              ),
            ),
            if (onRetry != null) ...[
              24.verticalSpace,
              AppButton(
                label: 'Try again',
                isFullWidth: false,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                onPressed: onRetry,
                isLoading: isRetrying,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
