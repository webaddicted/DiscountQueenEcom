import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/theme/text_style.dart';

class DesignTokens {
  DesignTokens._();

  // Spacing (8px grid)
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing6 = 6;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing64 = 64;

  // Border radius
  static const double radius4 = 4;
  static const double radius8 = 8;
  static const double radius12 = 12;
  static const double radius16 = 16;
  static const double radius20 = 20;
  static const double radius24 = 24;
  static const double radius32 = 32;
  static const double radiusCircular = 100;

  // Elevation
  static const double elevationNone = 0;
  static const double elevationSmall = 2;
  static const double elevationMedium = 4;
  static const double elevationLarge = 8;

  // Shadows
  static List<BoxShadow> get shadowSmall => [
        BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2)),
      ];
  static List<BoxShadow> get shadowMedium => [
        BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4)),
      ];
  static List<BoxShadow> get shadowLarge => [
        BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8)),
      ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

TextTheme _buildAppTextTheme() {
  return TextTheme(
    displayLarge: AppTextStyle.displayLarge,
    displayMedium: AppTextStyle.displayMedium,
    displaySmall: AppTextStyle.displaySmall,
    headlineLarge: AppTextStyle.headlineLarge,
    headlineMedium: AppTextStyle.headlineMedium,
    headlineSmall: AppTextStyle.headlineSmall,
    titleLarge: AppTextStyle.titleLarge,
    titleMedium: AppTextStyle.titleMedium,
    titleSmall: AppTextStyle.titleSmall,
    bodyLarge: AppTextStyle.bodyLarge,
    bodyMedium: AppTextStyle.bodyMedium,
    bodySmall: AppTextStyle.bodySmall,
    labelLarge: AppTextStyle.labelLarge,
    labelMedium: AppTextStyle.labelMedium,
    labelSmall: AppTextStyle.labelSmall,
  );
}

ThemeData lightThemeData(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: ColorConst.primaryColor,
    scaffoldBackgroundColor: LightColors.scaffoldBgColor,
    canvasColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: _buildAppTextTheme(),
    colorScheme: const ColorScheme.light(
      primary: ColorConst.primaryColor,
      secondary: ColorConst.secondaryColor,
      surface: ColorConst.colorFFFFFFFF,
      error: ColorConst.colorFFE53935,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: ColorConst.colorFF000000,
      titleTextStyle: AppTextStyle.titleMedium.copyWith(
        color: ColorConst.colorFF000000,
      ),
      iconTheme: const IconThemeData(color: ColorConst.colorFF000000),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius16)),
      color: ColorConst.colorFFFFFFFF,
      shadowColor: Colors.black.withValues(alpha: 0.08),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: ColorConst.primaryColor,
        foregroundColor: ColorConst.colorFFFFFFFF,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radius12)),
        padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing24,
            vertical: DesignTokens.spacing16),
        textStyle: AppTextStyle.buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConst.primaryColor,
        side: const BorderSide(color: ColorConst.primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radius12)),
        padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing24,
            vertical: DesignTokens.spacing16),
        textStyle: AppTextStyle.buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorConst.primaryColor,
        textStyle: AppTextStyle.buttonText,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing16,
          vertical: DesignTokens.spacing16),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        borderSide: const BorderSide(color: ColorConst.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      hintStyle: AppTextStyle.inputHint.copyWith(color: Colors.grey.shade500),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      labelStyle: AppTextStyle.labelLarge,
      unselectedLabelStyle: AppTextStyle.labelMedium,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2, color: ColorConst.primaryColor),
      ),
    ),
    dividerTheme:
        DividerThemeData(color: Colors.grey.shade200, thickness: 1),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: ColorConst.primaryColor,
    scaffoldBackgroundColor: DarkColors.scaffoldBgColor,
    canvasColor: DarkColors.sheetBgColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: _buildAppTextTheme(),
    colorScheme: const ColorScheme.dark(
      primary: ColorConst.primaryColor,
      secondary: ColorConst.secondaryColor,
      surface: DarkColors.sheetBgColor,
      error: ColorConst.colorFFE94560,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: ColorConst.colorFFFFFFFF,
      titleTextStyle: AppTextStyle.titleMedium.copyWith(
        color: ColorConst.colorFFFFFFFF,
      ),
      iconTheme: const IconThemeData(color: ColorConst.colorFFFFFFFF),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius16)),
      color: DarkColors.sheetBgColor,
      shadowColor: Colors.black.withValues(alpha: 0.3),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: ColorConst.primaryColor,
        foregroundColor: ColorConst.colorFFFFFFFF,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radius12)),
        padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing24,
            vertical: DesignTokens.spacing16),
        textStyle: AppTextStyle.buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConst.primaryColor,
        side: const BorderSide(color: ColorConst.primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radius12)),
        padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing24,
            vertical: DesignTokens.spacing16),
        textStyle: AppTextStyle.buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorConst.primaryColor,
        textStyle: AppTextStyle.buttonText,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DarkColors.sheetBgColor,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing16,
          vertical: DesignTokens.spacing16),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        borderSide: const BorderSide(color: ColorConst.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      hintStyle: AppTextStyle.inputHint.copyWith(color: Colors.grey.shade400),
    ),
    tabBarTheme: TabBarThemeData(
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey.shade400,
      labelStyle: AppTextStyle.labelLarge,
      unselectedLabelStyle: AppTextStyle.labelMedium,
    ),
    dividerTheme:
        DividerThemeData(color: Colors.grey.shade800, thickness: 1),
  );
}

class DarkColors {
  static const scaffoldBgColor = Color(0xFF1A1A1A);
  static const sheetBgColor = Color(0xFF2A2A2A);
  static const btnBgColor = Color(0xFF3A3A3A);
}

class LightColors {
  static const scaffoldBgColor = Color(0xFFFAFBFC);
  static const sheetBgColor = Color(0xFFF9F9F9);
  static const btnBgColor = Color(0xFFF5F5F5);
}
