import 'package:bookmarks_manager/ui/core/theme/toast_theme.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppToastContent extends StatelessWidget {
  const AppToastContent({
    required this.theme,
    required this.message,
    super.key,
  });
  final ToastTheme theme;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.h,
      children: [
        Expanded(
          child: Text(
            message,
            style: AppTextStyles.text.md.medium.copyWith(
              color: theme.textColor,
            ),
          ),
        ),
      ],
    );
  }
}
