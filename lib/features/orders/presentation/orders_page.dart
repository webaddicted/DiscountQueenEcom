import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/orders/controller/order_controller.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';
import 'package:portfolio/global/widgets/empty_widget.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/features/orders/domain/order_model.dart';

class OrdersPage extends BaseStatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.put(OrderController());
    if (SPManager.isLoggedIn()) {
      controller.loadOrders();
    }
    return Scaffold(
      appBar: const AppBarWidget(
        title: StringConst.ordersTitle,
        showBack: true,
      ),
      body: Column(
        children: [
          _StatusTabs(controller: controller),
          Expanded(
            child: Obx(() {
              final filtered = controller.getFilteredOrders(controller.selectedStatus.value);
              if (filtered.isEmpty) {
                return const EmptyWidget(
                  message: StringConst.noOrders,
                  subtitle: StringConst.noOrdersSubtitle,
                  icon: Icons.receipt_long_outlined,
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(DesignTokens.spacing8),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: DesignTokens.spacing8),
                itemBuilder: (_, i) => _OrderCard(order: filtered[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  final OrderController controller;

  const _StatusTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (StringConst.orderStatusAll, 'all'),
      (StringConst.orderStatusPending, 'pending'),
      (StringConst.orderStatusShipped, 'shipped'),
      (StringConst.orderStatusDelivered, 'delivered'),
      (StringConst.orderStatusCancelled, 'cancelled'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing8,
        vertical: DesignTokens.spacing8,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(() => Row(
          children: tabs.map((t) {
            final isSelected = controller.selectedStatus.value == t.$2;
            return Padding(
              padding: const EdgeInsets.only(right: DesignTokens.spacing8),
              child: GestureDetector(
                onTap: () => controller.selectedStatus.value = t.$2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing16,
                    vertical: DesignTokens.spacing8,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? DesignTokens.primaryGradient : null,
                    color: isSelected ? null : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusCircular),
                  ),
                  child: Text(
                    t.$1,
                    style: AppTextStyle.labelMedium.copyWith(
                      color: isSelected ? ColorConst.white : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        )),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/order/${order.id}'),
      child: Container(
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
                Text(
                  '#${order.orderNumber}',
                  style: AppTextStyle.titleMedium,
                ),
                _StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              order.createdAt.isNotEmpty
                  ? _formatDate(order.createdAt)
                  : '-',
              style: AppTextStyle.bodySmall.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: DesignTokens.spacing8),
            if (order.items.isNotEmpty)
              Row(
                children: [
                  SizedBox(
                    height: 48,
                    width: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: order.items.length > 3 ? 3 : order.items.length,
                      separatorBuilder: (_, _) => const SizedBox(width: DesignTokens.spacing4),
                      itemBuilder: (_, i) => ClipRRect(
                        borderRadius: BorderRadius.circular(DesignTokens.radius8),
                        child: SmartImage(
                          source: order.items[i].productImage,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (order.items.length > 3)
                    Text(
                      ' +${order.items.length - 3}',
                      style: AppTextStyle.bodySmall,
                    ),
                ],
              ),
            const SizedBox(height: DesignTokens.spacing8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppConstant.currency}${order.total.toStringAsFixed(0)}',
                  style: AppTextStyle.titleMedium.copyWith(
                    color: ColorConst.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    if (!order.isCancelled)
                      TextButton(
                        onPressed: () => Get.toNamed('/order/${order.id}'),
                        child: Text(
                          StringConst.trackOrder,
                          style: AppTextStyle.labelMedium.copyWith(
                            color: ColorConst.primaryColor,
                          ),
                        ),
                      ),
                    if (order.isDelivered)
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          StringConst.reorder,
                          style: AppTextStyle.labelMedium.copyWith(
                            color: ColorConst.primaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
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

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case 'delivered':
        bg = ColorConst.colorFF10B981;
        fg = ColorConst.white;
        break;
      case 'shipped':
        bg = ColorConst.colorFF3B82F6;
        fg = ColorConst.white;
        break;
      case 'pending':
      case 'confirmed':
        bg = ColorConst.colorFFF59E0B;
        fg = ColorConst.colorFF1F2937;
        break;
      case 'cancelled':
        bg = ColorConst.colorFFEF4444;
        fg = ColorConst.white;
        break;
      default:
        bg = Colors.grey.shade300;
        fg = Colors.grey.shade700;
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
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
