import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/cart/controller/cart_controller.dart';
import 'package:portfolio/features/cart/presentation/cart_page.dart';
import 'package:portfolio/features/home/presentation/home_page.dart';
import 'package:portfolio/features/wishlist/presentation/wishlist_page.dart';
import 'package:portfolio/features/profile/presentation/profile_page.dart';
import 'package:portfolio/features/main/controller/main_controller.dart';
import 'package:portfolio/features/main/presentation/widgets/categories_tab.dart';
import 'package:portfolio/features/main/presentation/widgets/web_side_menu.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/assets_const.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/main_shell_app_bar.dart';
import 'package:portfolio/global/utils/main_tab_obx.dart';
import 'package:portfolio/global/widgets/responsive_layout.dart';
import 'package:portfolio/global/widgets/smart_image.dart';

class MainPage extends BaseStatelessWidget {
  const MainPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.isRegistered<MainController>()
        ? Get.find<MainController>()
        : Get.put(MainController(), permanent: true);

    final pages = <Widget>[
      const HomePage(),
      const CategoriesTab(),
      const CartPage(),
      const WishlistPage(),
      const ProfilePage(),
    ];

    return ResponsiveLayout(
      mobile: (_) => _buildMobileShell(context, controller, pages),
      desktop: (_) => _buildDesktopShell(context, controller, pages),
    );
  }

  Widget _buildMobileShell(
      BuildContext context, MainController controller, List<Widget> pages) {
    return _MobileMainShell(
      controller: controller,
      pages: pages,
      bottomNavigationBar: _buildBottomNav(controller),
    );
  }

  Widget _buildDesktopShell(
      BuildContext context, MainController controller, List<Widget> pages) {
    return Scaffold(
      body: Column(
        children: [
          _buildWebTopNav(controller),
          Expanded(
            child: Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRect(
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                      alignment: Alignment.centerLeft,
                      widthFactor: controller.isWebSideMenuOpen.value ? 1.0 : 0.0,
                      child: WebSideMenu(controller: controller),
                    ),
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: controller.currentIndex.value,
                      children: pages,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebTopNav(MainController controller) {
    return Obx(() {
      trackMainShellObx();
      final cartCount = Get.isRegistered<CartController>()
          ? Get.find<CartController>().totalItems
          : 0;
      final selected = controller.currentIndex.value;
      return Container(
        height: 64,
        decoration: BoxDecoration(
          color: ColorConst.white,
          boxShadow: [
            BoxShadow(
              color: ColorConst.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: LayoutBuilder(
              builder: (context, navConstraints) {
                final isCompact = navConstraints.maxWidth < 900;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacing8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: controller.toggleWebSideMenu,
                        icon: Icon(
                          controller.isWebSideMenuOpen.value
                              ? Icons.menu_open
                              : Icons.menu,
                          size: 22,
                        ),
                        color: ColorConst.colorFF4B5563,
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        padding: EdgeInsets.zero,
                        tooltip: StringConst.menu,
                      ),
                      SmartImage.circular(
                        source: AssetsConst.logoImg,
                        size: 44,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppConstant.appName,
                        style: AppTextStyle.headlineSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: ColorConst.primaryColor,
                        ),
                      ),
                      if (!isCompact) ...[
                        const SizedBox(width: 32),
                        ..._buildNavLinks(controller, selected),
                      ],
                      const Spacer(),
                      SizedBox(
                        width: isCompact ? 160 : 220,
                        height: 38,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(RoutersConst.search),
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: ColorConst.colorFFF3F4F6,
                              borderRadius: BorderRadius.circular(
                                  DesignTokens.radius8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search,
                                    size: 18,
                                    color: ColorConst.colorFF9CA3AF),
                                const SizedBox(width: 8),
                                Text(
                                  'Search...',
                                  style: AppTextStyle.bodySmall.copyWith(
                                      color: ColorConst.colorFF9CA3AF),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacing4),
                      IconButton(
                        onPressed: () =>
                            Get.toNamed(RoutersConst.notifications),
                        icon: const Icon(Icons.notifications_outlined,
                            size: 22),
                        color: ColorConst.colorFF4B5563,
                        constraints: const BoxConstraints(
                            minWidth: 40, minHeight: 40),
                        padding: EdgeInsets.zero,
                      ),
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () => controller.changeTab(2),
                            icon: const Icon(
                                Icons.shopping_cart_outlined,
                                size: 22),
                            color: ColorConst.colorFF4B5563,
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                            padding: EdgeInsets.zero,
                          ),
                          if (cartCount > 0)
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: ColorConst.colorFFEF4444,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$cartCount',
                                  style: AppTextStyle.overline.copyWith(
                                    color: ColorConst.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => controller.changeTab(4),
                        icon: const Icon(Icons.person_outline, size: 22),
                        color: ColorConst.colorFF4B5563,
                        constraints: const BoxConstraints(
                            minWidth: 40, minHeight: 40),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildNavLinks(MainController controller, int selected) {
    const labels = ['Home', 'Categories', 'Cart', 'Wishlist', 'Profile'];
    return List.generate(labels.length, (i) {
      if (i >= 3) return const SizedBox.shrink();
      final isActive = selected == i;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextButton(
          onPressed: () => controller.changeTab(i),
          style: TextButton.styleFrom(
            foregroundColor:
                isActive ? ColorConst.primaryColor : ColorConst.colorFF4B5563,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: Text(
            labels[i],
            style: AppTextStyle.bodyMedium.copyWith(
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive
                  ? ColorConst.primaryColor
                  : ColorConst.colorFF4B5563,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBottomNav(MainController controller) {
    return Obx(() {
      final cartCount = Get.isRegistered<CartController>()
          ? Get.find<CartController>().totalItems
          : 0;
      return Container(
        decoration: BoxDecoration(
          color: ColorConst.white,
          boxShadow: [
            BoxShadow(
              color: ColorConst.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: ColorConst.primaryColor,
          unselectedItemColor: ColorConst.colorFF9CA3AF,
          selectedLabelStyle: AppTextStyle.labelSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTextStyle.labelSmall,
          backgroundColor: ColorConst.white,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text(
                  '$cartCount',
                  style: AppTextStyle.overline.copyWith(
                    color: ColorConst.white,
                    fontSize: 10,
                  ),
                ),
                backgroundColor: ColorConst.colorFFE53935,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text(
                  '$cartCount',
                  style: AppTextStyle.overline.copyWith(
                    color: ColorConst.white,
                    fontSize: 10,
                  ),
                ),
                backgroundColor: ColorConst.colorFFE53935,
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}

class _MobileMainShell extends StatefulWidget {
  const _MobileMainShell({
    required this.controller,
    required this.pages,
    required this.bottomNavigationBar,
  });

  final MainController controller;
  final List<Widget> pages;
  final Widget bottomNavigationBar;

  @override
  State<_MobileMainShell> createState() => _MobileMainShellState();
}

class _MobileMainShellState extends State<_MobileMainShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    widget.controller.bindDrawer(_openDrawer);
  }

  @override
  void dispose() {
    widget.controller.unbindDrawer(_openDrawer);
    super.dispose();
  }

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: 280,
        child: WebSideMenu(
          controller: widget.controller,
          inDrawer: true,
          onItemTap: () => Navigator.pop(context),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          trackMainShellObx();
          final cartCount = Get.isRegistered<CartController>()
              ? Get.find<CartController>().totalItems
              : 0;
          return MainShellAppBar(
            onMenuTap: widget.controller.openMobileDrawer,
            onNotificationTap: () => Get.toNamed(RoutersConst.notifications),
            onCartTap: () => widget.controller.navigateToTab(2),
            cartCount: cartCount,
          );
        }),
      ),
      body: Obx(
        () => IndexedStack(
          index: widget.controller.currentIndex.value,
          children: widget.pages,
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
