import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  AppTextStyle._();

  static double get fontSize8 => kIsWeb ? 10 : 8;
  static double get fontSize10 => kIsWeb ? 12 : 10;
  static double get fontSize12 => kIsWeb ? 14 : 12;
  static double get fontSize14 => kIsWeb ? 16 : 14;
  static double get fontSize16 => kIsWeb ? 18 : 16;
  static double get fontSize18 => kIsWeb ? 20 : 18;
  static double get fontSize20 => kIsWeb ? 22 : 20;
  static double get fontSize24 => kIsWeb ? 26 : 24;
  static double get fontSize28 => kIsWeb ? 30 : 28;
  static double get fontSize32 => kIsWeb ? 34 : 32;
  static double get fontSize36 => kIsWeb ? 38 : 36;
  static double get fontSize48 => kIsWeb ? 50 : 48;

  // Display Styles
  static TextStyle get displayLarge => TextStyle(fontSize: fontSize48, fontWeight: FontWeight.w700, letterSpacing: -0.5, height: 1.1);
  static TextStyle get displayMedium => TextStyle(fontSize: fontSize36, fontWeight: FontWeight.w600, letterSpacing: -0.25, height: 1.2);
  static TextStyle get displaySmall => TextStyle(fontSize: fontSize28, fontWeight: FontWeight.w600, letterSpacing: 0, height: 1.3);

  // Headline Styles
  static TextStyle get headlineLarge => TextStyle(fontSize: fontSize24, fontWeight: FontWeight.w600, letterSpacing: 0, height: 1.3);
  static TextStyle get headlineMedium => TextStyle(fontSize: fontSize20, fontWeight: FontWeight.w600, letterSpacing: 0.15, height: 1.4);
  static TextStyle get headlineSmall => TextStyle(fontSize: fontSize18, fontWeight: FontWeight.w600, letterSpacing: 0.15, height: 1.4);

  // Title Styles
  static TextStyle get titleLarge => TextStyle(fontSize: fontSize20, fontWeight: FontWeight.w600, letterSpacing: 0.15, height: 1.5);
  static TextStyle get titleMedium => TextStyle(fontSize: fontSize16, fontWeight: FontWeight.w600, letterSpacing: 0.1, height: 1.4);
  static TextStyle get titleSmall => TextStyle(fontSize: fontSize14, fontWeight: FontWeight.w600, letterSpacing: 0.1, height: 1.4);

  // Body Styles
  static TextStyle get bodyLarge => TextStyle(fontSize: fontSize16, fontWeight: FontWeight.normal, letterSpacing: 0.5, height: 1.5);
  static TextStyle get bodyMedium => TextStyle(fontSize: fontSize14, fontWeight: FontWeight.normal, letterSpacing: 0.25, height: 1.4);
  static TextStyle get bodySmall => TextStyle(fontSize: fontSize12, fontWeight: FontWeight.normal, letterSpacing: 0.4, height: 1.3);

  // Label Styles
  static TextStyle get labelLarge => TextStyle(fontSize: fontSize14, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.4);
  static TextStyle get labelMedium => TextStyle(fontSize: fontSize12, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.3);
  static TextStyle get labelSmall => TextStyle(fontSize: fontSize10, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.2);

  // Semantic styles
  static TextStyle get caption => TextStyle(fontSize: fontSize10, color: Colors.grey, letterSpacing: 0.4, height: 1.2);
  static TextStyle get overline => TextStyle(fontSize: fontSize8, letterSpacing: 1.5, fontWeight: FontWeight.w500, height: 1.0);

  // Button Text
  static TextStyle get buttonText => TextStyle(fontSize: fontSize14, fontWeight: FontWeight.w600, letterSpacing: 0.1, height: 1.4);

  // Card Styles
  static TextStyle get cardTitle => TextStyle(fontSize: fontSize16, fontWeight: FontWeight.w600, letterSpacing: 0.15, height: 1.4);
  static TextStyle get cardSubtitle => TextStyle(fontSize: fontSize12, fontWeight: FontWeight.w400, color: Colors.grey, letterSpacing: 0.4, height: 1.3);

  // Navigation Styles
  static TextStyle get navTitle => TextStyle(fontSize: fontSize18, fontWeight: FontWeight.w600, letterSpacing: 0.15, height: 1.3);
  static TextStyle get navSubtitle => TextStyle(fontSize: fontSize12, fontWeight: FontWeight.w400, color: Colors.grey, letterSpacing: 0.4, height: 1.3);

  // Form Styles
  static TextStyle get inputLabel => TextStyle(fontSize: fontSize14, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.4);
  static TextStyle get inputHint => TextStyle(fontSize: fontSize14, color: Colors.grey, letterSpacing: 0.25, height: 1.4);
  static TextStyle get inputText => TextStyle(fontSize: fontSize14, letterSpacing: 0.25, height: 1.4);

  // Status Styles
  static TextStyle get errorText => TextStyle(fontSize: fontSize12, color: Colors.red, fontWeight: FontWeight.w500, letterSpacing: 0.4, height: 1.3);
  static TextStyle get successText => TextStyle(fontSize: fontSize12, color: Colors.green, fontWeight: FontWeight.w500, letterSpacing: 0.4, height: 1.3);
  static TextStyle get warningText => TextStyle(fontSize: fontSize12, color: Colors.orange, fontWeight: FontWeight.w500, letterSpacing: 0.4, height: 1.3);
}
