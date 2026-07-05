import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/empty_widget.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/global/widgets/shimmer_widget.dart';
import 'package:portfolio/features/product/controller/product_controller.dart';
import 'package:portfolio/global/widgets/responsive_layout.dart';
import 'package:portfolio/features/home/domain/category_model.dart';
import 'package:portfolio/features/product/domain/product_model.dart';

class ProductListPage extends BaseStatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.put(ProductController(), permanent: true);
    final args = Get.arguments;
    dynamic loadArg = args;
    String title = StringConst.featuredProducts;
    if (args is Map && args['filter'] != null) {
      loadArg = args;
      title = switch (args['filter']) {
        'popular' => StringConst.popularProducts,
        'new' => StringConst.newArrivals,
        _ => StringConst.featuredProducts,
      };
    } else {
      final categoryId = Get.parameters['categoryId'] ??
          (args is CategoryModel ? args.id : args is String ? args : '');
      loadArg = categoryId;
      if (args is CategoryModel) {
        title = args.name;
      } else if (categoryId.isNotEmpty) {
        title = categoryId;
      }
    }

    if (controller.products.isEmpty && !controller.isLoading) {
      controller.loadProductsByCategory(loadArg);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
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
            icon: Icon(Icons.filter_list,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => _showSortBottomSheet(context, controller),
          ),
          IconButton(
            icon: Icon(Icons.sort,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => _showSortBottomSheet(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingRx.value) {
          return _buildShimmerGrid(context);
        }
        if (controller.products.isEmpty) {
          return EmptyWidget(
            message: StringConst.noDataFound,
            subtitle: StringConst.noResults,
            icon: Icons.inventory_2_outlined,
            action: GradientButton(
              onTap: () => controller.loadProductsByCategory(loadArg),
              child: Text(
                StringConst.retry,
                style: AppTextStyle.buttonText.copyWith(
                  color: ColorConst.white,
                ),
              ),
            ),
          );
        }
        return _buildProductGrid(context, controller);
      }),
    );
  }

  Widget _buildShimmerGrid(BuildContext context) {
    final cols = ResponsiveLayout.gridColumns(context);
    return GridView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacing8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        childAspectRatio: 0.75,
        crossAxisSpacing: DesignTokens.spacing8,
        mainAxisSpacing: DesignTokens.spacing8,
      ),
      itemCount: cols * 3,
      itemBuilder: (_, _) => const ShimmerBox(
        height: 180,
        borderRadius: DesignTokens.radius12,
      ),
    );
  }

  Widget _buildProductGrid(
      BuildContext context, ProductController controller) {
    final cols = ResponsiveLayout.gridColumns(context);
    return GridView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacing8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        childAspectRatio: 0.75,
        crossAxisSpacing: DesignTokens.spacing8,
        mainAxisSpacing: DesignTokens.spacing8,
      ),
      itemCount: controller.products.length,
      itemBuilder: (_, i) {
        final product = controller.products[i];
        return _ProductCard(product: product);
      },
    );
  }

  void _showSortBottomSheet(
      BuildContext context, ProductController controller) {
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
            Text(
              StringConst.sortBy,
              style: AppTextStyle.titleMedium,
            ),
            const SizedBox(height: DesignTokens.spacing8),
            _SortOption(
              label: StringConst.priceLowToHigh,
              onTap: () {
                controller.products
                    .sort((a, b) => a.price.compareTo(b.price));
                Get.back();
              },
            ),
            _SortOption(
              label: StringConst.priceHighToLow,
              onTap: () {
                controller.products
                    .sort((a, b) => b.price.compareTo(a.price));
                Get.back();
              },
            ),
            _SortOption(
              label: StringConst.newest,
              onTap: () {
                controller.products.sort((a, b) => b.id.compareTo(a.id));
                Get.back();
              },
            ),
            _SortOption(
              label: StringConst.popularity,
              onTap: () {
                controller.products.sort(
                    (a, b) => b.reviewCount.compareTo(a.reviewCount));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/product/${product.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
          boxShadow: DesignTokens.shadowSmall,
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: SmartImage.rounded(
                source: product.displayImage,
                width: double.infinity,
                borderRadius: 0,
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
                    const SizedBox(height: DesignTokens.spacing4),
                    Row(
                      children: [
                        Text(
                          '${AppConstant.currency}${product.price.toInt()}',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: ColorConst.colorFF059669,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: DesignTokens.spacing4),
                          Flexible(
                            child: Text(
                              '${AppConstant.currency}${product.mrp.toInt()}',
                              style: AppTextStyle.caption.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacing2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: ColorConst.colorFFF59E0B),
                        const SizedBox(width: DesignTokens.spacing4),
                        Text(
                          '${product.rating}',
                          style: AppTextStyle.labelSmall,
                        ),
                        Flexible(
                          child: Text(
                            ' (${product.reviewCount})',
                            style: AppTextStyle.labelSmall.copyWith(
                              color: ColorConst.colorFF6B7280,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

class _SortOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SortOption({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: AppTextStyle.bodyMedium),
      onTap: onTap,
    );
  }
}
