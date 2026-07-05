import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';

class SplashPage extends BaseStatelessWidget {
  const SplashPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    _scheduleNavigation();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorConst.primaryColor,
              ColorConst.secondaryColor,
              ColorConst.colorFF1A1A2E,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: const Icon(
                    Icons.child_care,
                    size: 80,
                    color: ColorConst.white,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing16),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        ColorConst.white,
                        ColorConst.colorFF22D3EE,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      AppConstant.appName,
                      style: AppTextStyle.displayMedium.copyWith(
                        color: ColorConst.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: Text(
                    AppConstant.appTagline,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: ColorConst.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _scheduleNavigation() {
    Timer(const Duration(seconds: 2), () {
      if (SPManager.isOnboardingShown()) {
        if (SPManager.isLoggedIn()) {
          Get.offAllNamed(RoutersConst.home);
        } else {
          Get.offAllNamed(RoutersConst.login);
        }
      } else {
        Get.offAllNamed(RoutersConst.onboarding);
      }
    });
  }
}
