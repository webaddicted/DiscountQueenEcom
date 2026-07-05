import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/model/product_model.dart';

enum ProductCardLayout { grid, horizontal }

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final ProductCardLayout layout;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlistTap;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    this.layout = ProductCardLayout.grid,
    this.onTap,
    this.onAddToCart,
    this.onWishlistTap,
    this.isWishlisted = false,
  });

  @override
  Widget build(BuildContext context) {
    return layout == ProductCardLayout.horizontal
        ? _buildHorizontalCard(context)
        : _buildGridCard(context);
  }

  Widget _buildGridCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConst.white,
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
          boxShadow: DesignTokens.shadowSmall,
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SmartImage.rounded(
                    source: product.displayImage,
                    width: double.infinity,
                    borderRadius: 0,
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: DesignTokens.spacing6,
                      left: DesignTokens.spacing6,
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
                  Positioned(
                    top: DesignTokens.spacing6,
                    right: DesignTokens.spacing6,
                    child: GestureDetector(
                      onTap: onWishlistTap,
                      child: Container(
                        padding: const EdgeInsets.all(DesignTokens.spacing6),
                        decoration: BoxDecoration(
                          color: ColorConst.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: DesignTokens.shadowSmall,
                        ),
                        child: Icon(
                          isWishlisted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 18,
                          color: isWishlisted
                              ? ColorConst.colorFFEF4444
                              : ColorConst.colorFF6B7280,
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
                padding: const EdgeInsets.all(DesignTokens.spacing8),
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
                    const SizedBox(height: DesignTokens.spacing2),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 14, color: ColorConst.colorFFF59E0B),
                        const SizedBox(width: DesignTokens.spacing4),
                        Text(product.rating.toStringAsFixed(1),
                            style: AppTextStyle.labelSmall),
                        Text(
                          ' (${product.reviewCount})',
                          style: AppTextStyle.labelSmall
                              .copyWith(color: ColorConst.colorFF6B7280),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: AppTextStyle.titleSmall
                              .copyWith(color: ColorConst.primaryColor),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: DesignTokens.spacing6),
                          Text(
                            '₹${product.mrp.toStringAsFixed(0)}',
                            style: AppTextStyle.labelSmall.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: ColorConst.colorFF6B7280,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacing4),
                    GestureDetector(
                      onTap: onAddToCart,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: DesignTokens.spacing4),
                        decoration: BoxDecoration(
                          gradient: DesignTokens.primaryGradient,
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radius8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_shopping_cart,
                                size: 14, color: ColorConst.white),
                            const SizedBox(width: DesignTokens.spacing4),
                            Text(
                              'Add',
                              style: AppTextStyle.labelSmall
                                  .copyWith(color: ColorConst.white),
                            ),
                          ],
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
    );
  }

  Widget _buildHorizontalCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: ColorConst.white,
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
          boxShadow: DesignTokens.shadowSmall,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SmartImage.rounded(
                    source: product.displayImage,
                    borderRadius: 0,
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: DesignTokens.spacing4,
                      left: DesignTokens.spacing4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing4,
                          vertical: DesignTokens.spacing2,
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
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: DesignTokens.spacing4,
                    right: DesignTokens.spacing4,
                    child: GestureDetector(
                      onTap: onWishlistTap,
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isWishlisted
                            ? ColorConst.colorFFEF4444
                            : ColorConst.colorFF6B7280,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spacing8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        product.name,
                        style: AppTextStyle.labelMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing2),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 12, color: ColorConst.colorFFF59E0B),
                        const SizedBox(width: DesignTokens.spacing4),
                        Text(product.rating.toStringAsFixed(1),
                            style: AppTextStyle.labelSmall),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacing4),
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: AppTextStyle.titleSmall
                              .copyWith(color: ColorConst.primaryColor),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: DesignTokens.spacing6),
                          Text(
                            '₹${product.mrp.toStringAsFixed(0)}',
                            style: AppTextStyle.labelSmall.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: ColorConst.colorFF6B7280,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onAddToCart,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing8,
                          vertical: DesignTokens.spacing4,
                        ),
                        decoration: BoxDecoration(
                          gradient: DesignTokens.primaryGradient,
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radius8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_shopping_cart,
                                size: 14, color: ColorConst.white),
                            const SizedBox(width: DesignTokens.spacing4),
                            Text(
                              'Add',
                              style: AppTextStyle.labelSmall
                                  .copyWith(color: ColorConst.white),
                            ),
                          ],
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
    );
  }
}
