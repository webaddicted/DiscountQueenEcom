import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/theme/text_style.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool useGradientTitle;
  final Widget? bottom;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.onBack,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.useGradientTitle = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: useGradientTitle ? _buildGradientTitle() : Text(title, style: AppTextStyle.titleMedium),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      leading: showBack
          ? (leading ??
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: onBack ?? () => Navigator.pop(context),
              ))
          : leading,
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(48), child: bottom!)
          : null,
    );
  }

  Widget _buildGradientTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [ColorConst.primaryColor, ColorConst.secondaryColor],
      ).createShader(bounds),
      child: Text(title,
          style: AppTextStyle.titleMedium.copyWith(color: Colors.white)),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(bottom != null ? kToolbarHeight + 48 : kToolbarHeight);
}

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: onBack ?? () => Navigator.pop(context))
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [ColorConst.primaryColor, ColorConst.accentColor],
            ).createShader(bounds),
            child: Text(title,
                style: AppTextStyle.titleMedium.copyWith(color: Colors.white)),
          ),
          if (subtitle != null)
            Text(subtitle!, style: AppTextStyle.bodySmall.copyWith(color: Colors.grey.shade600)),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
