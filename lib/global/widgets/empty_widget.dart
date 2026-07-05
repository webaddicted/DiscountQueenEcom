import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/text_style.dart';

class EmptyWidget extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final Widget? action;
  final String? subtitle;
  final double iconSize;

  const EmptyWidget({
    super.key,
    this.message,
    this.icon,
    this.action,
    this.subtitle,
    this.iconSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon ?? Icons.inbox_outlined,
              size: iconSize, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            message ?? StringConst.noDataFound,
            style: AppTextStyle.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!,
                style: AppTextStyle.bodySmall
                    .copyWith(color: Colors.grey),
                textAlign: TextAlign.center),
          ],
          if (action != null) ...[const SizedBox(height: 8), action!],
        ]),
      ),
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
    return EmptyWidget(
      message: message ?? StringConst.noDataFound,
      icon: icon ?? Icons.search_off_outlined,
      action: onRetry != null
          ? TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(StringConst.retry))
          : null,
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      icon: Icons.error_outline,
      message: message ?? StringConst.somethingWentWrong,
      action: onRetry != null
          ? ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(StringConst.retry))
          : null,
    );
  }
}

class NoInternetWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      icon: Icons.wifi_off_outlined,
      message: StringConst.noInternetConnection,
      subtitle: 'Please check your connection and try again',
      action: onRetry != null
          ? ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(StringConst.retry))
          : null,
    );
  }
}
