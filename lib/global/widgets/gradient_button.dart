import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/color_const.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final List<Color>? colors;
  final double height;
  final double borderRadius;
  final bool isLoading;
  final bool enabled;
  final EdgeInsets padding;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.child,
    this.colors,
    this.height = 48,
    this.borderRadius = 8,
    this.isLoading = false,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  Widget build(BuildContext context) {
    final activeColors = colors ??
        [ColorConst.primaryColor, ColorConst.secondaryColor];
    final canTap = enabled && !isLoading && onTap != null;

    return GestureDetector(
      onTap: canTap ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1 : 0.45,
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: enabled
                  ? activeColors
                  : [
                      ColorConst.colorFF9CA3AF,
                      ColorConst.colorFF6B7280,
                    ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}
