import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/onboarding/controller/onboarding_controller.dart';
import 'package:portfolio/features/onboarding/presentation/widgets/onboarding_center_logo.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';

class OnboardingPage extends BaseStatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Scaffold(
      backgroundColor: ColorConst.white,
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: OnboardingController.totalPages,
              itemBuilder: (context, index) => const OnboardingCenterLogo(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Obx(() {
                  final item = controller.pages[controller.currentPage.value];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.headlineLarge.copyWith(
                          color: ColorConst.colorFF1F2937,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: ColorConst.colorFF6B7280,
                          height: 1.5,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        OnboardingController.totalPages,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? ColorConst.primaryColor
                                : ColorConst.colorFFD1D5DB,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GradientButton(
                    onTap: controller.nextPage,
                    height: 52,
                    borderRadius: 28,
                    child: Text(
                      StringConst.getStarted,
                      style: AppTextStyle.buttonText.copyWith(
                        color: ColorConst.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
