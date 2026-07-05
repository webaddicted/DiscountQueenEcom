import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/assets_const.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/smart_image.dart';

class MainShellAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onCartTap;
  final int cartCount;

  const MainShellAppBar({
    super.key,
    required this.onMenuTap,
    required this.onNotificationTap,
    required this.onCartTap,
    this.cartCount = 0,
  });

  static const double _sideWidth = 96;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.white,
        boxShadow: [
          BoxShadow(
            color: ColorConst.colorFF000000.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: kToolbarHeight,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                SizedBox(
                  width: _sideWidth,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: onMenuTap,
                      icon: const Icon(Icons.menu, size: 24),
                      color: ColorConst.colorFF4B5563,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SmartImage.rounded(
                          source: AssetsConst.logoImg,
                          width: 28,
                          height: 28,
                          borderRadius: 6,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            AppConstant.appName,
                            style: AppTextStyle.titleMedium.copyWith(
                              color: ColorConst.primaryColor,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: _sideWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: onNotificationTap,
                        icon: const Icon(
                          Icons.notifications_outlined,
                          size: 22,
                        ),
                        color: ColorConst.colorFF4B5563,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: onCartTap,
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              size: 22,
                            ),
                            color: ColorConst.colorFF4B5563,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          if (cartCount > 0)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: ColorConst.colorFFEF4444,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  cartCount > 99 ? '99+' : '$cartCount',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.overline.copyWith(
                                    color: ColorConst.white,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
