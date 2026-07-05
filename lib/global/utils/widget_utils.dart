import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/theme/text_style.dart';

Widget verticalSpace(double height) => SizedBox(height: height);
Widget horizontalSpace(double width) => SizedBox(width: width);

Widget appDivider({Color? color, double thickness = 0.5}) =>
    Divider(color: color ?? Colors.grey.shade300, thickness: thickness);

Widget elevatedButton({
  required String title,
  required VoidCallback onPressed,
  Color? bgColor,
  Color? textColor,
  double? width,
  double? height,
  double borderRadius = 8,
  EdgeInsets? padding,
}) {
  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      child: Text(title,
          style: AppTextStyle.buttonText.copyWith(color: textColor)),
    ),
  );
}

Widget outlinedButton({
  required String title,
  required VoidCallback onPressed,
  Color? borderColor,
  Color? textColor,
  double borderRadius = 8,
}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: textColor,
      side: BorderSide(color: borderColor ?? ColorConst.primaryColor),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    ),
    child:
        Text(title, style: AppTextStyle.buttonText.copyWith(color: textColor)),
  );
}

Widget iconButton(
    {required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    double size = 24}) {
  return IconButton(
      onPressed: onPressed, icon: Icon(icon, color: color, size: size));
}

// Snackbar Helpers
void showAppSnackbar(String message,
    {String? title, Duration duration = const Duration(seconds: 3)}) {
  Get.showSnackbar(GetSnackBar(
    title: title,
    message: message,
    duration: duration,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(8),
    borderRadius: 8,
  ));
}

void showSuccessSnackbar(String message, {String title = 'Success'}) {
  Get.showSnackbar(GetSnackBar(
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green.shade700,
    icon: const Icon(Icons.check_circle, color: Colors.white),
    margin: const EdgeInsets.all(8),
    borderRadius: 8,
  ));
}

void showErrorSnackbar(String message, {String title = 'Error'}) {
  Get.showSnackbar(GetSnackBar(
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.shade700,
    icon: const Icon(Icons.error, color: Colors.white),
    margin: const EdgeInsets.all(8),
    borderRadius: 8,
  ));
}

void showWarningSnackbar(String message, {String title = 'Warning'}) {
  Get.showSnackbar(GetSnackBar(
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.orange.shade700,
    icon: const Icon(Icons.warning, color: Colors.white),
    margin: const EdgeInsets.all(8),
    borderRadius: 8,
  ));
}

void showInfoSnackbar(String message, {String title = 'Info'}) {
  Get.showSnackbar(GetSnackBar(
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.blue.shade700,
    icon: const Icon(Icons.info, color: Colors.white),
    margin: const EdgeInsets.all(8),
    borderRadius: 8,
  ));
}

bool isDarkMode() =>
    Get.context != null &&
    Theme.of(Get.context!).brightness == Brightness.dark;

Future<bool> checkInternetConnection() async {
  try {
    return true;
  } catch (_) {
    return false;
  }
}
