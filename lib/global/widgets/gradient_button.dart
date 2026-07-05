import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/color_const.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final List<Color>? colors;
  final double height;
  final double borderRadius;
  final bool isLoading;
  final EdgeInsets padding;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.child,
    this.colors,
    this.height = 48,
    this.borderRadius = 8,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: colors ??
                  [ColorConst.primaryColor, ColorConst.secondaryColor]),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : child),
      ),
    );
  }
}
