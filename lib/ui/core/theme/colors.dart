import 'package:flutter/widgets.dart';

enum ColorShade {
  w0,
  w50,
  w100,
  w150,
  w200,
  w250,
  w300,
  w350,
  w400,
  w450,
  w500,
  w550,
  w600,
  w650,
  w700,
  w750,
  w800,
  w850,
  w900,
  w950,
  w1000,
}

class ThemeColor extends ColorSwatch<ColorShade> {
  const ThemeColor(super.primary, super._swatch);

  Color get shade0 => this[ColorShade.w0]!;
  Color get shade100 => this[ColorShade.w100]!;
  Color get shade200 => this[ColorShade.w200]!;
  Color get shade300 => this[ColorShade.w300]!;
  Color get shade400 => this[ColorShade.w400] ?? this;
  Color get shade700 => this[ColorShade.w700] ?? this;
  Color get shade600 => this[ColorShade.w600] ?? this;
  Color get shade900 => this[ColorShade.w900] ?? this;
}

class AppColors {
  static const ThemeColor neutrals = ThemeColor(0xFFFFFFFE, {
    ColorShade.w0: Color(0xFFFFFFFE),
    ColorShade.w50: Color(0xFFF2F2F2),
    ColorShade.w100: Color(0xFFE5E5E5),
    ColorShade.w150: Color(0xFFD9D9D9),
    ColorShade.w200: Color(0xFFCCCCCC),
    ColorShade.w250: Color(0xFFBFBFBF),
    ColorShade.w300: Color(0xFFB3B3B3),
    ColorShade.w350: Color(0xFFA6A6A6),
    ColorShade.w400: Color(0xFF999999),
    ColorShade.w450: Color(0xFF8C8C8C),
    ColorShade.w500: Color(0xFF808080),
    ColorShade.w550: Color(0xFF737373),
    ColorShade.w600: Color(0xFF666666),
    ColorShade.w650: Color(0xFF595959),
    ColorShade.w700: Color(0xFF4C4C4C),
    ColorShade.w750: Color(0xFF404040),
    ColorShade.w800: Color(0xFF333333),
    ColorShade.w850: Color(0xFF262626),
    ColorShade.w900: Color(0xFF1A1A1A),
    ColorShade.w950: Color(0xFF0D0D0D),
    ColorShade.w1000: Color(0xFF000000),
  });

  static const ThemeColor green = ThemeColor(0xFF2E4D44, {
    ColorShade.w0: Color(0xFFD5F8EC),
    ColorShade.w100: Color(0xFFC7EADE),
    ColorShade.w200: Color(0xFFACCEC2),
    ColorShade.w300: Color(0xFF91B2A7),
    ColorShade.w400: Color(0xFF77988D),
    ColorShade.w500: Color(0xFF5E7E73),
    ColorShade.w600: Color(0xFF45655B),
    ColorShade.w700: Color(0xFF2E4D44),
    ColorShade.w800: Color(0xFF16362E),
    ColorShade.w900: Color(0xFF002019),
  });

  static const ThemeColor secondary = ThemeColor(0xFF5C6B80, {
    ColorShade.w0: Color(0xFFEAF1FF),
    ColorShade.w100: Color(0xFFD4E4FC),
    ColorShade.w200: Color(0xFFB8C8DF),
    ColorShade.w300: Color(0xFF9DACC3),
    ColorShade.w400: Color(0xFF8392A8),
    ColorShade.w500: Color(0xFF69788E),
    ColorShade.w600: Color(0xFF515F74),
    ColorShade.w700: Color(0xFF39485B),
    ColorShade.w800: Color(0xFF223144),
    ColorShade.w900: Color(0xFF0D1C2E),
  });

  static const ThemeColor error = ThemeColor(0xFFE61A1A, {
    ColorShade.w0: Color(0xFFFCE8E8),
    ColorShade.w50: Color(0xFFFAD1D1),
    ColorShade.w100: Color(0xFFF7BABA),
    ColorShade.w150: Color(0xFFF5A3A3),
    ColorShade.w200: Color(0xFFF07676),
    ColorShade.w250: Color(0xFFEB4848),
    ColorShade.w300: Color(0xFFE61A1A),
  });

  static const ThemeColor success = ThemeColor(0xFF008751, {
    ColorShade.w0: Color(0xFFB0FFDF),
    ColorShade.w50: Color(0xFF9EF3D1),
    ColorShade.w100: Color(0xFF8DE7C3),
    ColorShade.w150: Color(0xFF7BDBB4),
    ColorShade.w200: Color(0xFF6ACFA6),
    ColorShade.w250: Color(0xFF46B78A),
    ColorShade.w300: Color(0xFF239F6D),
    ColorShade.w350: Color(0xFF008751),
  });

  static const ThemeColor coralRed = ThemeColor(0xFFF87171, {
    ColorShade.w0: Color(0xFFFEF1F1),
    ColorShade.w50: Color(0xFFFEE3E3),
    ColorShade.w100: Color(0xFFFDD4D4),
    ColorShade.w150: Color(0xFFFCC6C6),
    ColorShade.w200: Color(0xFFFBAAAA),
    ColorShade.w250: Color(0xFFF98D8D),
    ColorShade.w300: Color(0xFFF87171),
  });
}
