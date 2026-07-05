import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';

/// Shared visual tokens for admin surfaces — calm, minimal, readable.
abstract final class AdminTheme {
  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? ColorConst.colorFF1E293B
          : const Color(0xFFF4F6F8);

  static BoxDecoration cardDecoration(BuildContext context) => BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.radius16),
        boxShadow: DesignTokens.shadowSmall,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.08),
        ),
      );

  static Widget card({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radius16),
        boxShadow: DesignTokens.shadowSmall,
      ),
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.08),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: padding != null ? Padding(padding: padding, child: child) : child,
      ),
    );
  }

  static LinearGradient softAccentGradient({bool mint = true}) => LinearGradient(
        colors: mint
            ? const [Color(0xFFE0F7F4), Color(0xFFF0FDFA)]
            : const [Color(0xFFFFE4E6), Color(0xFFFFF1F2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static const Color accentMint = Color(0xFF0D9488);
  static const Color accentRose = Color(0xFFE11D48);
}
