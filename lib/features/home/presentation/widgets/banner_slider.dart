import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/widgets/smart_image.dart';
import 'package:portfolio/features/home/domain/banner_model.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerModel> banners;
  final RxInt currentIndex;
  final Function(BannerModel)? onBannerTap;
  final double? height;
  final bool showOverlay;
  final bool fullWidth;

  const BannerSlider({
    super.key,
    required this.banners,
    required this.currentIndex,
    this.onBannerTap,
    this.height,
    this.showOverlay = true,
    this.fullWidth = false,
  });

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  late PageController _pageController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients && widget.banners.length > 1) {
        final next = (widget.currentIndex.value + 1) % widget.banners.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bannerHeight = widget.height ??
            (constraints.maxHeight.isFinite
                ? constraints.maxHeight - 20
                : 180);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: bannerHeight.clamp(120.0, 500.0),
              child: PageView.builder(
                controller: _pageController,
                padEnds: !widget.fullWidth,
                onPageChanged: (index) =>
                    widget.currentIndex.value = index,
                itemCount: widget.banners.length,
                itemBuilder: (context, index) {
                  final banner = widget.banners[index];
                  final hPad =
                      widget.fullWidth ? 0.0 : DesignTokens.spacing8;
                  final radius =
                      widget.fullWidth ? 0.0 : DesignTokens.radius12;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: GestureDetector(
                      onTap: () => widget.onBannerTap?.call(banner),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          boxShadow: widget.fullWidth
                              ? null
                              : DesignTokens.shadowMedium,
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            SmartImage.rounded(
                              source: banner.image,
                              width: double.infinity,
                              borderRadius: radius,
                            ),
                            if (widget.showOverlay) ...[
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      ColorConst.transparent,
                                      ColorConst.colorFF000000
                                          .withValues(alpha: 0.6),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: DesignTokens.spacing16,
                                right: DesignTokens.spacing16,
                                bottom: DesignTokens.spacing16,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    if (banner.title.isNotEmpty)
                                      Text(
                                        banner.title,
                                        style: AppTextStyle.titleMedium
                                            .copyWith(
                                                color: ColorConst.white),
                                      ),
                                    if (banner.subtitle.isNotEmpty) ...[
                                      const SizedBox(
                                          height: DesignTokens.spacing4),
                                      Text(
                                        banner.subtitle,
                                        style: AppTextStyle.bodySmall
                                            .copyWith(
                                          color: ColorConst.white
                                              .withValues(alpha: 0.9),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (!widget.fullWidth) ...[
              const SizedBox(height: DesignTokens.spacing8),
              Obx(() => widget.banners.length > 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.banners.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacing4),
                          width: widget.currentIndex.value == index
                              ? 20
                              : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                DesignTokens.radiusCircular),
                            color: widget.currentIndex.value == index
                                ? ColorConst.primaryColor
                                : ColorConst.colorFF9E9E9E,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          ],
        );
      },
    );
  }
}
