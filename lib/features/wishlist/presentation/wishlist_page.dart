import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/wishlist/controller/wishlist_controller.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';
import 'package:portfolio/global/widgets/empty_widget.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';
import 'package:portfolio/global/widgets/responsive_layout.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/model/product_model.dart';

class WishlistPage extends BaseStatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.put(WishlistController());
    return Scaffold(
      appBar: ResponsiveLayout.isMobile(context)
          ? null
          : AppBarWidget(
              title: StringConst.wishlistTitle,
              showBack: !kIsWeb,
            ),
      body: Obx(() {
        if (controller.wishlistItems.isEmpty) {
          return EmptyWidget(
            message: StringConst.wishlistEmpty,
            subtitle: StringConst.wishlistEmptySubtitle,
            icon: Icons.favorite_border,
          );
        }
        final cols = ResponsiveLayout.gridColumns(context);
        return GridView.builder(
          padding: const EdgeInsets.all(DesignTokens.spacing8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            childAspectRatio: 0.75,
            crossAxisSpacing: DesignTokens.spacing8,
            mainAxisSpacing: DesignTokens.spacing8,
          ),
          itemCount: controller.wishlistItems.length,
          itemBuilder: (_, i) => _WishlistProductCard(
            product: controller.wishlistItems[i],
            onRemove: () => controller.removeFromWishlist(
              controller.wishlistItems[i].id,
            ),
            onAddToCart: () {},
          ),
        );
      }),
    );
  }
}

class _WishlistProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const _WishlistProductCard({
    required this.product,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: DesignTokens.spacing16),
        margin: const EdgeInsets.only(bottom: DesignTokens.spacing8),
        decoration: BoxDecoration(
          color: ColorConst.colorFFEF4444,
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
        ),
        child: Icon(
          Icons.delete_outline,
          color: ColorConst.white,
          size: 28,
        ),
      ),
      child: GestureDetector(
        onTap: () => Get.toNamed('/product/${product.id}'),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(DesignTokens.radius12),
            boxShadow: DesignTokens.shadowSmall,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(DesignTokens.radius12),
                      ),
                      child: SmartImage(
                        source: product.displayImage,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Positioned(
                    top: DesignTokens.spacing8,
                    right: DesignTokens.spacing8,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(DesignTokens.spacing4),
                        decoration: BoxDecoration(
                          color: ColorConst.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: DesignTokens.shadowSmall,
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 20,
                          color: ColorConst.colorFFEF4444,
                        ),
                      ),
                    ),
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: DesignTokens.spacing8,
                      left: DesignTokens.spacing8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing6,
                          vertical: DesignTokens.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConst.colorFFEF4444,
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radius4),
                        ),
                        child: Text(
                          '${product.calculatedDiscount}% OFF',
                          style: AppTextStyle.labelSmall.copyWith(
                            color: ColorConst.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing8,
                    vertical: DesignTokens.spacing4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          product.name,
                          style: AppTextStyle.labelMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            '${AppConstant.currency}${product.price.toStringAsFixed(0)}',
                            style: AppTextStyle.titleSmall.copyWith(
                              color: ColorConst.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (product.mrp > product.price) ...[
                            const SizedBox(width: DesignTokens.spacing4),
                            Text(
                              '${AppConstant.currency}${product.mrp.toStringAsFixed(0)}',
                              style: AppTextStyle.caption.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: DesignTokens.spacing4),
                      SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          onTap: onAddToCart,
                          height: 28,
                          child: Text(
                            StringConst.addToCart,
                            style: AppTextStyle.labelSmall.copyWith(
                              color: ColorConst.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
