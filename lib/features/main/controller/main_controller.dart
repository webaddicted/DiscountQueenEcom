import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/utils/web_url_helper.dart';

class MainController extends BaseController {
  final currentIndex = 0.obs;
  final isWebSideMenuOpen = false.obs;
  final _drawerCallbacks = <VoidCallback>{};

  final _titles = [
    StringConst.homeTitle,
    StringConst.categoriesTitle,
    StringConst.cartTitle,
    StringConst.wishlistTitle,
    StringConst.profileTitle,
  ];

  String get currentTitle => _titles[currentIndex.value];

  @override
  void onControllerInit() {
    _syncTabFromRoute();
    _listenPopState();
  }

  void _syncTabFromRoute() {
    final route = Get.currentRoute;
    final idx = RoutersConst.tabRoutes.indexOf(route);
    if (idx >= 0) {
      currentIndex.value = idx;
    }
  }

  void _listenPopState() {
    if (kIsWeb) {
      WebUrlHelper.onPopState((path) {
        final idx = RoutersConst.tabRoutes.indexOf(path);
        if (idx >= 0 && idx != currentIndex.value) {
          currentIndex.value = idx;
        }
      });
    }
  }

  void changeTab(int index) {
    if (index == currentIndex.value) return;
    currentIndex.value = index;
    if (kIsWeb) {
      WebUrlHelper.pushUrl(RoutersConst.tabRoutes[index]);
    }
  }

  void goToCart() => changeTab(2);
  void goToHome() => changeTab(0);

  void toggleWebSideMenu() {
    isWebSideMenuOpen.value = !isWebSideMenuOpen.value;
  }

  void bindDrawer(VoidCallback openDrawer) {
    _drawerCallbacks.add(openDrawer);
  }

  void unbindDrawer(VoidCallback openDrawer) {
    _drawerCallbacks.remove(openDrawer);
  }

  void openMobileDrawer() {
    if (_drawerCallbacks.isEmpty) return;
    _drawerCallbacks.last();
  }

  /// Switch bottom tab without stacking another [MainPage] (avoids duplicate GlobalKey).
  void navigateToTab(int index) {
    if (index < 0 || index >= RoutersConst.tabRoutes.length) return;
    final target = RoutersConst.tabRoutes[index];

    if (Get.isRegistered<MainController>()) {
      final onTabShell = RoutersConst.tabRoutes.contains(Get.currentRoute) ||
          Get.currentRoute == RoutersConst.main;
      if (!onTabShell) {
        Get.until((route) {
          final name = route.settings.name;
          return name != null &&
              (RoutersConst.tabRoutes.contains(name) || name == RoutersConst.main);
        });
      }
      if (currentIndex.value != index) {
        currentIndex.value = index;
      }
      if (kIsWeb) {
        WebUrlHelper.replaceUrl(target);
      }
      return;
    }

    Get.offAllNamed(target);
  }
}
