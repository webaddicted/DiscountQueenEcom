import 'package:flutter/material.dart';

class ColorUtils {
  ColorUtils._();

  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static Color withOpacity(Color color, double opacity) =>
      color.withOpacity(opacity);

  static Color fromHex(String hex) {
    hex = hex.replaceAll('#', '').replaceAll('0x', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  static String toHex(Color color, {bool withHash = true}) {
    final hex =
        color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    return withHash ? '#$hex' : hex;
  }
}
