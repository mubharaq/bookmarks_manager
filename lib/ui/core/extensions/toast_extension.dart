import 'package:bookmarks_manager/ui/core/theme/toast_theme.dart';
import 'package:bookmarks_manager/ui/core/widgets/toast_content.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:toastification/toastification.dart';

ToastificationItem _showToast({
  required String message,
  ToastStyleType? type,
}) {
  final theme = type?.theme ?? ToastStyleType.success.theme;
  final toastInstance = Toastification();
  return toastInstance.show(
    style: ToastificationStyle.fillColored,
    primaryColor: theme.bgColor,
    showIcon: false,
    closeOnClick: true,
    description: AppToastContent(
      theme: theme,
      message: message,
    ),
    autoCloseDuration: const Duration(seconds: 5),
  );
}

extension ToastExtension on BuildContext {
  ToastificationItem showSuccessToast(String message) {
    return _showToast(
      message: message,
      type: ToastStyleType.success,
    );
  }

  ToastificationItem showRegularToast(String message) {
    return _showToast(
      message: message,
      type: ToastStyleType.neutral,
    );
  }

  ToastificationItem showErrorToast(String message) {
    return _showToast(
      message: message,
      type: ToastStyleType.error,
    );
  }
}
