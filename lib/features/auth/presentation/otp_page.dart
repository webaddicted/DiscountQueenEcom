import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/auth/controller/auth_controller.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/custom_text_field.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';

class OtpPage extends BaseStatelessWidget {
  const OtpPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConst.verifyOtp,
          style: AppTextStyle.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing16),
        child: Form(
          key: controller.otpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                StringConst.enterOtp,
                style: AppTextStyle.bodyMedium.copyWith(
                  color: ColorConst.colorFF6B7280,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing4),
              Obx(
                () => Text(
                  controller.otpEmail.value,
                  style: AppTextStyle.titleMedium.copyWith(
                    color: ColorConst.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.spacing16),
              Obx(() {
                if (!controller.isErrorRx.value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.spacing8),
                  child: Text(
                    controller.errorMessageRx.value,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: ColorConst.colorFFDC2626,
                      fontSize: 14,
                    ),
                  ),
                );
              }),
              CustomTextField(
                label: StringConst.verifyOtp,
                hint: 'Enter ${AppConstant.otpLength}-digit OTP',
                controller: controller.otpController,
                keyboardType: TextInputType.number,
                maxLength: AppConstant.otpLength,
                validator: controller.validateOtp,
                prefixIcon: const Icon(
                  Icons.pin_outlined,
                  size: 20,
                  color: ColorConst.primaryColor,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing16),
              Obx(
                () => GradientButton(
                  onTap: controller.verifyOtp,
                  isLoading: controller.isLoading,
                  enabled: controller.canSubmitOtp.value,
                  child: Text(
                    StringConst.verifyOtp,
                    style: AppTextStyle.buttonText.copyWith(
                      color: ColorConst.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.spacing8),
              Obx(
                () => TextButton(
                  onPressed: controller.otpCountdown.value > 0
                      ? null
                      : controller.resendOtp,
                  child: Text(
                    controller.otpCountdown.value > 0
                        ? '${StringConst.resendOtp} (${controller.otpCountdown.value}s)'
                        : StringConst.resendOtp,
                    style: AppTextStyle.labelMedium.copyWith(
                      color: ColorConst.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
