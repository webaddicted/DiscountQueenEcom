import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/address/controller/address_controller.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/utils/dialog_utils.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';
import 'package:portfolio/global/widgets/empty_widget.dart';
import 'package:portfolio/features/address/domain/address_model.dart';

class AddressListPage extends BaseStatelessWidget {
  const AddressListPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.put(AddressController());
    if (SPManager.isLoggedIn()) {
      controller.loadAddresses();
    }
    return Scaffold(
      appBar: const AppBarWidget(
        title: StringConst.addressTitle,
        showBack: true,
      ),
      body: Obx(() {
        if (controller.addresses.isEmpty) {
          return EmptyWidget(
            message: StringConst.noAddresses,
            subtitle: StringConst.noAddressesSubtitle,
            icon: Icons.location_off_outlined,
            action: TextButton.icon(
              onPressed: () => Get.toNamed(RoutersConst.addAddress),
              icon: const Icon(Icons.add),
              label: const Text(StringConst.addNewAddress),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(DesignTokens.spacing8),
          itemCount: controller.addresses.length,
          separatorBuilder: (_, _) => const SizedBox(height: DesignTokens.spacing8),
          itemBuilder: (_, i) => _AddressCard(
            address: controller.addresses[i],
            onEdit: () {
              final addr = controller.addresses[i];
              controller.loadAddressForEdit(addr);
              Get.toNamed(RoutersConst.editAddress, arguments: addr);
            },
            onDelete: () {
              showConfirmDialog(
                title: StringConst.deleteConfirmTitle,
                message: StringConst.deleteConfirmMessage,
                positiveText: StringConst.delete,
                onPositive: () =>
                    controller.deleteAddress(controller.addresses[i].id),
              );
            },
            onSetDefault: () =>
                controller.setDefault(controller.addresses[i].id),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(RoutersConst.addAddress),
        icon: const Icon(Icons.add),
        label: const Text(StringConst.addNewAddress),
        backgroundColor: ColorConst.primaryColor,
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        boxShadow: DesignTokens.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getTypeIcon(address.type),
                size: 24,
                color: ColorConst.primaryColor,
              ),
              const SizedBox(width: DesignTokens.spacing8),
              Text(
                address.name,
                style: AppTextStyle.titleMedium,
              ),
              const Spacer(),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing8,
                    vertical: DesignTokens.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConst.colorFF10B981.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(DesignTokens.radiusCircular),
                  ),
                  child: Text(
                    'DEFAULT',
                    style: AppTextStyle.labelSmall.copyWith(
                      color: ColorConst.colorFF10B981,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing8),
          Text(
            address.phone,
            style: AppTextStyle.bodySmall.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            address.fullAddress,
            style: AppTextStyle.bodyMedium,
          ),
          const SizedBox(height: DesignTokens.spacing12),
          Row(
            children: [
              const Icon(Icons.edit_outlined, size: 18, color: ColorConst.primaryColor),
              const SizedBox(width: DesignTokens.spacing4),
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                ),
                child: Text(
                  StringConst.edit,
                  style: AppTextStyle.labelMedium.copyWith(
                    color: ColorConst.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacing16),
              const Icon(Icons.delete_outline, size: 18, color: ColorConst.colorFFEF4444),
              const SizedBox(width: DesignTokens.spacing4),
              TextButton(
                onPressed: onDelete,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                ),
                child: Text(
                  StringConst.delete,
                  style: AppTextStyle.labelMedium.copyWith(
                    color: ColorConst.colorFFEF4444,
                  ),
                ),
              ),
              const Spacer(),
              if (!address.isDefault)
                TextButton(
                  onPressed: onSetDefault,
                  child: Text(
                    StringConst.setAsDefault,
                    style: AppTextStyle.labelSmall.copyWith(
                      color: ColorConst.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'home':
        return Icons.home_outlined;
      case 'office':
        return Icons.work_outline;
      default:
        return Icons.location_on_outlined;
    }
  }
}
