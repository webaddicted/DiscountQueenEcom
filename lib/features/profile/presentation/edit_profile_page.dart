import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:portfolio/features/profile/controller/profile_controller.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';
import 'package:portfolio/global/widgets/custom_text_field.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';
import 'package:portfolio/global/widgets/smart_image.dart';

class EditProfilePage extends BaseStatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());
    final nameCtrl = TextEditingController(text: controller.user.value?.name ?? '');
    final emailCtrl = TextEditingController(text: controller.user.value?.email ?? '');
    final phoneCtrl = TextEditingController(text: controller.user.value?.phone ?? '');
    final gender = (controller.user.value?.gender ?? 'male').obs;
    final dob = (controller.user.value?.dateOfBirth ?? '').obs;
    if (kDebugMode) {
      if (nameCtrl.text.trim().isEmpty) nameCtrl.text = 'Debug User';
      if (emailCtrl.text.trim().isEmpty) emailCtrl.text = 'debug@queen.com';
      if (phoneCtrl.text.trim().isEmpty) phoneCtrl.text = '9876543210';
      if (dob.value.isEmpty) dob.value = '1998-01-01';
    }

    return Scaffold(
      appBar: const AppBarWidget(
        title: StringConst.editProfileTitle,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  SmartImage.circular(
                    source: controller.user.value?.photoUrl ?? '',
                    size: 100,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(DesignTokens.spacing8),
                        decoration: BoxDecoration(
                          color: ColorConst.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: DesignTokens.shadowSmall,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: ColorConst.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacing24),
            CustomTextField(
              label: StringConst.fullName,
              hint: StringConst.enterName,
              controller: nameCtrl,
            ),
            const SizedBox(height: DesignTokens.spacing12),
            CustomTextField(
              label: StringConst.email,
              hint: StringConst.enterEmail,
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: DesignTokens.spacing12),
            CustomTextField(
              label: StringConst.phone,
              hint: StringConst.enterPhone,
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: DesignTokens.spacing12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringConst.gender, style: AppTextStyle.inputLabel),
                const SizedBox(height: DesignTokens.spacing4),
                Obx(() => Row(
                      children: [
                        _GenderChip(
                          label: 'Male',
                          isSelected: gender.value == 'male',
                          onTap: () => gender.value = 'male',
                        ),
                        const SizedBox(width: DesignTokens.spacing8),
                        _GenderChip(
                          label: 'Female',
                          isSelected: gender.value == 'female',
                          onTap: () => gender.value = 'female',
                        ),
                        const SizedBox(width: DesignTokens.spacing8),
                        _GenderChip(
                          label: 'Other',
                          isSelected: gender.value == 'other',
                          onTap: () => gender.value = 'other',
                        ),
                      ],
                    )),
              ],
            ),
            const SizedBox(height: DesignTokens.spacing12),
            Obx(() => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Date of Birth',
                    style: AppTextStyle.inputLabel,
                  ),
                  subtitle: Text(
                    dob.value.isEmpty ? 'Select date' : dob.value,
                    style: AppTextStyle.bodyMedium,
                  ),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      dob.value =
                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    }
                  },
                )),
            const SizedBox(height: DesignTokens.spacing24),
            GradientButton(
              onTap: () {
                final updated = controller.user.value!.copyWith(
                  name: nameCtrl.text,
                  email: emailCtrl.text,
                  phone: phoneCtrl.text,
                  gender: gender.value,
                  dateOfBirth: dob.value,
                );
                controller.updateProfile(updated);
                Get.back();
              },
              child: Text(
                StringConst.save,
                style: AppTextStyle.buttonText.copyWith(
                  color: ColorConst.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing16,
          vertical: DesignTokens.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorConst.primaryColor
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(DesignTokens.radiusCircular),
        ),
        child: Text(
          label,
          style: AppTextStyle.labelMedium.copyWith(
            color: isSelected ? ColorConst.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
