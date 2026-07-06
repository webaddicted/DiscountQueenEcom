import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';

enum AppStateType { noData, noInternet, error }

class EmptyWidget extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final Widget? action;
  final String? subtitle;
  final AppStateType type;

  const EmptyWidget({
    super.key,
    this.message,
    this.icon,
    this.action,
    this.subtitle,
    this.type = AppStateType.noData,
  });

  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      type: type,
      message: message,
      subtitle: subtitle,
      icon: icon,
      action: action,
    );
  }
}

class NoDataPlaceholder extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;

  const NoDataPlaceholder({super.key, this.message, this.icon, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      type: AppStateType.noData,
      message: message,
      icon: icon,
      onRetry: onRetry,
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      type: AppStateType.error,
      message: message ?? StringConst.somethingWentWrong,
      onRetry: onRetry,
    );
  }
}

class NoInternetWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      type: AppStateType.noInternet,
      onRetry: onRetry,
    );
  }
}

class AppStateWidget extends StatelessWidget {
  final AppStateType type;
  final String? message;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onRetry;
  final Widget? action;

  const AppStateWidget({
    super.key,
    required this.type,
    this.message,
    this.subtitle,
    this.icon,
    this.onRetry,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final config = _configFor(type);
    final resolvedMessage = message ?? config.title;
    final resolvedSubtitle = subtitle ?? config.subtitle;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacing8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing8,
              vertical: DesignTokens.spacing16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: config.cardGradient,
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radius16),
              border: Border.all(color: config.borderColor),
              boxShadow: [
                BoxShadow(
                  color: config.accentColor.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StateIllustration(
                  icon: icon ?? config.icon,
                  accentColor: config.accentColor,
                  ringGradient: config.ringGradient,
                  decorColor: config.decorColor,
                ),
                const SizedBox(height: DesignTokens.spacing8),
                Text(
                  resolvedMessage,
                  style: AppTextStyle.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ColorConst.colorFF1F2937,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DesignTokens.spacing4),
                Text(
                  resolvedSubtitle,
                  style: AppTextStyle.bodyMedium.copyWith(
                    fontSize: 14,
                    color: ColorConst.colorFF6B7280,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DesignTokens.spacing8),
                _buildAction(config),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAction(_StateConfig config) {
    if (action != null) return action!;
    if (onRetry == null) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      child: GradientButton(
        onTap: onRetry!,
        colors: config.buttonGradient,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(config.retryIcon, size: 18, color: ColorConst.white),
            const SizedBox(width: DesignTokens.spacing4),
            Text(
              StringConst.retry,
              style: AppTextStyle.buttonText.copyWith(color: ColorConst.white),
            ),
          ],
        ),
      ),
    );
  }

  _StateConfig _configFor(AppStateType state) {
    switch (state) {
      case AppStateType.noInternet:
        return const _StateConfig(
          title: StringConst.noInternetConnection,
          subtitle: StringConst.noInternetSubtitle,
          icon: Icons.wifi_tethering_error_rounded,
          accentColor: ColorConst.colorFFD97706,
          decorColor: ColorConst.colorFFFFF5ED,
          borderColor: ColorConst.colorFFFEF3C7,
          cardGradient: [
            ColorConst.white,
            ColorConst.colorFFFFF5ED,
          ],
          ringGradient: [
            ColorConst.colorFFF59E0B,
            ColorConst.colorFFD97706,
          ],
          buttonGradient: [
            ColorConst.colorFFD97706,
            ColorConst.colorFFDB4437,
          ],
          retryIcon: Icons.refresh_rounded,
        );
      case AppStateType.error:
        return const _StateConfig(
          title: StringConst.somethingWentWrong,
          subtitle: StringConst.errorSubtitle,
          icon: Icons.error_outline_rounded,
          accentColor: ColorConst.colorFFDC2626,
          decorColor: ColorConst.colorFFF5F5F5,
          borderColor: ColorConst.colorFFFEF3C7,
          cardGradient: [
            ColorConst.white,
            ColorConst.colorFFF5F5F5,
          ],
          ringGradient: [
            ColorConst.colorFFEF4444,
            ColorConst.colorFFDC2626,
          ],
          buttonGradient: [
            ColorConst.colorFFEF4444,
            ColorConst.colorFFDC2626,
          ],
          retryIcon: Icons.refresh_rounded,
        );
      case AppStateType.noData:
        return const _StateConfig(
          title: StringConst.noDataFound,
          subtitle: StringConst.noDataSubtitle,
          icon: Icons.inventory_2_outlined,
          accentColor: ColorConst.primaryColor,
          decorColor: ColorConst.colorFFF0F7EE,
          borderColor: ColorConst.colorFFE5E7EB,
          cardGradient: [
            ColorConst.white,
            ColorConst.colorFFF0F7EE,
          ],
          ringGradient: [
            ColorConst.accentColor,
            ColorConst.primaryColor,
          ],
          buttonGradient: [
            ColorConst.primaryColor,
            ColorConst.secondaryColor,
          ],
          retryIcon: Icons.autorenew_rounded,
        );
    }
  }
}

class _StateIllustration extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final List<Color> ringGradient;
  final Color decorColor;

  const _StateIllustration({
    required this.icon,
    required this.accentColor,
    required this.ringGradient,
    required this.decorColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 4,
            right: 12,
            child: _decorDot(10, decorColor),
          ),
          Positioned(
            bottom: 8,
            left: 6,
            child: _decorDot(8, accentColor.withValues(alpha: 0.25)),
          ),
          Positioned(
            top: 28,
            left: 0,
            child: _decorDot(6, accentColor.withValues(alpha: 0.18)),
          ),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: ringGradient,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.28),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConst.white,
              ),
              child: Icon(icon, size: 40, color: accentColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _decorDot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StateConfig {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color decorColor;
  final Color borderColor;
  final List<Color> cardGradient;
  final List<Color> ringGradient;
  final List<Color> buttonGradient;
  final IconData retryIcon;

  const _StateConfig({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.decorColor,
    required this.borderColor,
    required this.cardGradient,
    required this.ringGradient,
    required this.buttonGradient,
    required this.retryIcon,
  });
}
