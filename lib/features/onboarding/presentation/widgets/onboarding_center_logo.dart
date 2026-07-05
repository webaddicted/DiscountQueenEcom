import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/assets_const.dart';
import 'package:portfolio/global/widgets/smart_image.dart';

class OnboardingCenterLogo extends StatelessWidget {
  const OnboardingCenterLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SmartImage.rounded(
        source: AssetsConst.logoImg,
        width: 160,
        height: 160,
        borderRadius: 24,
      ),
    );
  }
}
