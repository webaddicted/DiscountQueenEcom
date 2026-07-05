import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/home/controller/home_controller.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/empty_widget.dart';
import 'package:portfolio/global/widgets/responsive_layout.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/features/home/domain/category_model.dart';

class CategoriesTab extends BaseStatelessWidget {
  const CategoriesTab({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.find<HomeController>();
    final w = MediaQuery.of(context).size.width;
    final cols = w >= 1200 ? 6 : w >= 900 ? 5 : w >= 600 ? 4 : 3;

    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: ColorConst.white,
      appBar: isMobile
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                StringConst.categoriesTitle,
                style: AppTextStyle.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              centerTitle: false,
              backgroundColor: ColorConst.white,
              elevation: 0,
            ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing8,
            ),
            child: GestureDetector(
              onTap: () => Get.toNamed(RoutersConst.search),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacing12,
                  vertical: DesignTokens.spacing8,
                ),
                decoration: BoxDecoration(
                  color: ColorConst.colorFFF3F4F6,
                  borderRadius:
                      BorderRadius.circular(DesignTokens.radius12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        size: 20, color: ColorConst.colorFF9CA3AF),
                    const SizedBox(width: DesignTokens.spacing8),
                    Text(
                      StringConst.searchProducts,
                      style: AppTextStyle.bodyMedium
                          .copyWith(color: ColorConst.colorFF9CA3AF),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacing8),
          Expanded(
            child: Obx(() {
              if (controller.categories.isEmpty) {
                return const EmptyWidget(
                  message: StringConst.noDataFound,
                  icon: Icons.category_outlined,
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(DesignTokens.spacing8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: DesignTokens.spacing8,
                  mainAxisSpacing: DesignTokens.spacing8,
                ),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  return _CategoryGridItem(
                    category: controller.categories[index],
                    onTap: () => controller
                        .onCategoryTap(controller.categories[index]),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const _CategoryGridItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: ColorConst.white,
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
          boxShadow: DesignTokens.shadowSmall,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: ColorConst.colorFFF3F4F6,
                child: SmartImage.rounded(
                  source: category.image,
                  width: double.infinity,
                  borderRadius: 0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing4,
                vertical: DesignTokens.spacing6,
              ),
              child: Text(
                category.name,
                style: AppTextStyle.labelMedium,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
