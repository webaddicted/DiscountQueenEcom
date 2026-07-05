import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/main/controller/main_controller.dart';
import 'package:portfolio/features/profile/controller/profile_controller.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/utils/dialog_utils.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';
import 'package:portfolio/global/widgets/responsive_layout.dart';
import 'package:portfolio/global/widgets/smart_image.dart';

class ProfilePage extends BaseStatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Scaffold(
      appBar: ResponsiveLayout.isMobile(context)
          ? null
          : const AppBarWidget(
              title: StringConst.profileTitle,
              showBack: false,
            ),
      body: Obx(() {
        final u = controller.user.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacing8),
          child: Column(
            children: [
              _ProfileHeader(user: u),
              const SizedBox(height: DesignTokens.spacing16),
              _MenuCard(
                items: [
                  if (SPManager.isLoggedIn() && SPManager.isUserAdmin())
                    _MenuItem(
                      icon: Icons.admin_panel_settings_outlined,
                      title: StringConst.adminStoreTitle,
                      onTap: () => Get.toNamed(RoutersConst.admin),
                    ),
                  _MenuItem(
                    icon: Icons.receipt_long_outlined,
                    title: StringConst.myOrders,
                    onTap: () => Get.toNamed(RoutersConst.orders),
                  ),
                  _MenuItem(
                    icon: Icons.favorite_outline,
                    title: StringConst.wishlistTitle,
                    onTap: () {
                      if (Get.isRegistered<MainController>()) {
                        Get.find<MainController>().navigateToTab(3);
                      } else {
                        Get.offAllNamed(RoutersConst.wishlist);
                      }
                    },
                  ),
                  _MenuItem(
                    icon: Icons.location_on_outlined,
                    title: StringConst.addressTitle,
                    onTap: () => Get.toNamed(RoutersConst.addressList),
                  ),
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    title: StringConst.notificationsTitle,
                    onTap: () => Get.toNamed(RoutersConst.notifications),
                  ),
                  _MenuItem(
                    icon: Icons.settings_outlined,
                    title: StringConst.settingsTitle,
                    onTap: () => Get.toNamed(RoutersConst.settings),
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: StringConst.helpSupportTitle,
                    onTap: () => Get.toNamed(RoutersConst.helpSupport),
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    title: StringConst.aboutUsTitle,
                    onTap: () => Get.toNamed(RoutersConst.aboutUs),
                  ),
                  _MenuItem(
                    icon: Icons.share_outlined,
                    title: StringConst.shareApp,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing16),
              _MenuCard(
                items: [
                  _MenuItem(
                    icon: Icons.logout,
                    title: StringConst.logout,
                    onTap: () => _showLogoutDialog(),
                    isDestructive: true,
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing24),
            ],
          ),
        );
      }),
    );
  }

  void _showLogoutDialog() {
    showConfirmDialog(
      title: StringConst.logoutConfirmTitle,
      message: StringConst.logoutConfirmMessage,
      positiveText: StringConst.logout,
      negativeText: StringConst.cancel,
      onPositive: () async {
        await SPManager.clearLoginDetails();
        Get.offAllNamed(RoutersConst.login);
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic user;

  const _ProfileHeader({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing16),
      decoration: BoxDecoration(
        gradient: DesignTokens.primaryGradient,
        borderRadius: BorderRadius.circular(DesignTokens.radius16),
        boxShadow: DesignTokens.shadowMedium,
      ),
      child: Row(
        children: [
          SmartImage.circular(
            source: user?.photoUrl ?? '',
            size: 72,
          ),
          const SizedBox(width: DesignTokens.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? '-',
                  style: AppTextStyle.headlineSmall.copyWith(
                    color: ColorConst.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing4),
                Text(
                  user?.email ?? '-',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: ColorConst.white.withValues(alpha: 0.9),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: DesignTokens.spacing8),
                TextButton.icon(
                  onPressed: () => Get.toNamed(RoutersConst.editProfile),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: ColorConst.white,
                  ),
                  label: Text(
                    StringConst.editProfileTitle,
                    style: AppTextStyle.labelMedium.copyWith(
                      color: ColorConst.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;

  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        boxShadow: DesignTokens.shadowSmall,
      ),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        clipBehavior: Clip.antiAlias,
        child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              e.value,
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 56,
                  color: Colors.grey.shade200,
                ),
            ],
          );
        }).toList(),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? ColorConst.colorFFEF4444
        : ColorConst.primaryColor;
    return ListTile(
      leading: Icon(
        icon,
        size: 24,
        color: color,
      ),
      title: Text(
        title,
        style: AppTextStyle.bodyMedium.copyWith(
          color: isDestructive ? ColorConst.colorFFEF4444 : null,
          fontWeight: isDestructive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
        size: 24,
      ),
      onTap: onTap,
    );
  }
}
