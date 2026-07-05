import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/theme/text_style.dart';

class OnboardingLogoHeader extends StatelessWidget {
  const OnboardingLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        AppConstant.appName,
        style: AppTextStyle.titleMedium.copyWith(
          color: ColorConst.colorFF1F2937,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
