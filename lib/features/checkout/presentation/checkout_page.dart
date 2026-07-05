import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/features/checkout/controller/checkout_controller.dart';
import 'package:portfolio/features/cart/controller/cart_controller.dart';
import 'package:portfolio/features/address/domain/address_model.dart';

class CheckoutPage extends BaseStatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConst.checkoutTitle,
          style: AppTextStyle.navTitle.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 20, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacing8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddressSection(context, controller),
              const SizedBox(height: DesignTokens.spacing16),
              _buildPaymentSection(context, controller),
              const SizedBox(height: DesignTokens.spacing16),
              _buildOrderSummary(context, cartController),
              const SizedBox(height: DesignTokens.spacing16),
              _buildPriceBreakdown(context, cartController),
              const SizedBox(height: 100),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomBar(context, controller),
    );
  }

  Widget _buildAddressSection(
      BuildContext context, CheckoutController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              StringConst.deliveryAddress,
              style: AppTextStyle.titleMedium,
            ),
            TextButton(
              onPressed: () => _showAddressSheet(context, controller),
              child: Text(StringConst.edit, style: AppTextStyle.labelMedium),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacing8),
        Obx(() {
          final addr = controller.selectedAddress.value;
          if (addr == null) {
            return Container(
              padding: const EdgeInsets.all(DesignTokens.spacing8),
              decoration: BoxDecoration(
                border: Border.all(color: ColorConst.colorFFEF4444),
                borderRadius: BorderRadius.circular(DesignTokens.radius8),
              ),
              child: Text(
                StringConst.noAddresses,
                style: AppTextStyle.bodyMedium,
              ),
            );
          }
          return _AddressCard(address: addr);
        }),
      ],
    );
  }

  void _showAddressSheet(BuildContext context, CheckoutController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(DesignTokens.spacing8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radius16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(StringConst.selectAddress, style: AppTextStyle.titleMedium),
            const SizedBox(height: DesignTokens.spacing8),
            ...controller.addresses.map((addr) => Obx(() => ListTile(
                  title: Text(addr.name, style: AppTextStyle.labelLarge),
                  subtitle: Text(
                    addr.fullAddress,
                    style: AppTextStyle.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: controller.selectedAddress.value?.id == addr.id
                      ? const Icon(Icons.check_circle,
                          color: ColorConst.colorFF059669, size: 24)
                      : null,
                  onTap: () {
                    controller.selectAddress(addr);
                    Get.back();
                  },
                ))),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection(
      BuildContext context, CheckoutController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringConst.paymentMethod, style: AppTextStyle.titleMedium),
        const SizedBox(height: DesignTokens.spacing8),
        Obx(() => Column(
              children: [
                _PaymentOption(
                  label: StringConst.cashOnDelivery,
                  value: 'cod',
                  groupValue: controller.selectedPaymentMethod.value,
                  onTap: () => controller.selectPaymentMethod('cod'),
                ),
                _PaymentOption(
                  label: StringConst.onlinePayment,
                  value: 'online',
                  groupValue: controller.selectedPaymentMethod.value,
                  onTap: () => controller.selectPaymentMethod('online'),
                ),
                _PaymentOption(
                  label: StringConst.upi,
                  value: 'upi',
                  groupValue: controller.selectedPaymentMethod.value,
                  onTap: () => controller.selectPaymentMethod('upi'),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildOrderSummary(
      BuildContext context, CartController cartController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringConst.orderSummary, style: AppTextStyle.titleMedium),
        const SizedBox(height: DesignTokens.spacing8),
        ...cartController.cart.value.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacing8),
              child: Row(
                children: [
                  SmartImage.rounded(
                    source: item.productImage,
                    width: 56,
                    height: 56,
                    borderRadius: DesignTokens.radius8,
                  ),
                  const SizedBox(width: DesignTokens.spacing8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: AppTextStyle.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${StringConst.qty}: ${item.quantity} × ${AppConstant.currency}${item.price.toInt()}',
                          style: AppTextStyle.bodySmall.copyWith(
                            color: ColorConst.colorFF6B7280,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${AppConstant.currency}${item.totalPrice.toInt()}',
                    style: AppTextStyle.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildPriceBreakdown(
      BuildContext context, CartController cartController) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        boxShadow: DesignTokens.shadowSmall,
      ),
      child: Column(
        children: [
          _PriceRow(
            label: StringConst.subtotal,
            value:
                '${AppConstant.currency}${cartController.subtotal.toStringAsFixed(0)}',
          ),
          _PriceRow(
            label: StringConst.deliveryFee,
            value: cartController.deliveryFee > 0
                ? '${AppConstant.currency}${cartController.deliveryFee.toStringAsFixed(0)}'
                : StringConst.freeDelivery,
          ),
          if (cartController.cart.value.couponDiscount > 0)
            _PriceRow(
              label: StringConst.discount,
              value:
                  '-${AppConstant.currency}${cartController.cart.value.couponDiscount.toStringAsFixed(0)}',
              valueColor: ColorConst.colorFF059669,
            ),
          const Divider(color: ColorConst.colorFFE5E7EB),
          _PriceRow(
            label: StringConst.total,
            value:
                '${AppConstant.currency}${(cartController.subtotal + cartController.deliveryFee - cartController.cart.value.couponDiscount).toStringAsFixed(0)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, CheckoutController controller) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: DesignTokens.shadowMedium,
      ),
      child: SafeArea(
        child: GradientButton(
          onTap: () => controller.placeOrder(),
          child: Text(
            StringConst.placeOrder,
            style: AppTextStyle.buttonText.copyWith(
              color: ColorConst.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;

  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing8),
      decoration: BoxDecoration(
        border: Border.all(color: ColorConst.colorFFE5E7EB),
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(address.name, style: AppTextStyle.titleSmall),
              const SizedBox(width: DesignTokens.spacing8),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing6,
                    vertical: DesignTokens.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConst.colorFF059669.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(DesignTokens.radius8),
                  ),
                  child: Text(
                    StringConst.homeAddress,
                    style: AppTextStyle.labelSmall.copyWith(
                      color: ColorConst.colorFF059669,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            address.phone,
            style: AppTextStyle.bodySmall.copyWith(
              color: ColorConst.colorFF6B7280,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            address.fullAddress,
            style: AppTextStyle.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: AppTextStyle.bodyMedium),
      leading: Radio<String>(
        value: value,
        groupValue: groupValue,
        onChanged: (_) => onTap(),
      ),
      onTap: onTap,
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacing4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? AppTextStyle.titleSmall
                : AppTextStyle.bodyMedium.copyWith(
                    color: ColorConst.colorFF6B7280,
                  ),
          ),
          Text(
            value,
            style: (isBold ? AppTextStyle.titleSmall : AppTextStyle.bodyMedium)
                .copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
              color: valueColor ?? Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
