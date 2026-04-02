import 'package:bookmarks_manager/ui/core/theme/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  const AppTextStyles._();
  static const display = _Display();
  static const text = _Text();
}

class _Display {
  const _Display();

  TextSize get xl2 =>
      const TextSize(fontSize: 72, lineHeight: 90, letterSpacing: 0.03);
  TextSize get xl =>
      const TextSize(fontSize: 60, lineHeight: 72, letterSpacing: 0.03);
  TextSize get lg =>
      const TextSize(fontSize: 48, lineHeight: 60, letterSpacing: 0.03);
  TextSize get md =>
      const TextSize(fontSize: 36, lineHeight: 44, letterSpacing: 0.03);
  TextSize get sm =>
      const TextSize(fontSize: 30, lineHeight: 38, letterSpacing: 0.03);
  TextSize get xs =>
      const TextSize(fontSize: 24, lineHeight: 32, letterSpacing: 0.03);
}

class _Text {
  const _Text();

  TextSize get xl =>
      const TextSize(fontSize: 20, lineHeight: 30, letterSpacing: 0.03);
  TextSize get lg =>
      const TextSize(fontSize: 18, lineHeight: 28, letterSpacing: 0.03);
  TextSize get md =>
      const TextSize(fontSize: 16, lineHeight: 24, letterSpacing: 0.03);
  TextSize get sm =>
      const TextSize(fontSize: 14, lineHeight: 20, letterSpacing: 0.03);
  TextSize get xs =>
      const TextSize(fontSize: 12, lineHeight: 12, letterSpacing: 0.03);
}

class TextSize {
  const TextSize({
    required this.fontSize,
    required this.lineHeight,
    required this.letterSpacing,
  });
  final double fontSize;
  final double lineHeight;
  final double letterSpacing;

  TextStyle get regular => _baseStyle(FontWeight.w400);
  TextStyle get medium => _baseStyle(FontWeight.w500);
  TextStyle get semibold => _baseStyle(FontWeight.w600);
  TextStyle get bold => _baseStyle(FontWeight.w700);

  TextStyle _baseStyle(FontWeight weight) => TextStyle(
    fontSize: fontSize.sp,
    fontWeight: weight,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    height: lineHeight / fontSize,
    letterSpacing: fontSize * letterSpacing,
    fontFamily: defaultFontFamily,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
  );
}
