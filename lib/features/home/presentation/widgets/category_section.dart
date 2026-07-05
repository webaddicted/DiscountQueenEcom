import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/features/home/domain/category_model.dart';
import 'package:portfolio/features/home/presentation/widgets/section_header.dart';

class CategorySection extends StatelessWidget {
  final List<CategoryModel> categories;
  final VoidCallback? onViewAll;
  final Function(CategoryModel) onCategoryTap;
  final bool isWeb;
  final bool useGrid;

  const CategorySection({
    super.key,
    required this.categories,
    this.onViewAll,
    required this.onCategoryTap,
    this.isWeb = false,
    this.useGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: StringConst.shopByCategory,
          onViewAll: onViewAll,
        ),
        if (useGrid)
          _buildGrid()
        else
          _buildHorizontalList(),
      ],
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacing8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.8,
          crossAxisSpacing: DesignTokens.spacing8,
          mainAxisSpacing: DesignTokens.spacing8,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => onCategoryTap(category),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConst.colorFFF3F4F6,
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radius12),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: SmartImage.rounded(
                      source: category.image,
                      width: double.infinity,
                      borderRadius: DesignTokens.radius12,
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing4),
                Text(
                  category.name,
                  style: AppTextStyle.labelSmall,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalList() {
    return SizedBox(
      height: isWeb ? 100 : 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: DesignTokens.spacing8),
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(
          width: isWeb ? DesignTokens.spacing16 : DesignTokens.spacing8,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => onCategoryTap(category),
            child: SizedBox(
              width: isWeb ? 72 : 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isWeb
                          ? Border.all(
                              color: ColorConst.colorFFE5E7EB,
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: SmartImage.circular(
                      source: category.image,
                      size: isWeb ? 60 : 52,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacing6),
                  Text(
                    category.name,
                    style: isWeb
                        ? AppTextStyle.labelMedium
                        : AppTextStyle.labelSmall,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
