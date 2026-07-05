import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/orders/controller/order_controller.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/utils/dialog_utils.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/model/order_model.dart';

class OrderDetailPage extends BaseStatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final orderId = Get.parameters['orderId'] ?? Get.arguments as String?;
    final controller = Get.put(OrderController());
    if (orderId != null) controller.loadOrderDetail(orderId);

    return Scaffold(
      appBar: AppBarWidget(
        title: StringConst.orderDetails,
        showBack: true,
      ),
      body: Obx(() {
        final order = controller.selectedOrder.value;
        if (order == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacing8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OrderHeader(order: order),
              const SizedBox(height: DesignTokens.spacing16),
              _TrackingTimeline(steps: order.trackingSteps),
              const SizedBox(height: DesignTokens.spacing16),
              _ItemsSection(items: order.items),
              const SizedBox(height: DesignTokens.spacing16),
              if (order.deliveryAddress != null)
                _AddressCard(address: order.deliveryAddress!),
              const SizedBox(height: DesignTokens.spacing16),
              _PaymentInfo(order: order),
              const SizedBox(height: DesignTokens.spacing16),
              _PriceBreakdown(order: order),
              if (order.canCancel) ...[
                const SizedBox(height: DesignTokens.spacing16),
                GradientButton(
                  onTap: () => _showCancelDialog(controller, order.id),
                  child: Text(
                    StringConst.cancelOrder,
                    style: AppTextStyle.buttonText.copyWith(
                      color: ColorConst.white,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: DesignTokens.spacing24),
            ],
          ),
        );
      }),
    );
  }

  void _showCancelDialog(OrderController controller, String orderId) {
    showConfirmDialog(
      title: StringConst.cancelOrder,
      message: StringConst.deleteConfirmMessage,
      positiveText: StringConst.yes,
      negativeText: StringConst.no,
      onPositive: () => controller.cancelOrder(orderId),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  final OrderModel order;

  const _OrderHeader({required this.order});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#${order.orderNumber}', style: AppTextStyle.headlineSmall),
              _StatusChip(status: order.status),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            '${StringConst.orderDate}: ${_formatDate(order.createdAt)}',
            style: AppTextStyle.bodySmall.copyWith(color: Colors.grey.shade600),
          ),
          if (order.estimatedDelivery.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              '${StringConst.estimatedDelivery}: ${order.estimatedDelivery}',
              style: AppTextStyle.bodySmall.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    switch (status) {
      case 'delivered':
        bg = ColorConst.colorFF10B981;
        break;
      case 'shipped':
        bg = ColorConst.colorFF3B82F6;
        break;
      case 'pending':
      case 'confirmed':
        bg = ColorConst.colorFFF59E0B;
        break;
      case 'cancelled':
        bg = ColorConst.colorFFEF4444;
        break;
      default:
        bg = Colors.grey.shade300;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing8,
        vertical: DesignTokens.spacing4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCircular),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyle.labelSmall.copyWith(
          color: ColorConst.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TrackingTimeline extends StatelessWidget {
  final List<OrderTrackingStep> steps;

  const _TrackingTimeline({required this.steps});

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
          Text(StringConst.orderStatus, style: AppTextStyle.titleMedium),
          const SizedBox(height: DesignTokens.spacing12),
          ...steps.asMap().entries.map((e) {
            final i = e.key;
            final step = e.value;
            final isLast = i == steps.length - 1;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: step.isCompleted
                              ? ColorConst.colorFF10B981
                              : step.isCurrent
                                  ? ColorConst.primaryColor
                                  : Colors.grey.shade300,
                          border: Border.all(
                            color: step.isCurrent
                                ? ColorConst.primaryColor
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(
                              vertical: DesignTokens.spacing4,
                            ),
                            color: step.isCompleted
                                ? ColorConst.colorFF10B981
                                : Colors.grey.shade300,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: DesignTokens.spacing12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: DesignTokens.spacing16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: AppTextStyle.labelLarge.copyWith(
                              fontWeight: step.isCurrent
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                          if (step.description.isNotEmpty) ...[
                            const SizedBox(height: DesignTokens.spacing4),
                            Text(
                              step.description,
                              style: AppTextStyle.bodySmall.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                          if (step.dateTime.isNotEmpty) ...[
                            const SizedBox(height: DesignTokens.spacing4),
                            Text(
                              step.dateTime,
                              style: AppTextStyle.caption,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ItemsSection extends StatelessWidget {
  final List<dynamic> items;

  const _ItemsSection({required this.items});

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
          Text(StringConst.orderSummary, style: AppTextStyle.titleMedium),
          const SizedBox(height: DesignTokens.spacing12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: DesignTokens.spacing8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(DesignTokens.radius8),
                      child: SmartImage(
                        source: item.productImage,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: AppTextStyle.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${StringConst.qty}: ${item.quantity}',
                            style: AppTextStyle.bodySmall.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${AppConstant.currency}${item.totalPrice.toStringAsFixed(0)}',
                      style: AppTextStyle.titleSmall.copyWith(
                        color: ColorConst.primaryColor,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final dynamic address;

  const _AddressCard({required this.address});

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
              Icon(Icons.location_on_outlined,
                  size: 20, color: ColorConst.primaryColor),
              const SizedBox(width: DesignTokens.spacing8),
              Text(
                StringConst.deliveryAddress,
                style: AppTextStyle.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing8),
          Text(
            address.name,
            style: AppTextStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            address.phone,
            style: AppTextStyle.bodySmall.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            address.fullAddress,
            style: AppTextStyle.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _PaymentInfo extends StatelessWidget {
  final OrderModel order;

  const _PaymentInfo({required this.order});

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
          Text(StringConst.paymentMethod, style: AppTextStyle.titleMedium),
          const SizedBox(height: DesignTokens.spacing8),
          Text(
            order.paymentMethod.isNotEmpty
                ? order.paymentMethod
                : StringConst.cashOnDelivery,
            style: AppTextStyle.bodyMedium,
          ),
          Text(
            'Status: ${order.paymentStatus}',
            style: AppTextStyle.bodySmall.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBreakdown extends StatelessWidget {
  final OrderModel order;

  const _PriceBreakdown({required this.order});

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
        children: [
          _PriceRow(StringConst.subtotal, order.subtotal),
          _PriceRow(StringConst.deliveryFee, order.deliveryFee),
          if (order.discount > 0)
            _PriceRow('${StringConst.discount} (-)', -order.discount),
          const Divider(height: DesignTokens.spacing16),
          _PriceRow(StringConst.total, order.total, isTotal: true),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;

  const _PriceRow(this.label, this.value, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacing4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyle.titleMedium
                : AppTextStyle.bodyMedium.copyWith(
                    color: Colors.grey.shade600,
                  ),
          ),
          Text(
            '${AppConstant.currency}${value.toStringAsFixed(0)}',
            style: AppTextStyle.titleSmall.copyWith(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? ColorConst.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}
