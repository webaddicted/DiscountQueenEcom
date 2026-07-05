import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/onboarding/controller/onboarding_controller.dart';
import 'package:portfolio/features/onboarding/presentation/widgets/onboarding_center_logo.dart';
import 'package:portfolio/features/onboarding/presentation/widgets/onboarding_logo_header.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingLogoHeader(),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: OnboardingController.totalPages,
                itemBuilder: (context, index) {
                  final item = controller.pages[index];
                  return _OnboardingSlide(item: item);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
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
                                ? ColorConst.colorFF3B82F6
                                : ColorConst.colorFFD1D5DB,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConst.colorFFFF9100.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: GradientButton(
                      onTap: controller.nextPage,
                      height: 52,
                      borderRadius: 28,
                      colors: const [
                        ColorConst.colorFFFF9100,
                        ColorConst.colorFFFF9800,
                      ],
                      child: Text(
                        StringConst.getStarted,
                        style: AppTextStyle.buttonText.copyWith(
                          color: ColorConst.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final OnboardingItem item;

  const _OnboardingSlide({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          flex: 3,
          child: OnboardingCenterLogo(),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.headlineMedium.copyWith(
                    color: ColorConst.colorFF1F2937,
                    fontWeight: FontWeight.w700,
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
            ),
          ),
        ),
      ],
    );
  }

}
