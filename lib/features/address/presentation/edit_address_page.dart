import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/address/controller/address_controller.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';
import 'package:portfolio/global/widgets/custom_text_field.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';
import 'package:portfolio/features/address/domain/address_model.dart';

class EditAddressPage extends BaseStatelessWidget {
  const EditAddressPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final address = Get.arguments as AddressModel?;
    final controller = Get.put(AddressController());
    if (address != null) {
      controller.loadAddressForEdit(address);
    } else {
      controller.applyDebugDefaultsIfNeeded();
    }

    return Scaffold(
      appBar: const AppBarWidget(
        title: StringConst.editAddress,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: StringConst.fullName,
              hint: StringConst.enterName,
              controller: controller.nameController,
            ),
            const SizedBox(height: DesignTokens.spacing12),
            CustomTextField(
              label: StringConst.phone,
              hint: StringConst.enterPhone,
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: DesignTokens.spacing12),
            CustomTextField(
              label: StringConst.addressLine1,
              hint: 'Street, Building, House No.',
              controller: controller.addressLine1Controller,
            ),
            const SizedBox(height: DesignTokens.spacing12),
            CustomTextField(
              label: StringConst.addressLine2,
              hint: 'Apartment, Suite, etc. (Optional)',
              controller: controller.addressLine2Controller,
            ),
            const SizedBox(height: DesignTokens.spacing12),
            CustomTextField(
              label: StringConst.city,
              hint: 'City',
              controller: controller.cityController,
            ),
            const SizedBox(height: DesignTokens.spacing12),
            CustomTextField(
              label: StringConst.state,
              hint: 'State',
              controller: controller.stateController,
            ),
            const SizedBox(height: DesignTokens.spacing12),
            CustomTextField(
              label: StringConst.pincode,
              hint: 'Pincode',
              controller: controller.pincodeController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: DesignTokens.spacing12),
            CustomTextField(
              label: StringConst.landmark,
              hint: 'Landmark (Optional)',
              controller: controller.landmarkController,
            ),
            const SizedBox(height: DesignTokens.spacing16),
            Text(StringConst.addressType, style: AppTextStyle.inputLabel),
            const SizedBox(height: DesignTokens.spacing8),
            Obx(() => Row(
                  children: [
                    _TypeChip(
                      label: StringConst.homeAddress,
                      icon: Icons.home_outlined,
                      isSelected: controller.selectedType.value == 'home',
                      onTap: () => controller.selectedType.value = 'home',
                    ),
                    const SizedBox(width: DesignTokens.spacing8),
                    _TypeChip(
                      label: StringConst.officeAddress,
                      icon: Icons.work_outline,
                      isSelected: controller.selectedType.value == 'office',
                      onTap: () => controller.selectedType.value = 'office',
                    ),
                    const SizedBox(width: DesignTokens.spacing8),
                    _TypeChip(
                      label: StringConst.otherAddress,
                      icon: Icons.location_on_outlined,
                      isSelected: controller.selectedType.value == 'other',
                      onTap: () => controller.selectedType.value = 'other',
                    ),
                  ],
                )),
            const SizedBox(height: DesignTokens.spacing16),
            Obx(() => CheckboxListTile(
                  value: controller.isDefault.value,
                  onChanged: (v) => controller.isDefault.value = v ?? false,
                  title: Text(
                    StringConst.setAsDefault,
                    style: AppTextStyle.bodyMedium,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                )),
            const SizedBox(height: DesignTokens.spacing24),
            GradientButton(
              onTap: () {
                if (address == null) return;
                final updated = address.copyWith(
                  name: controller.nameController.text,
                  phone: controller.phoneController.text,
                  addressLine1: controller.addressLine1Controller.text,
                  addressLine2: controller.addressLine2Controller.text,
                  city: controller.cityController.text,
                  state: controller.stateController.text,
                  pincode: controller.pincodeController.text,
                  landmark: controller.landmarkController.text,
                  type: controller.selectedType.value,
                  isDefault: controller.isDefault.value,
                );
                controller.updateAddress(updated);
                Get.back();
              },
              child: Text(
                StringConst.update,
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

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing12,
          vertical: DesignTokens.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorConst.primaryColor.withValues(alpha: 0.2)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(DesignTokens.radius8),
          border: isSelected
              ? Border.all(color: ColorConst.primaryColor, width: 2)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? ColorConst.primaryColor : Colors.grey.shade600,
            ),
            const SizedBox(width: DesignTokens.spacing8),
            Text(
              label,
              style: AppTextStyle.labelMedium.copyWith(
                color: isSelected ? ColorConst.primaryColor : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
