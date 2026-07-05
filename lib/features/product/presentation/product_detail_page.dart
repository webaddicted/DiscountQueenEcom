import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/global/widgets/shimmer_widget.dart';
import 'package:portfolio/global/extension/string_extension.dart';
import 'package:portfolio/features/product/controller/product_controller.dart';
import 'package:portfolio/features/cart/controller/cart_controller.dart';
import 'package:portfolio/model/product_model.dart';

class ProductDetailPage extends BaseStatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.put(ProductController(), permanent: true);
    final cartController = Get.put(CartController(), permanent: true);
    final productId = Get.parameters['productId'] ??
        Get.parameters['id'] ??
        (Get.arguments is String ? Get.arguments as String : null) ??
        (Get.arguments is ProductModel
            ? (Get.arguments as ProductModel).id
            : null) ??
        'p1';
    if (controller.selectedProduct.value?.id != productId) {
      controller.loadProduct(productId);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          StringConst.productDetails,
          style: AppTextStyle.navTitle.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 20, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => Get.toNamed(RoutersConst.cart),
          ),
        ],
      ),
      body: Obx(() {
        final product = controller.selectedProduct.value;
        if (controller.isLoadingRx.value) {
          return _buildShimmerLoading(context);
        }
        if (product == null) {
          return Center(
            child: Text(StringConst.noDataFound, style: AppTextStyle.bodyMedium),
          );
        }
        return _buildContent(context, controller, cartController, product);
      }),
      bottomNavigationBar: Obx(() {
        final product = controller.selectedProduct.value;
        if (product == null || controller.isLoadingRx.value) {
          return const SizedBox();
        }
        return _buildBottomBar(context, controller, cartController, product);
      }),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            height: MediaQuery.of(context).size.height * 0.6,
            borderRadius: DesignTokens.radius8,
          ),
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacing8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 24, width: 200),
                SizedBox(height: DesignTokens.spacing8),
                ShimmerBox(height: 20, width: 120),
                SizedBox(height: DesignTokens.spacing8),
                ShimmerBox(height: 40, width: 150),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProductController controller,
    CartController cartController,
    ProductModel product,
  ) {
    final imageList =
        product.images.isNotEmpty ? product.images : [product.displayImage];
    if (imageList.isEmpty || imageList.first.isEmpty) return const SizedBox();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageCarousel(context, controller, imageList),
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacing8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.brand.isNotEmpty)
                  Text(product.brand,
                      style: AppTextStyle.labelMedium.copyWith(
                        color: ColorConst.colorFF6B7280,
                      )),
                SizedBox(height: DesignTokens.spacing4),
                Text(product.name,
                    style: AppTextStyle.headlineSmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                SizedBox(height: DesignTokens.spacing8),
                _buildPriceRow(context, product),
                SizedBox(height: DesignTokens.spacing8),
                _buildRatingRow(context, product),
                if (product.sizes.isNotEmpty) ...[
                  SizedBox(height: DesignTokens.spacing12),
                  _buildSizeSelector(controller),
                ],
                if (product.colors.isNotEmpty) ...[
                  SizedBox(height: DesignTokens.spacing8),
                  _buildColorSelector(context, controller),
                ],
                SizedBox(height: DesignTokens.spacing12),
                _buildQuantitySelector(controller),
                SizedBox(height: DesignTokens.spacing16),
                _buildDescriptionSection(context, product),
                SizedBox(height: DesignTokens.spacing16),
                if (product.specifications.isNotEmpty)
                  _buildSpecificationsSection(context, product),
                SizedBox(height: DesignTokens.spacing16),
                _buildReviewsSection(context, controller),
                SizedBox(height: DesignTokens.spacing16),
                _buildRelatedProducts(context, controller, cartController),
                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(
    BuildContext context,
    ProductController controller,
    List<String> images,
  ) {
    final imageHeight = MediaQuery.of(context).size.height * 0.6;
    return SizedBox(
      height: imageHeight,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (i) => controller.selectedImageIndex.value = i,
            itemBuilder: (_, i) => SmartImage(
              source: images[i],
              width: double.infinity,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: DesignTokens.spacing8,
            left: 0,
            right: 0,
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (i) => Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.selectedImageIndex.value == i
                            ? ColorConst.primaryColor
                            : ColorConst.colorFF9CA3AF,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, ProductModel product) {
    return Row(
      children: [
        Text(
          '${AppConstant.currency}${product.price.toInt()}',
          style: AppTextStyle.headlineMedium.copyWith(
            color: ColorConst.colorFF059669,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (product.hasDiscount) ...[
          SizedBox(width: DesignTokens.spacing8),
          Text(
            '${AppConstant.currency}${product.mrp.toInt()}',
            style: AppTextStyle.bodyMedium.copyWith(
              decoration: TextDecoration.lineThrough,
              color: ColorConst.colorFF6B7280,
            ),
          ),
          SizedBox(width: DesignTokens.spacing8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing6,
              vertical: DesignTokens.spacing4,
            ),
            decoration: BoxDecoration(
              color: ColorConst.colorFFEF4444.withOpacity(0.15),
              borderRadius: BorderRadius.circular(DesignTokens.radius8),
            ),
            child: Text(
              '${product.calculatedDiscount}% OFF',
              style: AppTextStyle.labelSmall.copyWith(
                color: ColorConst.colorFFEF4444,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRatingRow(BuildContext context, ProductModel product) {
    return Row(
      children: [
        Icon(Icons.star_rounded,
            size: 18, color: ColorConst.colorFFF59E0B),
        SizedBox(width: DesignTokens.spacing4),
        Text(
          '${product.rating}',
          style: AppTextStyle.labelMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(width: DesignTokens.spacing8),
        Text(
          '(${product.reviewCount} ${StringConst.reviews})',
          style: AppTextStyle.bodySmall.copyWith(
            color: ColorConst.colorFF6B7280,
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelector(ProductController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringConst.size, style: AppTextStyle.labelLarge),
        SizedBox(height: DesignTokens.spacing8),
        Obx(() => Wrap(
              spacing: DesignTokens.spacing8,
              runSpacing: DesignTokens.spacing8,
              children: controller.selectedProduct.value!.sizes
                  .map((s) => GestureDetector(
                        onTap: () => controller.selectSize(s),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacing12,
                            vertical: DesignTokens.spacing8,
                          ),
                          decoration: BoxDecoration(
                            color: controller.selectedSize.value == s
                                ? ColorConst.primaryColor
                                : ColorConst.colorFFF3F4F6,
                            borderRadius:
                                BorderRadius.circular(DesignTokens.radius8),
                            border: Border.all(
                              color: controller.selectedSize.value == s
                                  ? ColorConst.primaryColor
                                  : ColorConst.colorFFE5E7EB,
                            ),
                          ),
                          child: Text(
                            s,
                            style: AppTextStyle.labelMedium.copyWith(
                              color: controller.selectedSize.value == s
                                  ? ColorConst.white
                                  : ColorConst.colorFF374151,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            )),
      ],
    );
  }

  Widget _buildColorSelector(
      BuildContext context, ProductController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringConst.color, style: AppTextStyle.labelLarge),
        SizedBox(height: DesignTokens.spacing8),
        Obx(() => Wrap(
              spacing: DesignTokens.spacing8,
              runSpacing: DesignTokens.spacing8,
              children: controller.selectedProduct.value!.colors
                  .map((c) => GestureDetector(
                        onTap: () => controller.selectColor(c),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _parseColor(c),
                            border: Border.all(
                              width: controller.selectedColor.value == c
                                  ? 3
                                  : 1,
                              color: controller.selectedColor.value == c
                                  ? ColorConst.primaryColor
                                  : ColorConst.colorFFE5E7EB,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            )),
      ],
    );
  }

  Color _parseColor(String hex) {
    try {
      return hex.toColor;
    } catch (_) {
      return ColorConst.colorFF9CA3AF;
    }
  }

  Widget _buildQuantitySelector(ProductController controller) {
    return Row(
      children: [
        Text(StringConst.qty, style: AppTextStyle.labelLarge),
        SizedBox(width: DesignTokens.spacing12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorConst.colorFFE5E7EB),
            borderRadius: BorderRadius.circular(DesignTokens.radius8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove, size: 18, color: ColorConst.colorFF374151),
                onPressed: controller.decrementQty,
                padding: EdgeInsets.all(DesignTokens.spacing4),
                constraints: const BoxConstraints(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacing12),
                child: Obx(() => Text(
                      '${controller.quantity.value}',
                      style: AppTextStyle.titleMedium,
                    )),
              ),
              IconButton(
                icon: Icon(Icons.add, size: 18, color: ColorConst.colorFF374151),
                onPressed: controller.incrementQty,
                padding: EdgeInsets.all(DesignTokens.spacing4),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context, ProductModel product) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.only(top: DesignTokens.spacing8),
      title: Text(
        StringConst.description,
        style: AppTextStyle.titleMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      children: [
        Text(
          product.description,
          style: AppTextStyle.bodyMedium.copyWith(
            color: ColorConst.colorFF6B7280,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecificationsSection(
      BuildContext context, ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConst.specifications,
          style: AppTextStyle.titleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: DesignTokens.spacing8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorConst.colorFFE5E7EB),
            borderRadius: BorderRadius.circular(DesignTokens.radius8),
          ),
          child: Column(
            children: product.specifications.entries
                .map((e) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing12,
                        vertical: DesignTokens.spacing8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key, style: AppTextStyle.bodyMedium),
                          Text(e.value,
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: ColorConst.colorFF6B7280,
                              )),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(
      BuildContext context, ProductController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConst.reviews,
          style: AppTextStyle.titleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: DesignTokens.spacing8),
        Obx(() {
          final revs = controller.reviews.take(3).toList();
          if (revs.isEmpty) {
            return Text(StringConst.noReviews, style: AppTextStyle.bodySmall);
          }
          return Column(
            children: revs
                .map((r) => Padding(
                      padding: EdgeInsets.only(bottom: DesignTokens.spacing8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SmartImage.avatar(
                            source: r.userAvatar,
                            size: 40,
                          ),
                          SizedBox(width: DesignTokens.spacing8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(r.userName,
                                        style: AppTextStyle.labelLarge),
                                    SizedBox(width: DesignTokens.spacing8),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          i < r.rating.round()
                                              ? Icons.star_rounded
                                              : Icons.star_outline_rounded,
                                          size: 14,
                                          color: ColorConst.colorFFF59E0B,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: DesignTokens.spacing4),
                                Text(r.comment,
                                    style: AppTextStyle.bodySmall.copyWith(
                                      color: ColorConst.colorFF6B7280,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          );
        }),
      ],
    );
  }

  Widget _buildRelatedProducts(
    BuildContext context,
    ProductController controller,
    CartController cartController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConst.relatedProducts,
          style: AppTextStyle.titleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: DesignTokens.spacing8),
        SizedBox(
          height: 220,
          child: Obx(() => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.relatedProducts.length,
                separatorBuilder: (_, __) =>
                    SizedBox(width: DesignTokens.spacing8),
                itemBuilder: (_, i) {
                  final p = controller.relatedProducts[i];
                  return _RelatedProductCard(
                    product: p,
                    onTap: () {
                      Get.offNamed('/product/${p.id}');
                    },
                  );
                },
              )),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    ProductController controller,
    CartController cartController,
    ProductModel product,
  ) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.spacing8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: DesignTokens.shadowMedium,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringConst.total, style: AppTextStyle.labelSmall),
                Text(
                  '${AppConstant.currency}${(product.price * controller.quantity.value).toInt()}',
                  style: AppTextStyle.titleLarge.copyWith(
                    color: ColorConst.colorFF059669,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(width: DesignTokens.spacing8),
            Expanded(
              child: GradientButton(
                onTap: () {
                  cartController.addToCart(
                    product,
                    qty: controller.quantity.value,
                    size: controller.selectedSize.value,
                    color: controller.selectedColor.value,
                  );
                  Get.snackbar(
                    StringConst.addedToCart,
                    product.name,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: Text(
                  StringConst.addToCart,
                  style: AppTextStyle.buttonText.copyWith(
                    color: ColorConst.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelatedProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const _RelatedProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmartImage.rounded(
              source: product.displayImage,
              width: 140,
              height: 140,
              borderRadius: DesignTokens.radius12,
            ),
            SizedBox(height: DesignTokens.spacing8),
            Text(
              product.name,
              style: AppTextStyle.labelMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${AppConstant.currency}${product.price.toInt()}',
              style: AppTextStyle.labelMedium.copyWith(
                color: ColorConst.colorFF059669,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
