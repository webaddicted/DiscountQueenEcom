import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType { success, error, warning, info }

void showSnackbar(String message,
    {String? title,
    SnackbarType type = SnackbarType.info,
    Duration? duration}) {
  final config = _getConfig(type);
  Get.snackbar(
    title ?? config.title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: config.backgroundColor,
    colorText: config.textColor,
    duration: duration ?? const Duration(seconds: 3),
    margin: const EdgeInsets.all(8),
    borderRadius: 8,
    icon: Icon(config.icon, color: config.textColor),
  );
}

void showSuccess(String message, {String? title}) =>
    showSnackbar(message, title: title, type: SnackbarType.success);
void showError(String message, {String? title}) =>
    showSnackbar(message, title: title, type: SnackbarType.error);
void showWarning(String message, {String? title}) =>
    showSnackbar(message, title: title, type: SnackbarType.warning);
void showInfo(String message, {String? title}) =>
    showSnackbar(message, title: title, type: SnackbarType.info);

class _SnackConfig {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  const _SnackConfig(this.title, this.backgroundColor, this.textColor, this.icon);
}

_SnackConfig _getConfig(SnackbarType type) {
  switch (type) {
    case SnackbarType.success:
      return const _SnackConfig(
          'Success', Color(0xFF43A047), Colors.white, Icons.check_circle);
    case SnackbarType.error:
      return const _SnackConfig(
          'Error', Color(0xFFE53935), Colors.white, Icons.error);
    case SnackbarType.warning:
      return const _SnackConfig(
          'Warning', Color(0xFFFFA000), Colors.white, Icons.warning);
    case SnackbarType.info:
      return const _SnackConfig(
          'Info', Color(0xFF1976D2), Colors.white, Icons.info);
  }
}
