import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/utils/main_tab_obx.dart';
import 'package:portfolio/global/widgets/empty_widget.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';
import 'package:portfolio/global/widgets/responsive_layout.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/global/widgets/custom_text_field.dart';
import 'package:portfolio/features/cart/controller/cart_controller.dart';
import 'package:portfolio/features/cart/domain/cart_model.dart';

class CartPage extends BaseStatelessWidget {
  const CartPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final couponController = TextEditingController();
    if (kDebugMode) {
      couponController.text = 'WELCOME10';
    }

    final isMobile = ResponsiveLayout.isMobile(context);

    return Obx(() {
      trackMainShellObx();
      if (!Get.isRegistered<CartController>()) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: ColorConst.primaryColor),
          ),
        );
      }
      final controller = Get.find<CartController>();
      return _buildCartScaffold(
        context,
        controller,
        couponController,
        isMobile,
      );
    });
  }

  Widget _buildCartScaffold(
    BuildContext context,
    CartController controller,
    TextEditingController couponController,
    bool isMobile,
  ) {
    return Scaffold(
      appBar: isMobile
          ? null
          : AppBar(
              title: Text(
                StringConst.cartTitle,
                style: AppTextStyle.navTitle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              automaticallyImplyLeading: !kIsWeb,
              leading: kIsWeb
                  ? null
                  : IconButton(
                      icon: Icon(Icons.arrow_back_ios_new,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface),
                      onPressed: () => Get.back(),
                    ),
            ),
      body: Obx(() {
        if (controller.isEmpty) {
          return EmptyWidget(
            message: StringConst.cartEmpty,
            subtitle: StringConst.cartEmptySubtitle,
            icon: Icons.shopping_cart_outlined,
            action: GradientButton(
              onTap: () => Get.offAllNamed(RoutersConst.home),
              child: Text(
                StringConst.continueShopping,
                style: AppTextStyle.buttonText.copyWith(
                  color: ColorConst.white,
                ),
              ),
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(DesignTokens.spacing8),
                children: [
                  _buildFreeDeliveryProgress(context, controller),
                  const SizedBox(height: DesignTokens.spacing8),
                  ...controller.cart.value.items.map(
                    (item) => _CartItemTile(
                      item: item,
                      onRemove: () => controller.removeFromCart(item.id),
                      onQuantityChanged: (qty) =>
                          controller.updateQuantity(item.id, qty),
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacing8),
                  _buildCouponSection(
                    context,
                    controller,
                    couponController,
                  ),
                  const SizedBox(height: DesignTokens.spacing8),
                  _buildPriceBreakdown(context, controller),
                ],
              ),
            ),
            _buildBottomBar(context, controller),
          ],
        );
      }),
    );
  }

  Widget _buildFreeDeliveryProgress(
      BuildContext context, CartController controller) {
    final subtotal = controller.subtotal;
    const threshold = AppConstant.freeDeliveryThreshold;
    if (subtotal >= threshold) return const SizedBox();
    final progress = (subtotal / threshold).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing8),
      decoration: BoxDecoration(
        color: ColorConst.colorFF10B981.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${StringConst.freeDelivery} delivery on orders above ${AppConstant.currency}${threshold.toInt()}',
                style: AppTextStyle.labelSmall.copyWith(
                  color: ColorConst.colorFF059669,
                ),
              ),
              Text(
                '${AppConstant.currency}${(threshold - subtotal).toInt()} more',
                style: AppTextStyle.labelSmall.copyWith(
                  color: ColorConst.colorFF059669,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing4),
          ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radius4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: ColorConst.colorFFD1D5DB,
              valueColor: const AlwaysStoppedAnimation(ColorConst.colorFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection(
    BuildContext context,
    CartController controller,
    TextEditingController couponController,
  ) {
    return Obx(() {
      final hasCoupon = controller.cart.value.couponCode.isNotEmpty;
      return Container(
        padding: const EdgeInsets.all(DesignTokens.spacing8),
        decoration: BoxDecoration(
          border: Border.all(color: ColorConst.colorFFE5E7EB),
          borderRadius: BorderRadius.circular(DesignTokens.radius8),
        ),
        child: hasCoupon
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${StringConst.couponCode}: ${controller.cart.value.couponCode}',
                    style: AppTextStyle.labelMedium.copyWith(
                      color: ColorConst.colorFF059669,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.removeCoupon,
                    child: Text(StringConst.remove, style: AppTextStyle.labelSmall),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: couponController,
                      hint: StringConst.couponCode,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacing8),
                  GradientButton(
                    onTap: () {
                      controller.applyCoupon(couponController.text.trim());
                    },
                    child: Text(
                      StringConst.apply,
                      style: AppTextStyle.buttonText.copyWith(
                        color: ColorConst.white,
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }

  Widget _buildPriceBreakdown(
      BuildContext context, CartController controller) {
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
            value: '${AppConstant.currency}${controller.subtotal.toStringAsFixed(0)}',
          ),
          _PriceRow(
            label: StringConst.deliveryFee,
            value: controller.deliveryFee > 0
                ? '${AppConstant.currency}${controller.deliveryFee.toStringAsFixed(0)}'
                : StringConst.freeDelivery,
          ),
          if (controller.cart.value.couponDiscount > 0)
            _PriceRow(
              label: StringConst.discount,
              value:
                  '-${AppConstant.currency}${controller.cart.value.couponDiscount.toStringAsFixed(0)}',
              valueColor: ColorConst.colorFF059669,
            ),
          const Divider(color: ColorConst.colorFFE5E7EB),
          _PriceRow(
            label: StringConst.total,
            value: '${AppConstant.currency}${controller.total.toStringAsFixed(0)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartController controller) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: DesignTokens.shadowMedium,
      ),
      child: SafeArea(
        child: GradientButton(
          onTap: () => Get.toNamed(RoutersConst.checkout),
          child: Text(
            StringConst.proceedToCheckout,
            style: AppTextStyle.buttonText.copyWith(
              color: ColorConst.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const _CartItemTile({
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: DesignTokens.spacing16),
        color: ColorConst.colorFFEF4444,
        child: const Icon(Icons.delete_outline, color: ColorConst.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: DesignTokens.spacing8),
        padding: const EdgeInsets.all(DesignTokens.spacing8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
          boxShadow: DesignTokens.shadowSmall,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmartImage.rounded(
              source: item.productImage,
              width: 80,
              height: 80,
              borderRadius: DesignTokens.radius8,
            ),
            const SizedBox(width: DesignTokens.spacing8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: AppTextStyle.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: DesignTokens.spacing4),
                  Text(
                    '${AppConstant.currency}${item.price.toInt()}',
                    style: AppTextStyle.labelMedium.copyWith(
                      color: ColorConst.colorFF059669,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item.selectedSize.isNotEmpty || item.selectedColor.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: DesignTokens.spacing4),
                      child: Text(
                        [
                          if (item.selectedSize.isNotEmpty)
                            '${StringConst.size}: ${item.selectedSize}',
                          if (item.selectedColor.isNotEmpty)
                            '${StringConst.color}: ${item.selectedColor}',
                        ].join(' • '),
                        style: AppTextStyle.labelSmall.copyWith(
                          color: ColorConst.colorFF6B7280,
                        ),
                      ),
                    ),
                  const SizedBox(height: DesignTokens.spacing8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConst.colorFFE5E7EB),
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radius8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () =>
                                  onQuantityChanged(item.quantity - 1),
                              padding: const EdgeInsets.all(DesignTokens.spacing4),
                              constraints: const BoxConstraints(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: DesignTokens.spacing8),
                              child: Text(
                                '${item.quantity}',
                                style: AppTextStyle.labelMedium,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () =>
                                  onQuantityChanged(item.quantity + 1),
                              padding: const EdgeInsets.all(DesignTokens.spacing4),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            size: 20, color: ColorConst.colorFFEF4444),
                        onPressed: onRemove,
                      ),
                    ],
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
