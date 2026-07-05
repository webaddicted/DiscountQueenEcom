import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/text_style.dart';

void showConfirmDialog({
  required String title,
  required String message,
  String positiveText = 'Confirm',
  String negativeText = 'Cancel',
  VoidCallback? onPositive,
  VoidCallback? onNegative,
  bool isDismissible = true,
}) {
  Get.dialog(
    AlertDialog(
      title: Text(title, style: AppTextStyle.titleMedium),
      content: Text(message, style: AppTextStyle.bodyMedium),
      actions: [
        TextButton(
            onPressed: onNegative ?? () => Get.back(),
            child: Text(negativeText)),
        ElevatedButton(
            onPressed: () {
              Get.back();
              onPositive?.call();
            },
            child: Text(positiveText)),
      ],
    ),
    barrierDismissible: isDismissible,
  );
}

void showPermissionDialog({
  required String message,
  required VoidCallback onOpenSettings,
  bool isDismissible = true,
}) {
  Get.dialog(
    AlertDialog(
      title:
          Text(StringConst.permissionRequired, style: AppTextStyle.titleMedium),
      content: Text(message, style: AppTextStyle.bodyMedium),
      actions: [
        TextButton(
            onPressed: () => Get.back(),
            child: const Text(StringConst.cancel)),
        ElevatedButton(
            onPressed: () {
              Get.back();
              onOpenSettings();
            },
            child: const Text('Open Settings')),
      ],
    ),
    barrierDismissible: isDismissible,
  );
}

void showLoadingDialog({String message = 'Loading...'}) {
  Get.dialog(
    PopScope(
      canPop: false,
      child: Center(child: CircularProgressIndicator()),
    ),
    barrierDismissible: false,
  );
}

void hideLoadingDialog() {
  if (Get.isDialogOpen ?? false) Get.back();
}

void showBottomSheet({required Widget child, bool isDismissible = true}) {
  Get.bottomSheet(child,
      isDismissible: isDismissible, backgroundColor: Colors.transparent);
}
