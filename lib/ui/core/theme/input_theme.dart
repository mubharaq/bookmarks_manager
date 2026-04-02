import 'package:flutter/material.dart';

class AppInputTheme extends ThemeExtension<AppInputTheme> {
  const AppInputTheme({
    required this.emptyBackground,
    required this.filledBackground,
    required this.invalidBackground,
    required this.emptyBorderColor,
  });

  final Color emptyBackground;
  final Color filledBackground;
  final Color invalidBackground;
  final Color emptyBorderColor;

  @override
  ThemeExtension<AppInputTheme> copyWith({
    Color? emptyBackground,
    Color? invalidBackground,
    Color? filledBackground,
    Color? emptyBorderColor,
  }) {
    return AppInputTheme(
      emptyBackground: emptyBackground ?? this.emptyBackground,
      filledBackground: filledBackground ?? this.filledBackground,
      invalidBackground: invalidBackground ?? this.invalidBackground,
      emptyBorderColor: emptyBorderColor ?? this.emptyBorderColor,
    );
  }

  @override
  ThemeExtension<AppInputTheme> lerp(
    covariant AppInputTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return AppInputTheme(
      emptyBackground: Color.lerp(
        emptyBackground,
        other.emptyBackground,
        t,
      )!,
      filledBackground: Color.lerp(
        filledBackground,
        other.filledBackground,
        t,
      )!,
      invalidBackground: Color.lerp(
        invalidBackground,
        other.invalidBackground,
        t,
      )!,
      emptyBorderColor: Color.lerp(
        emptyBorderColor,
        other.emptyBorderColor,
        t,
      )!,
    );
  }
}

extension ThemeExtensions on ThemeData {
  AppInputTheme get appInputTheme => extension<AppInputTheme>()!;
}
