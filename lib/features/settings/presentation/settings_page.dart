import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/theme_controller.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';

class SettingsPage extends BaseStatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Scaffold(
      appBar: AppBarWidget(
        title: StringConst.settingsTitle,
        showBack: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(DesignTokens.spacing8),
        children: [
          _SettingsCard(
            children: [
              Obx(() => _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: StringConst.darkMode,
                    trailing: Switch(
                      value: themeController.isDark.value,
                      onChanged: (_) => themeController.toggleTheme(),
                      activeColor: ColorConst.primaryColor,
                    ),
                  )),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: StringConst.notificationsTitle,
                trailing: Switch(
                  value: true,
                  onChanged: (_) {},
                  activeColor: ColorConst.primaryColor,
                ),
              ),
              _SettingsTile(
                icon: Icons.language,
                title: StringConst.language,
                subtitle: 'English',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing16),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: StringConst.privacyPolicyTitle,
                onTap: () => Get.toNamed(RoutersConst.privacyPolicy),
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: StringConst.termsTitle,
                onTap: () => Get.toNamed(RoutersConst.termsCondition),
              ),
              _SettingsTile(
                icon: Icons.star_outline,
                title: StringConst.rateApp,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: StringConst.appVersion,
                subtitle: AppConstant.appVersion,
                showTrailing: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

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
        children: children.asMap().entries.map((e) {
          final isLast = e.key == children.length - 1;
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showTrailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 24, color: ColorConst.primaryColor),
      title: Text(title, style: AppTextStyle.bodyMedium),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyle.bodySmall.copyWith(
                color: Colors.grey.shade600,
              ),
            )
          : null,
      trailing: showTrailing
          ? (trailing ??
              (onTap != null
                  ? Icon(Icons.chevron_right, color: Colors.grey.shade400)
                  : null))
          : null,
      onTap: onTap,
    );
  }
}
