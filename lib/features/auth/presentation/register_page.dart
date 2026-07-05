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
import 'package:portfolio/global/widgets/responsive_layout.dart';

class RegisterPage extends BaseStatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.put(AuthController());
    return Scaffold(
      appBar: ResponsiveLayout.isMobile(context)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: ColorConst.primaryColor),
                onPressed: () => Get.back(),
              ),
            )
          : null,
      body: ResponsiveLayout(
        mobile: (_) => _buildMobileLayout(context, controller),
        tablet: (_) => _buildDesktopLayout(context, controller),
        desktop: (_) => _buildDesktopLayout(context, controller),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AuthController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMobileHeader(context),
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacing16),
            child: _buildRegisterForm(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AuthController controller) {
    return Row(
      children: [
        Expanded(child: _buildBrandingPanel(context)),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(DesignTokens.spacing32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      StringConst.createAccount,
                      style: AppTextStyle.headlineLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing4),
                    Text(
                      'Join us today! Please enter your details.',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: ColorConst.colorFF6B7280,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing24),
                    _buildRegisterForm(controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandingPanel(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: DesignTokens.primaryGradient),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacing32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.child_care, size: 96, color: ColorConst.white),
              const SizedBox(height: DesignTokens.spacing16),
              Text(
                AppConstant.appName,
                style: AppTextStyle.displayMedium.copyWith(
                  color: ColorConst.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing8),
              Text(
                AppConstant.appTagline,
                style: AppTextStyle.headlineSmall.copyWith(
                  color: ColorConst.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: DesignTokens.spacing16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Text(
                  AppConstant.appDescription,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyLarge.copyWith(
                    color: ColorConst.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm(AuthController controller) {
    return Form(
      key: controller.registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: StringConst.fullName,
            hint: StringConst.enterName,
            controller: controller.nameController,
            validator: controller.validateName,
            prefixIcon: const Icon(
              Icons.person_outline,
              size: 20,
              color: ColorConst.primaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing12),
          CustomTextField(
            label: StringConst.email,
            hint: StringConst.enterEmail,
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
            prefixIcon: const Icon(
              Icons.email_outlined,
              size: 20,
              color: ColorConst.primaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing12),
          CustomTextField(
            label: StringConst.phone,
            hint: StringConst.enterPhone,
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            validator: controller.validatePhone,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              size: 20,
              color: ColorConst.primaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing12),
          Obx(
            () => CustomTextField(
              label: StringConst.password,
              hint: StringConst.enterPassword,
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              validator: controller.validatePassword,
              prefixIcon: const Icon(
                Icons.lock_outline,
                size: 20,
                color: ColorConst.primaryColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 20,
                  color: ColorConst.primaryColor,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacing12),
          Obx(
            () => CustomTextField(
              label: StringConst.confirmPassword,
              hint: StringConst.enterPassword,
              controller: controller.confirmPasswordController,
              obscureText: !controller.isConfirmPasswordVisible.value,
              validator: controller.validateConfirmPassword,
              prefixIcon: const Icon(
                Icons.lock_outline,
                size: 20,
                color: ColorConst.primaryColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isConfirmPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 20,
                  color: ColorConst.primaryColor,
                ),
                onPressed: controller.toggleConfirmPasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacing8),
          Obx(
            () => Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: controller.termsAccepted.value,
                    onChanged: (v) =>
                        controller.termsAccepted.value = v ?? false,
                    activeColor: ColorConst.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radius4),
                    ),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacing8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.termsAccepted.value =
                        !controller.termsAccepted.value,
                    child: Text(
                      StringConst.termsAgree,
                      style: AppTextStyle.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.spacing16),
          GradientButton(
            onTap: controller.register,
            isLoading: controller.isLoading,
            child: Text(
              StringConst.register,
              style: AppTextStyle.buttonText.copyWith(
                color: ColorConst.white,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                StringConst.alreadyHaveAccount,
                style: AppTextStyle.bodyMedium,
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  StringConst.login,
                  style: AppTextStyle.labelLarge.copyWith(
                    color: ColorConst.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing16),
          Text(
            StringConst.orContinueWith,
            textAlign: TextAlign.center,
            style: AppTextStyle.caption,
          ),
          const SizedBox(height: DesignTokens.spacing8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialButton(icon: Icons.g_mobiledata, onTap: () {}),
              const SizedBox(width: DesignTokens.spacing12),
              _SocialButton(icon: Icons.apple, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.spacing16,
        DesignTokens.spacing48,
        DesignTokens.spacing16,
        DesignTokens.spacing24,
      ),
      decoration: const BoxDecoration(gradient: DesignTokens.primaryGradient),
      child: Column(
        children: [
          const Icon(Icons.child_care, size: 64, color: ColorConst.white),
          const SizedBox(height: DesignTokens.spacing8),
          Text(
            AppConstant.appName,
            style: AppTextStyle.headlineLarge.copyWith(
              color: ColorConst.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            StringConst.createAccount,
            style: AppTextStyle.bodyMedium.copyWith(
              color: ColorConst.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing24,
          vertical: DesignTokens.spacing12,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: ColorConst.primaryColor),
          borderRadius: BorderRadius.circular(DesignTokens.radius8),
        ),
        child: Icon(icon, size: 28, color: ColorConst.primaryColor),
      ),
    );
  }
}
