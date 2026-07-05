import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/cart/controller/cart_controller.dart';
import 'package:portfolio/features/home/controller/home_controller.dart';
import 'package:portfolio/features/main/controller/categories_controller.dart';
import 'package:portfolio/features/profile/controller/profile_controller.dart';
import 'package:portfolio/features/wishlist/controller/wishlist_controller.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/utils/web_url_helper.dart';

class MainController extends BaseController {
  final currentIndex = 0.obs;
  final isWebSideMenuOpen = false.obs;
  final tabRevision = 0.obs;
  final _drawerCallbacks = <VoidCallback>{};
  final _loadedTabs = <int>{};

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
    loadTabData(currentIndex.value);
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
          changeTab(idx);
        }
      });
    }
  }

  void changeTab(int index) {
    if (index == currentIndex.value) return;
    currentIndex.value = index;
    loadTabData(index);
    if (kIsWeb) {
      WebUrlHelper.pushUrl(RoutersConst.tabRoutes[index]);
    }
  }

  /// Loads APIs only for the active tab (first visit per session).
  void loadTabData(int index) {
    if (index < 0 || index >= _titles.length) return;
    if (_loadedTabs.contains(index)) return;
    _loadedTabs.add(index);

    switch (index) {
      case 0:
        _ensureHome().loadHomeData();
        break;
      case 1:
        _ensureCategories().loadCategories();
        break;
      case 2:
        _ensureCart().refreshCart();
        break;
      case 3:
        _ensureWishlist().loadWishlist();
        break;
      case 4:
        _ensureProfile().loadProfile();
        break;
    }
    tabRevision.value++;
  }

  HomeController _ensureHome() {
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController(), permanent: true);
    }
    return Get.find<HomeController>();
  }

  CategoriesController _ensureCategories() {
    if (!Get.isRegistered<CategoriesController>()) {
      Get.put(CategoriesController(), permanent: true);
    }
    return Get.find<CategoriesController>();
  }

  CartController _ensureCart() {
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(), permanent: true);
    }
    return Get.find<CartController>();
  }

  WishlistController _ensureWishlist() {
    if (!Get.isRegistered<WishlistController>()) {
      Get.put(WishlistController(), permanent: true);
    }
    return Get.find<WishlistController>();
  }

  ProfileController _ensureProfile() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController(), permanent: true);
    }
    return Get.find<ProfileController>();
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
        changeTab(index);
      } else {
        loadTabData(index);
      }
      if (kIsWeb) {
        WebUrlHelper.replaceUrl(target);
      }
      return;
    }

    Get.offAllNamed(target);
  }
}
