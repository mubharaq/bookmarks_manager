import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/constants.dart';
import 'package:bookmarks_manager/ui/core/theme/input_theme.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppTheme {
  static InputDecorationThemeData _baseInputTheme({
    required Color fillColor,
    required Color labelColor,
    required Color hintColor,
    required Color borderColor,
    required Color prefixIconColor,
    required Color suffixIconColor,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: borderColor),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: AppColors.green.shade200),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: AppColors.error),
    );

    return InputDecorationThemeData(
      filled: true,
      fillColor: fillColor,
      labelStyle: AppTextStyles.text.xs.regular.copyWith(
        color: labelColor,
      ),
      hintStyle: AppTextStyles.text.sm.regular.copyWith(
        color: hintColor,
      ),
      errorStyle: AppTextStyles.text.xs.regular.copyWith(
        color: AppColors.error,
        fontStyle: FontStyle.italic,
      ),
      prefixIconConstraints: BoxConstraints(minWidth: 24.w, minHeight: 24.h),
      suffixIconConstraints: BoxConstraints(minWidth: 24.w, minHeight: 24.h),
      prefixIconColor: prefixIconColor,
      suffixIconColor: suffixIconColor,
      border: border,
      enabledBorder: border,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      constraints: BoxConstraints(minHeight: 50.h),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
    );
  }

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: defaultFontFamily,
    fontFamilyFallback: const ['Roboto'],
    appBarTheme: AppBarThemeData(
      leadingWidth: 60.w + 24,
      titleTextStyle: AppTextStyles.text.md.medium.copyWith(
        color: AppColors.neutrals.shade900,
      ),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.green,
      primary: AppColors.green,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.error.shade100,
      onErrorContainer: AppColors.error,
      primaryContainer: AppColors.green.shade100,
      onPrimaryContainer: AppColors.green.shade900,
      surface: Colors.white,
      onSurface: AppColors.neutrals.shade900,
      outlineVariant: AppColors.neutrals.shade200,
      outline: AppColors.neutrals.shade400,
      tertiaryContainer: AppColors.neutrals.shade100,
      onTertiaryContainer: AppColors.neutrals.shade900,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: AppColors.neutrals.shade600,
      selectedItemColor: AppColors.green.shade700,
      selectedLabelStyle: AppTextStyles.text.xs.medium.copyWith(
        color: AppColors.green.shade700,
      ),
      unselectedLabelStyle: AppTextStyles.text.xs.regular.copyWith(
        color: AppColors.neutrals.shade600,
      ),
      selectedIconTheme: const IconThemeData(size: 24),
      unselectedIconTheme: const IconThemeData(size: 24),
    ),
    inputDecorationTheme: _baseInputTheme(
      fillColor: AppColors.neutrals[ColorShade.w50]!,
      labelColor: AppColors.neutrals.shade600,
      hintColor: AppColors.neutrals.shade300,
      borderColor: AppColors.neutrals.shade100,
      prefixIconColor: AppColors.neutrals.shade400,
      suffixIconColor: AppColors.neutrals.shade400,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      showDragHandle: true,
      backgroundColor: Colors.white,
      dragHandleSize: Size(41, 3),
      dragHandleColor: AppColors.neutrals,
      clipBehavior: Clip.none,
    ),
    extensions: [
      AppInputTheme(
        emptyBackground: AppColors.neutrals[ColorShade.w50]!,
        filledBackground: AppColors.green.shade100,
        invalidBackground: AppColors.error.shade100,
        emptyBorderColor: AppColors.neutrals.shade100,
      ),
    ],
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: defaultFontFamily,
    fontFamilyFallback: const ['Roboto'],
    appBarTheme: AppBarThemeData(
      leadingWidth: 60.w + 24,
      backgroundColor: Colors.transparent,
      titleTextStyle: AppTextStyles.text.md.medium.copyWith(
        color: Colors.white,
      ),
      surfaceTintColor: Colors.transparent,
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.green,
      primary: AppColors.green,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.error[ColorShade.w50],
      onErrorContainer: AppColors.error.shade600,
      primaryContainer: AppColors.green.shade100.withValues(alpha: .3),
      onPrimaryContainer: AppColors.green,
      surface: AppColors.neutrals.shade900,
      onSurface: Colors.white,
      outlineVariant: AppColors.neutrals.shade200,
      outline: AppColors.neutrals.shade300,
      tertiaryContainer: AppColors.neutrals[ColorShade.w800],
      onTertiaryContainer: AppColors.neutrals.shade100,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: AppColors.neutrals.shade600,
      selectedItemColor: AppColors.green.shade700,
      selectedLabelStyle: AppTextStyles.text.xs.medium.copyWith(
        color: AppColors.green.shade700,
      ),
      unselectedLabelStyle: AppTextStyles.text.xs.regular.copyWith(
        color: AppColors.neutrals.shade600,
      ),
      selectedIconTheme: const IconThemeData(size: 24),
      unselectedIconTheme: const IconThemeData(size: 24),
    ),
    inputDecorationTheme: _baseInputTheme(
      fillColor: AppColors.neutrals[ColorShade.w800]!,
      labelColor: AppColors.neutrals.shade600,
      hintColor: AppColors.neutrals.shade300,
      borderColor: AppColors.neutrals.shade200,
      prefixIconColor: AppColors.neutrals.shade400,
      suffixIconColor: AppColors.neutrals.shade400,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      showDragHandle: true,
      backgroundColor: AppColors.neutrals.shade900,
      dragHandleSize: const Size(41, 3),
      dragHandleColor: AppColors.neutrals.shade200,
    ),
    extensions: [
      AppInputTheme(
        emptyBorderColor: AppColors.neutrals.shade200,
        emptyBackground: AppColors.neutrals[ColorShade.w800]!,
        filledBackground: AppColors.green.shade100.withValues(alpha: .3),
        invalidBackground: AppColors.error.shade300.withValues(alpha: .3),
      ),
    ],
  );
}

extension ThemeBrightnessExtension on ThemeData {
  bool get isDarkMode => brightness == Brightness.dark;
  bool get isLightMode => brightness == Brightness.light;
}
