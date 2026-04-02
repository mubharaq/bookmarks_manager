import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:flutter/material.dart';

enum ToastStyleType { error, warning, neutral, success }

extension ToastStyleExtension on ToastStyleType {
  ToastTheme get theme => switch (this) {
    ToastStyleType.error => const ToastTheme(
      bgColor: AppColors.error,
      textColor: AppColors.neutrals,
      btnBg: AppColors.error,
    ),
    ToastStyleType.warning => ToastTheme(
      bgColor: AppColors.coralRed,
      textColor: AppColors.neutrals.shade900,
      btnBg: AppColors.coralRed.shade200,
    ),
    ToastStyleType.neutral => ToastTheme(
      bgColor: AppColors.neutrals,
      textColor: AppColors.neutrals.shade900,
      btnBg: AppColors.neutrals.shade300,
    ),
    ToastStyleType.success => ToastTheme(
      bgColor: AppColors.success,
      textColor: AppColors.neutrals,
      btnBg: AppColors.success.shade300,
    ),
  };
}

final class ToastTheme {
  const ToastTheme({
    required this.bgColor,
    required this.textColor,
    required this.btnBg,
  });
  final Color bgColor;
  final Color btnBg;
  final Color textColor;
}
