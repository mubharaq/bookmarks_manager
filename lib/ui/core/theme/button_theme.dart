import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:flutter/widgets.dart' show Color;

class AppButtonTheme {
  static final defaultState = AppButtonThemeData(
    backgroundColor: AppColors.green.shade700,
    iconColor: AppColors.neutrals.shade0,
    textColor: AppColors.neutrals.shade0,
    disabledBackgroundColor: AppColors.green.shade300,
    disabledTextColor: AppColors.green.shade900,
  );
  static final secondaryState = AppButtonThemeData(
    backgroundColor: AppColors.secondary,
    iconColor: AppColors.neutrals.shade0,
    textColor: AppColors.neutrals.shade0,
    disabledBackgroundColor: AppColors.secondary.shade100,
    disabledTextColor: AppColors.neutrals.shade600,
  );
  static final destructiveState = AppButtonThemeData(
    backgroundColor: AppColors.error.shade300,
    iconColor: AppColors.neutrals.shade0,
    textColor: AppColors.neutrals.shade0,
    disabledBackgroundColor: AppColors.error.shade200,
    disabledTextColor: AppColors.neutrals.shade400,
  );
}

class AppButtonThemeData {
  const AppButtonThemeData({
    required this.textColor,
    required this.backgroundColor,
    required this.disabledBackgroundColor,
    required this.disabledTextColor,
    required this.iconColor,
  });
  final Color textColor;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color disabledTextColor;
  final Color iconColor;
}
