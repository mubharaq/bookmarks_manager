import 'package:bookmarks_manager/ui/core/theme/button_theme.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_image.dart';
import 'package:bookmarks_manager/ui/core/widgets/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ButtonVariant { primary, secondary, neutral, destructive }

enum IconPosition { left, right }

class AppButton extends StatelessWidget {
  const AppButton({
    this.onPressed,
    super.key,
    this.label,
    this.icon,
    this.width,
    this.height,
    this.iconHeight,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.isDisabled = false,
    this.isLoading = false,
    this.isFullWidth = true,
    this.labelFontSize,
    this.padding,
    this.radius,
    this.iconPosition = IconPosition.left,
    this.variant = ButtonVariant.primary,
  }) : assert(
         label != null || icon != null,
         'Either label or icon must be provided',
       );
  final String? label;
  final String? icon;
  final double? width;
  final double? height;
  final double? iconHeight;
  final double? radius;
  final double? labelFontSize;
  final bool isDisabled;
  final bool isLoading;
  final bool isFullWidth;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final ButtonVariant variant;
  final IconPosition iconPosition;
  final EdgeInsets? padding;

  Widget? _labelWidget(AppButtonThemeData theme) {
    if (label == null) return null;

    return Text(
      label!,
      style: AppTextStyles.text.md.semibold.copyWith(
        fontSize: labelFontSize,
        color: isDisabled
            ? theme.disabledTextColor
            : (textColor ?? theme.textColor),
      ),
    );
  }

  Widget? _iconWidget(AppButtonThemeData theme) {
    if (icon == null) return null;

    return AppImage(
      imageUrl: icon!,
      height: iconHeight,
      color: isDisabled
          ? theme.disabledTextColor
          : (iconColor ?? theme.iconColor),
    );
  }

  Widget _loadingWidget(AppButtonThemeData theme) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          iconColor ?? theme.iconColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = switch (variant) {
      .primary => AppButtonTheme.defaultState,
      .secondary => AppButtonTheme.secondaryState,
      .destructive => AppButtonTheme.destructiveState,
      .neutral => AppButtonThemeData(
        textColor: colorScheme.onTertiaryContainer,
        backgroundColor: colorScheme.tertiaryContainer,
        disabledBackgroundColor: colorScheme.tertiaryContainer.withValues(
          alpha: .4,
        ),
        disabledTextColor: colorScheme.onTertiaryContainer.withValues(
          alpha: .4,
        ),
        iconColor: colorScheme.onTertiaryContainer,
      ),
    };

    return TouchableOpacity(
      isLoading: isLoading,
      isDisabled: isDisabled,
      onTap: onPressed,
      child: Container(
        width: width,
        height: height ?? 56.h,
        constraints: BoxConstraints(maxWidth: 382.w),
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
        decoration: ShapeDecoration(
          color: isDisabled
              ? theme.disabledBackgroundColor
              : (backgroundColor ?? theme.backgroundColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 16.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: .center,
          mainAxisSize: isFullWidth ? .max : .min,
          spacing: 4.h,
          children: [
            if (isLoading) ...[
              _loadingWidget(theme),
            ] else ...[
              if (icon != null && iconPosition == .left) ...[
                _iconWidget(theme)!,
              ],
              if (label != null) ...[_labelWidget(theme)!],
              if (icon != null && iconPosition == .right) ...[
                _iconWidget(theme)!,
              ],
            ],
          ],
        ),
      ),
    );
  }
}
