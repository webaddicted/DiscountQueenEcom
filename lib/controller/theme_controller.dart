import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/sp/sp_manager.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  bool isDarkMode = SPManager.getTheme();
  final isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDark.value = isDarkMode;
    _applySystemUI();
  }

  void changeTheme(bool isDarkness) {
    isDarkMode = isDarkness;
    isDark.value = isDarkness;
    SPManager.setTheme(isDarkness);
    _applySystemUI();
    Get.changeThemeMode(isDarkness ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() => changeTheme(!isDarkMode);

  void _applySystemUI() {
    SystemChrome.setSystemUIOverlayStyle(isDarkMode
        ? SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent)
        : SystemUiOverlayStyle.dark
            .copyWith(statusBarColor: Colors.transparent));
  }
}
