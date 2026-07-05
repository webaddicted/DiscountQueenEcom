import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/sp/sp_manager.dart';

class OnboardingController extends BaseController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  static const int totalPages = 3;

  final List<OnboardingItem> pages = const [
    OnboardingItem(
      title: StringConst.onboardingTitle1,
      description: StringConst.onboardingDesc1,
    ),
    OnboardingItem(
      title: StringConst.onboardingTitle2,
      description: StringConst.onboardingDesc2,
    ),
    OnboardingItem(
      title: StringConst.onboardingTitle3,
      description: StringConst.onboardingDesc3,
    ),
  ];

  @override
  void onControllerClose() {
    pageController.dispose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    await SPManager.setOnboardingShown(true);
    offAllNamed(RoutersConst.login);
  }
}

class OnboardingItem {
  final String title;
  final String description;

  const OnboardingItem({
    required this.title,
    required this.description,
  });
}
