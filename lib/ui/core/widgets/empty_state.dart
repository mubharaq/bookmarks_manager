import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 56.sp,
            color: colorScheme.outlineVariant,
          ),
          16.verticalSpace,
          Text(title, style: AppTextStyles.text.lg.semibold),
          6.verticalSpace,
          Text(
            subtitle,
            style: AppTextStyles.text.sm.regular,
          ),
        ],
      ),
    );
  }
}
