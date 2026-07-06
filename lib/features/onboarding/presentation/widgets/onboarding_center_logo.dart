import 'package:flutter/material.dart';
import 'package:portfolio/features/onboarding/presentation/widgets/onboarding_curve_clipper.dart';
import 'package:portfolio/global/constant/assets_const.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/widgets/smart_image.dart';

class OnboardingCenterLogo extends StatelessWidget {
  const OnboardingCenterLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: OnboardingCurveClipper(),
      child: ColoredBox(
        color: ColorConst.primaryColor,
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: ColorConst.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorConst.black.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: const ClipOval(
              child: SmartImage(
                source: AssetsConst.logosImg,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
