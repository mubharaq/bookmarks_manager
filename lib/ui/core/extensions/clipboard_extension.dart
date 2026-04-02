import 'package:bookmarks_manager/ui/core/extensions/toast_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ClipboardExtension on BuildContext {
  Future<void> copyToClipboard(
    String text, {
    String feedbackMessage = 'Copied to clipboard',
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    showSuccessToast(feedbackMessage);
  }
}
