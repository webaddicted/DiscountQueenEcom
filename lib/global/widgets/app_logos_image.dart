import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/assets_const.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/widgets/smart_image.dart';

class AppLogosImage extends StatelessWidget {
  final double size;
  final bool showCircleBackground;

  const AppLogosImage({
    super.key,
    required this.size,
    this.showCircleBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showCircleBackground) {
      return SmartImage(
        source: AssetsConst.logosImg,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ColorConst.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorConst.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: const ClipOval(
        child: SmartImage(
          source: AssetsConst.logosImg,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
