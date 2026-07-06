import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/home/controller/home_controller.dart';
import 'package:portfolio/features/main/controller/main_controller.dart';
import 'package:portfolio/features/home/presentation/widgets/banner_slider.dart';
import 'package:portfolio/features/home/presentation/widgets/product_card.dart';
import 'package:portfolio/features/home/presentation/widgets/section_header.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/utils/main_tab_obx.dart';
import 'package:portfolio/global/widgets/empty_widget.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';
import 'package:portfolio/global/widgets/responsive_layout.dart';
import 'package:portfolio/global/widgets/shimmer_widget.dart';
import 'package:portfolio/global/widgets/smart_image.dart';

class HomePage extends BaseStatelessWidget {
  const HomePage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.white,
      body: SafeArea(
        top: !ResponsiveLayout.isMobile(context),
        child: Obx(() {
          trackMainShellObx();
          if (!Get.isRegistered<HomeController>()) {
            return _buildLoadingState();
          }
          final controller = Get.find<HomeController>();
          if (controller.isLoadingRx.value && controller.banners.isEmpty) {
            return _buildLoadingState();
          }
          if (controller.isErrorRx.value) {
            return _buildErrorState(controller);
          }
          if (controller.isLoadedRx.value && !controller.hasAnyContent) {
            return _buildEmptyState(controller);
          }
          return RefreshIndicator(
            onRefresh: controller.loadData,
            color: ColorConst.primaryColor,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 600;
                final cols = ResponsiveLayout.gridColumns(context);
                if (isWide) {
                  return _buildWebContent(controller, cols);
                }
                return _buildMobileContent(controller, cols);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWebContent(HomeController controller, int cols) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (controller.banners.isNotEmpty) _buildHeroBanner(controller),

          _buildWebColoredSection(
            color: ColorConst.white,
            child: _HomeCategoriesPrompt(onTap: controller.onViewAllCategories),
          ),

          if (controller.banners.length >= 2)
            _buildWebColoredSection(
              color: ColorConst.colorFFF0F7EE,
              child: _buildPromoBanners(controller),
            ),

          if (controller.featuredProducts.isNotEmpty)
            _buildWebColoredSection(
              color: ColorConst.colorFFFBF7F0,
              child: _buildProductGridSection(
                controller,
                StringConst.featuredProducts,
                controller.featuredProducts,
                controller.onViewAllFeatured,
                cols,
              ),
            ),

          if (controller.banners.isNotEmpty) _buildWebDiscountBanner(controller),

          if (controller.popularProducts.isNotEmpty)
            _buildWebColoredSection(
              color: ColorConst.white,
              child: _buildProductGridSection(
                controller,
                StringConst.popularProducts,
                controller.popularProducts,
                controller.onViewAllPopular,
                cols,
              ),
            ),

          if (controller.newArrivals.isNotEmpty)
            _buildWebColoredSection(
              color: ColorConst.colorFFFBF7F0,
              child: _buildProductGridSection(
                controller,
                StringConst.newArrivals,
                controller.newArrivals,
                controller.onViewAllNewArrivals,
                cols,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebColoredSection({
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacing24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: DesignTokens.spacing8),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(HomeController controller) {
    return SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          BannerSlider(
            banners: controller.banners,
            currentIndex: controller.currentBannerIndex,
            height: 300,
            showOverlay: false,
            fullWidth: true,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  ColorConst.black.withValues(alpha: 0.75),
                  ColorConst.black.withValues(alpha: 0.3),
                  ColorConst.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing32),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 460,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Best products\nfor your little one',
                          style: AppTextStyle.displayMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            color: ColorConst.white,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacing12),
                        Text(
                          AppConstant.appDescription,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: ColorConst.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacing24),
                        Row(
                          children: [
                            SizedBox(
                              width: 160,
                              child: GradientButton(
                                onTap: controller.onViewAllFeatured,
                                child: Text(
                                  'Shop Now',
                                  style: AppTextStyle.buttonText
                                      .copyWith(color: ColorConst.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: DesignTokens.spacing8),
                            _buildWebMenuCta(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebMenuCta() {
    final mainController = Get.find<MainController>();
    return Obx(
      () => GestureDetector(
        onTap: mainController.toggleWebSideMenu,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: mainController.isWebSideMenuOpen.value
                ? ColorConst.white
                : ColorConst.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(DesignTokens.radius8),
            border: Border.all(
              color: ColorConst.white.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                mainController.isWebSideMenuOpen.value
                    ? Icons.menu_open
                    : Icons.menu,
                size: 18,
                color: mainController.isWebSideMenuOpen.value
                    ? ColorConst.primaryColor
                    : ColorConst.white,
              ),
              const SizedBox(width: 8),
              Text(
                mainController.isWebSideMenuOpen.value
                    ? StringConst.close
                    : StringConst.menu,
                style: AppTextStyle.buttonText.copyWith(
                  color: mainController.isWebSideMenuOpen.value
                      ? ColorConst.primaryColor
                      : ColorConst.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanners(HomeController controller) {
    return Obx(() {
      if (controller.banners.length < 2) return const SizedBox.shrink();
      return Row(
        children: [
          Expanded(
            child: _buildPromoCard(
              badge: 'Flat 20% Discount',
              title: 'Purely Fresh\nVegetables',
              bgColor: ColorConst.colorFFF0F7EE,
              badgeColor: ColorConst.primaryColor,
              imageUrl: controller.banners[0].image,
              onTap: controller.onViewAllFeatured,
            ),
          ),
          const SizedBox(width: DesignTokens.spacing12),
          Expanded(
            child: _buildPromoCard(
              badge: 'Flat 25% Discount',
              title: 'Fresh Fruits,\nPure Quality',
              bgColor: ColorConst.colorFFFFF5ED,
              badgeColor: const Color(0xFFE67E22),
              imageUrl: controller.banners.length > 1
                  ? controller.banners[1].image
                  : '',
              onTap: controller.onViewAllNewArrivals,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPromoCard({
    required String badge,
    required String title,
    required Color bgColor,
    required Color badgeColor,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing6,
                        vertical: DesignTokens.spacing2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.15),
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radius4),
                      ),
                      child: Text(
                        badge,
                        style: AppTextStyle.labelSmall.copyWith(
                          color: badgeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing8),
                    Text(
                      title,
                      style: AppTextStyle.titleMedium.copyWith(
                        color: ColorConst.colorFF1F2937,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing12,
                        vertical: DesignTokens.spacing6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConst.primaryColor,
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radius4),
                      ),
                      child: Text(
                        'Shop Now',
                        style: AppTextStyle.labelSmall.copyWith(
                          color: ColorConst.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spacing8),
                child: SmartImage.rounded(
                  source: imageUrl,
                  width: double.infinity,
                  borderRadius: DesignTokens.radius8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGridSection(
    HomeController controller,
    String title,
    RxList products,
    VoidCallback onViewAll,
    int cols,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, onViewAll: onViewAll),
        Obx(() {
          if (products.isEmpty) {
            if (controller.isLoadingRx.value) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  childAspectRatio: 0.78,
                  crossAxisSpacing: DesignTokens.spacing8,
                  mainAxisSpacing: DesignTokens.spacing8,
                ),
                itemCount: cols,
                itemBuilder: (_, _) => const ShimmerBox(height: 200),
              );
            }
            return const SizedBox.shrink();
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: 0.78,
              crossAxisSpacing: DesignTokens.spacing8,
              mainAxisSpacing: DesignTokens.spacing8,
            ),
            itemCount: products.length > cols * 2
                ? cols * 2
                : products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                layout: ProductCardLayout.grid,
                onTap: () => controller.onProductTap(product),
                onAddToCart: () {},
                onWishlistTap: () {},
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildWebDiscountBanner(HomeController controller) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1B4332),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing16,
              vertical: DesignTokens.spacing24,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Obx(() {
                    final hasImage = controller.banners.isNotEmpty;
                    return hasImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                                DesignTokens.radius12),
                            child: SizedBox(
                              height: 200,
                              child: SmartImage.rounded(
                                source: controller.banners.first.image,
                                width: double.infinity,
                                borderRadius: DesignTokens.radius12,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  }),
                ),
                const SizedBox(width: DesignTokens.spacing24),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Summer Discount',
                        style: AppTextStyle.headlineMedium.copyWith(
                          color: ColorConst.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacing4),
                      Text(
                        'Get flat 40% off. Limited Time Offer!',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: ColorConst.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacing16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCountdownUnit('04', 'Days'),
                          _buildCountdownDivider(),
                          _buildCountdownUnit('14', 'Hours'),
                          _buildCountdownDivider(),
                          _buildCountdownUnit('48', 'Minutes'),
                          _buildCountdownDivider(),
                          _buildCountdownUnit('18', 'Seconds'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownUnit(String value, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          padding: const EdgeInsets.symmetric(
            vertical: DesignTokens.spacing8,
          ),
          decoration: BoxDecoration(
            color: ColorConst.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(DesignTokens.radius8),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: AppTextStyle.headlineSmall.copyWith(
              color: ColorConst.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacing4),
        Text(
          label,
          style: AppTextStyle.labelSmall.copyWith(
            color: ColorConst.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacing8),
      child: Text(
        ':',
        style: AppTextStyle.headlineSmall.copyWith(
          color: ColorConst.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ---- MOBILE LAYOUT ----

  Widget _buildMobileContent(HomeController controller, int cols) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        _buildSearchBar(controller),
        const SliverToBoxAdapter(
            child: SizedBox(height: DesignTokens.spacing8)),
        if (controller.banners.isNotEmpty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: BannerSlider(
                banners: controller.banners,
                currentIndex: controller.currentBannerIndex,
                height: 140,
              ),
            ),
          ),
        if (controller.banners.isNotEmpty)
          const SliverToBoxAdapter(
              child: SizedBox(height: DesignTokens.spacing12)),
        SliverToBoxAdapter(
          child: _HomeCategoriesPrompt(onTap: controller.onViewAllCategories),
        ),
        if (controller.featuredProducts.isNotEmpty) ...[
          const SliverToBoxAdapter(
              child: SizedBox(height: DesignTokens.spacing12)),
          _buildMobileFeaturedSection(controller),
        ],
        if (controller.popularProducts.isNotEmpty) ...[
          const SliverToBoxAdapter(
              child: SizedBox(height: DesignTokens.spacing12)),
          _buildMobilePopularSection(controller, cols),
        ],
        if (controller.newArrivals.isNotEmpty) ...[
          const SliverToBoxAdapter(
              child: SizedBox(height: DesignTokens.spacing12)),
          _buildMobileNewArrivalsSection(controller),
        ],
        const SliverToBoxAdapter(
            child: SizedBox(height: DesignTokens.spacing16)),
      ],
    );
  }

  Widget _buildSearchBar(HomeController controller) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacing8),
        child: GestureDetector(
          onTap: controller.onSearchTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing16,
              vertical: DesignTokens.spacing12,
            ),
            decoration: BoxDecoration(
              color: ColorConst.colorFFF3F4F6,
              borderRadius: BorderRadius.circular(DesignTokens.radius12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search,
                    size: 22, color: ColorConst.colorFF6B7280),
                const SizedBox(width: DesignTokens.spacing12),
                Text(
                  StringConst.searchProducts,
                  style: AppTextStyle.bodyMedium
                      .copyWith(color: ColorConst.colorFF6B7280),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileFeaturedSection(HomeController controller) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: StringConst.featuredProducts,
            onViewAll: controller.onViewAllFeatured,
          ),
          SizedBox(
            height: 220,
            child: Obx(() {
              final products = controller.featuredProducts;
              if (products.isEmpty) {
                if (controller.isLoadingRx.value) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing8),
                    itemCount: 3,
                    itemBuilder: (_, _) => const Padding(
                      padding: EdgeInsets.only(right: DesignTokens.spacing12),
                      child: ShimmerBox(width: 140, height: 220),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing8),
                itemCount: products.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: DesignTokens.spacing12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return SizedBox(
                    width: 140,
                    child: ProductCard(
                      product: product,
                      layout: ProductCardLayout.grid,
                      onTap: () => controller.onProductTap(product),
                      onAddToCart: () {},
                      onWishlistTap: () {},
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePopularSection(HomeController controller, int cols) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: StringConst.popularProducts,
            onViewAll: controller.onViewAllPopular,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: DesignTokens.spacing8),
            child: Obx(() {
              final products = controller.popularProducts;
              if (products.isEmpty) {
                if (controller.isLoadingRx.value) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: DesignTokens.spacing8,
                      mainAxisSpacing: DesignTokens.spacing8,
                    ),
                    itemCount: cols * 2,
                    itemBuilder: (_, _) => const ShimmerBox(height: 180),
                  );
                }
                return const SizedBox.shrink();
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: DesignTokens.spacing12,
                  mainAxisSpacing: DesignTokens.spacing12,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    layout: ProductCardLayout.grid,
                    onTap: () => controller.onProductTap(product),
                    onAddToCart: () {},
                    onWishlistTap: () {},
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNewArrivalsSection(HomeController controller) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: StringConst.newArrivals,
            onViewAll: controller.onViewAllNewArrivals,
          ),
          SizedBox(
            height: 110,
            child: Obx(() {
              final products = controller.newArrivals;
              if (products.isEmpty) {
                if (controller.isLoadingRx.value) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing8),
                    itemCount: 3,
                    itemBuilder: (_, _) => const Padding(
                      padding: EdgeInsets.only(right: DesignTokens.spacing12),
                      child: ShimmerBox(width: 240, height: 110),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing8),
                itemCount: products.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: DesignTokens.spacing12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return SizedBox(
                    width: 240,
                    child: ProductCard(
                      product: product,
                      layout: ProductCardLayout.horizontal,
                      onTap: () => controller.onProductTap(product),
                      onAddToCart: () {},
                      onWishlistTap: () {},
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spacing8),
      children: const [
        ShimmerBox(height: 48),
        SizedBox(height: DesignTokens.spacing16),
        ShimmerBox(height: 180),
        SizedBox(height: DesignTokens.spacing24),
        ShimmerBox(height: 100),
        SizedBox(height: DesignTokens.spacing24),
        ShimmerBox(height: 200),
      ],
    );
  }

  Widget _buildErrorState(HomeController controller) {
    final message = controller.errorMessageRx.value;
    final isOffline = message.toLowerCase().contains('internet') ||
        message.toLowerCase().contains('connection');

    if (isOffline) {
      return NoInternetWidget(onRetry: controller.loadData);
    }

    return EmptyWidget(
      type: AppStateType.error,
      message: message,
      action: GradientButton(
        onTap: controller.loadData,
        child: Text(
          StringConst.retry,
          style: AppTextStyle.buttonText.copyWith(color: ColorConst.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState(HomeController controller) {
    return EmptyWidget(
      type: AppStateType.noData,
      action: GradientButton(
        onTap: controller.loadData,
        child: Text(
          StringConst.retry,
          style: AppTextStyle.buttonText.copyWith(color: ColorConst.white),
        ),
      ),
    );
  }
}

class _HomeCategoriesPrompt extends StatelessWidget {
  final VoidCallback onTap;

  const _HomeCategoriesPrompt({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacing8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacing8),
          decoration: BoxDecoration(
            color: ColorConst.colorFFF3F4F6,
            borderRadius: BorderRadius.circular(DesignTokens.radius12),
          ),
          child: Row(
            children: [
              const Icon(Icons.category_outlined,
                  color: ColorConst.primaryColor),
              const SizedBox(width: DesignTokens.spacing8),
              Expanded(
                child: Text(
                  StringConst.categoriesTitle,
                  style: AppTextStyle.titleMedium,
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: ColorConst.colorFF9CA3AF),
            ],
          ),
        ),
      ),
    );
  }
}
