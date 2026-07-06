import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/theme/text_style.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final double blurSigma;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final Border? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = 12,
    this.blurSigma = 10,
    this.backgroundColor,
    this.gradientColors,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withValues(alpha: 0.1),
            gradient: gradientColors != null
                ? LinearGradient(colors: gradientColors!)
                : null,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ??
                Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final double borderRadius;
  final Color? iconColor;
  final double blurSigma;

  const GlassButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.iconSize = 20,
    this.borderRadius = 20,
    this.iconColor,
    this.blurSigma = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: EdgeInsets.all((size - iconSize) / 2),
        borderRadius: borderRadius,
        blurSigma: blurSigma,
        child:
            Icon(icon, size: iconSize, color: iconColor ?? Colors.white),
      ),
    );
  }
}

class GlassPaddedButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final double iconSize;
  final Color? iconColor;

  const GlassPaddedButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.padding = const EdgeInsets.all(8),
    this.iconSize = 20,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: padding,
        borderRadius: 12,
        child:
            Icon(icon, size: iconSize, color: iconColor ?? Colors.white),
      ),
    );
  }
}

class DarkGradientBackground extends StatelessWidget {
  final Widget child;
  final Color? primaryColor;
  final Color? secondaryColor;

  const DarkGradientBackground({
    super.key,
    required this.child,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor ?? ColorConst.colorFF0F172A,
            secondaryColor ?? ColorConst.colorFF1E293B,
          ],
        ),
      ),
      child: child,
    );
  }
}

class GradientScreenBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientScreenBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ??
              [ColorConst.primaryColor, ColorConst.secondaryColor],
        ),
      ),
      child: child,
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;

  const InfoChip({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: iconColor ?? Colors.white70),
        const SizedBox(width: 4),
        Text(text,
            style: AppTextStyle.labelLarge.copyWith(
                color: textColor ?? Colors.white70)),
      ]),
    );
  }
}

class BottomGradientContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final List<Color>? gradientColors;

  const BottomGradientContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(8),
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors ??
              [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
        ),
      ),
      child: child,
    );
  }
}
