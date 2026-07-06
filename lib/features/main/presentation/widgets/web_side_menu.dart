import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/main/controller/main_controller.dart';
import 'package:portfolio/global/constant/assets_const.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/smart_image.dart';

class WebSideMenu extends StatelessWidget {
  final MainController controller;
  final VoidCallback? onItemTap;
  final bool inDrawer;

  const WebSideMenu({
    super.key,
    required this.controller,
    this.onItemTap,
    this.inDrawer = false,
  });

  static const _tabItems = [
    _WebMenuItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      tabIndex: 0,
    ),
    _WebMenuItem(
      icon: Icons.category_outlined,
      activeIcon: Icons.category,
      label: 'Categories',
      tabIndex: 1,
    ),
    _WebMenuItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: 'Cart',
      tabIndex: 2,
    ),
    _WebMenuItem(
      icon: Icons.favorite_border,
      activeIcon: Icons.favorite,
      label: 'Wishlist',
      tabIndex: 3,
    ),
    _WebMenuItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      tabIndex: 4,
    ),
  ];

  static const _linkItems = [
    _WebMenuLink(
      icon: Icons.receipt_long_outlined,
      label: StringConst.myOrders,
      route: RoutersConst.orders,
    ),
    _WebMenuLink(
      icon: Icons.search,
      label: StringConst.search,
      route: RoutersConst.search,
    ),
    _WebMenuLink(
      icon: Icons.notifications_outlined,
      label: StringConst.notificationsTitle,
      route: RoutersConst.notifications,
    ),
    _WebMenuLink(
      icon: Icons.settings_outlined,
      label: StringConst.settingsTitle,
      route: RoutersConst.settings,
    ),
    _WebMenuLink(
      icon: Icons.help_outline,
      label: StringConst.helpSupportTitle,
      route: RoutersConst.helpSupport,
    ),
    _WebMenuLink(
      icon: Icons.info_outline,
      label: StringConst.aboutUsTitle,
      route: RoutersConst.aboutUs,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: inDrawer ? double.infinity : 260,
      decoration: BoxDecoration(
        color: ColorConst.white,
        border: const Border(
          right: BorderSide(color: ColorConst.colorFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConst.colorFF000000.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: ColorConst.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorConst.colorFFE5E7EB,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorConst.colorFF000000.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const ClipOval(
                    child: SmartImage(
                      source: AssetsConst.logoImg,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  StringConst.appName,
                  style: AppTextStyle.titleMedium.copyWith(
                    color: ColorConst.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: ColorConst.colorFFE5E7EB),
          Expanded(
            child: Obx(() {
              final selected = controller.currentIndex.value;
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ..._tabItems.map(
                    (item) => _WebSideMenuTile(
                      icon: selected == item.tabIndex
                          ? item.activeIcon
                          : item.icon,
                      label: item.label,
                      isActive: selected == item.tabIndex,
                      onTap: () {
                        controller.changeTab(item.tabIndex);
                        onItemTap?.call();
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Divider(height: 1, color: ColorConst.colorFFE5E7EB),
                  ),
                  ..._linkItems.map(
                    (item) => _WebSideMenuTile(
                      icon: item.icon,
                      label: item.label,
                      onTap: () {
                        Get.toNamed(item.route);
                        onItemTap?.call();
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _WebSideMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _WebSideMenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isActive
            ? ColorConst.primaryColor.withValues(alpha: 0.1)
            : ColorConst.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive
                      ? ColorConst.primaryColor
                      : ColorConst.colorFF4B5563,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontSize: 14,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? ColorConst.primaryColor
                          : ColorConst.colorFF374151,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WebMenuItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int tabIndex;

  const _WebMenuItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.tabIndex,
  });
}

class _WebMenuLink {
  final IconData icon;
  final String label;
  final String route;

  const _WebMenuLink({
    required this.icon,
    required this.label,
    required this.route,
  });
}
