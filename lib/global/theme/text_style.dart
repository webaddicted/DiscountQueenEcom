import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/assets_const.dart';

class AppTextStyle {
  AppTextStyle._();

  static const TextStyle _base = TextStyle(
    fontFamily: AssetsConst.primaryFontNunito,
  );

  // Standard typography scale (14px base for body/UI text)
  static const double fontSize8 = 8;
  static const double fontSize10 = 10;
  static const double fontSize12 = 12;
  static const double fontSize14 = 14;
  static const double fontSize16 = 16;
  static const double fontSize18 = 18;
  static const double fontSize20 = 20;
  static const double fontSize24 = 24;
  static const double fontSize28 = 28;
  static const double fontSize32 = 32;

  // Display Styles — hero / splash only
  static TextStyle get displayLarge => _base.copyWith(
        fontSize: fontSize32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.1,
      );
  static TextStyle get displayMedium => _base.copyWith(
        fontSize: fontSize24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.2,
      );
  static TextStyle get displaySmall => _base.copyWith(
        fontSize: fontSize20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.3,
      );

  // Headline Styles — page / section headers
  static TextStyle get headlineLarge => _base.copyWith(
        fontSize: fontSize18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.3,
      );
  static TextStyle get headlineMedium => _base.copyWith(
        fontSize: fontSize16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.4,
      );
  static TextStyle get headlineSmall => _base.copyWith(
        fontSize: fontSize14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.4,
      );

  // Title Styles
  static TextStyle get titleLarge => _base.copyWith(
        fontSize: fontSize16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.5,
      );
  static TextStyle get titleMedium => _base.copyWith(
        fontSize: fontSize14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
      );
  static TextStyle get titleSmall => _base.copyWith(
        fontSize: fontSize12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
      );


  // Body Styles
  static TextStyle get bodyLarge => _base.copyWith(
        fontSize: fontSize14,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.25,
        height: 1.5,
      );
  static TextStyle get bodyMedium => _base.copyWith(
        fontSize: fontSize14,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.25,
        height: 1.4,
      );
  static TextStyle get bodySmall => _base.copyWith(
        fontSize: fontSize12,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.4,
        height: 1.3,
      );

  // Label Styles
  static TextStyle get labelLarge => _base.copyWith(
        fontSize: fontSize12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
      );
  static TextStyle get labelMedium => _base.copyWith(
        fontSize: fontSize10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.3,
      );
  static TextStyle get labelSmall => _base.copyWith(
        fontSize: fontSize10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.2,
      );

  // Semantic styles
  static TextStyle get caption => _base.copyWith(
        fontSize: fontSize10,
        color: Colors.grey,
        letterSpacing: 0.4,
        height: 1.2,
      );
  static TextStyle get overline => _base.copyWith(
        fontSize: fontSize8,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w500,
        height: 1.0,
      );

  // Button Text
  static TextStyle get buttonText => _base.copyWith(
        fontSize: fontSize14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
      );

  // Card Styles
  static TextStyle get cardTitle => _base.copyWith(
        fontSize: fontSize14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.4,
      );
  static TextStyle get cardSubtitle => _base.copyWith(
        fontSize: fontSize12,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
        letterSpacing: 0.4,
        height: 1.3,
      );

  // Navigation Styles
  static TextStyle get navTitle => _base.copyWith(
        fontSize: fontSize14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.3,
      );
  static TextStyle get navSubtitle => _base.copyWith(
        fontSize: fontSize12,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
        letterSpacing: 0.4,
        height: 1.3,
      );

  // Form Styles
  static TextStyle get inputLabel12 => _base.copyWith(
        fontSize: fontSize12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
      );
  static TextStyle get inputHint12 => _base.copyWith(
        fontSize: fontSize12,
        color: Colors.grey,
        letterSpacing: 0.25,
        height: 1.4,
      );
  static TextStyle get inputText12 => _base.copyWith(
        fontSize: fontSize12,
        letterSpacing: 0.25,
        height: 1.4,
      );
  static TextStyle get inputLabel => _base.copyWith(
        fontSize: fontSize14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
      );
  static TextStyle get inputHint => _base.copyWith(
        fontSize: fontSize14,
        color: Colors.grey,
        letterSpacing: 0.25,
        height: 1.4,
      );
  static TextStyle get inputText => _base.copyWith(
        fontSize: fontSize14,
        letterSpacing: 0.25,
        height: 1.4,
      );

  // Status Styles
  static TextStyle get errorText => _base.copyWith(
        fontSize: fontSize12,
        color: Colors.red,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        height: 1.3,
      );
  static TextStyle get successText => _base.copyWith(
        fontSize: fontSize12,
        color: Colors.green,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        height: 1.3,
      );
  static TextStyle get warningText => _base.copyWith(
        fontSize: fontSize12,
        color: Colors.orange,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        height: 1.3,
      );
}
