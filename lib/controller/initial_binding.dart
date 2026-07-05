import 'package:get/get.dart';
import 'package:portfolio/controller/theme_controller.dart';
import 'package:portfolio/features/admin/data/admin_repository.dart';
import 'package:portfolio/features/cart/controller/cart_controller.dart';
import 'package:portfolio/features/wishlist/controller/wishlist_controller.dart';
import 'package:portfolio/global/services/connectivity_service.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AdminRepository(), permanent: true);
    Get.put(ConnectivityService(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(WishlistController(), permanent: true);
    Get.lazyPut(() => ThemeController(), fenix: true);
  }
}
