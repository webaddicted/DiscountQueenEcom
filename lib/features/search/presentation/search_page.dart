import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:portfolio/features/search/controller/shop_search_controller.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/empty_widget.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/features/product/domain/product_model.dart';

class SearchPage extends BaseStatelessWidget {
  const SearchPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.find<ShopSearchController>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _SearchBar(controller: controller),
            Expanded(
              child: Obx(() {
                if (controller.searchQuery.value.isNotEmpty) {
                  if (controller.searchResults.isEmpty) {
                    return const EmptyWidget(
                      message: StringConst.noResults,
                      icon: Icons.search_off_outlined,
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(DesignTokens.spacing8),
                    itemCount: controller.searchResults.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: DesignTokens.spacing8),
                    itemBuilder: (_, i) => _SearchResultCard(
                      product: controller.searchResults[i],
                    ),
                  );
                }
                return _EmptySearchState(controller: controller);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final ShopSearchController controller;

  const _SearchBar({required this.controller});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
    if (kDebugMode) {
      _queryController.text = 'tshirt';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.controller.search(_queryController.text);
      });
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DesignTokens.spacing8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(DesignTokens.radius12),
              ),
              child: TextField(
                controller: _queryController,
                autofocus: true,
                onChanged: widget.controller.search,
                decoration: InputDecoration(
                  hintText: StringConst.searchProducts,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: ColorConst.primaryColor,
                    size: 22,
                  ),
                  suffixIcon: Obx(() => widget.controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _queryController.clear();
                            widget.controller.clearSearch();
                          },
                        )
                      : const SizedBox.shrink()),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing16,
                    vertical: DesignTokens.spacing12,
                  ),
                ),
                style: AppTextStyle.bodyMedium,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacing8),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              StringConst.cancel,
              style: AppTextStyle.labelMedium.copyWith(
                color: ColorConst.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final ShopSearchController controller;

  const _EmptySearchState({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacing8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringConst.recentSearches,
                  style: AppTextStyle.titleMedium,
                ),
                TextButton(
                  onPressed: controller.clearRecentSearches,
                  child: Text(
                    StringConst.clearAll,
                    style: AppTextStyle.labelMedium.copyWith(
                      color: ColorConst.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacing8),
            Wrap(
              spacing: DesignTokens.spacing8,
              runSpacing: DesignTokens.spacing8,
              children: controller.recentSearches
                  .map((q) => _SearchChip(
                        label: q,
                        onTap: () => controller.search(q),
                        onClear: () => controller.removeRecentSearch(q),
                      ))
                  .toList(),
            ),
            const SizedBox(height: DesignTokens.spacing24),
          ],
          Text(
            StringConst.trendingSearches,
            style: AppTextStyle.titleMedium,
          ),
          const SizedBox(height: DesignTokens.spacing8),
          Wrap(
            spacing: DesignTokens.spacing8,
            runSpacing: DesignTokens.spacing8,
            children: controller.trendingSearches
                .map((q) => _TrendingChip(
                      label: q,
                      onTap: () => controller.search(q),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _SearchChip({
    required this.label,
    required this.onTap,
    required this.onClear,
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(DesignTokens.radiusCircular),
          boxShadow: DesignTokens.shadowSmall,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: DesignTokens.spacing8),
            Text(label, style: AppTextStyle.bodyMedium),
            const SizedBox(width: DesignTokens.spacing4),
            GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close, size: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TrendingChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing16,
          vertical: DesignTokens.spacing8,
        ),
        decoration: BoxDecoration(
          gradient: DesignTokens.primaryGradient,
          borderRadius: BorderRadius.circular(DesignTokens.radiusCircular),
          boxShadow: DesignTokens.shadowSmall,
        ),
        child: Text(
          label,
          style: AppTextStyle.labelMedium.copyWith(
            color: ColorConst.white,
          ),
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final ProductModel product;

  const _SearchResultCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/product/${product.id}'),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacing8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
          boxShadow: DesignTokens.shadowSmall,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.radius8),
              child: SmartImage(
                source: product.displayImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: DesignTokens.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyle.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: DesignTokens.spacing4),
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
                        const SizedBox(width: DesignTokens.spacing8),
                        Text(
                          '${AppConstant.currency}${product.mrp.toStringAsFixed(0)}',
                          style: AppTextStyle.caption.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
