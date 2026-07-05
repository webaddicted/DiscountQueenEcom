import 'package:get/get.dart';
import 'package:portfolio/features/auth/data/auth_repository.dart';
import 'package:portfolio/controller/theme_controller.dart';
import 'package:portfolio/features/admin/data/admin_repository.dart';
import 'package:portfolio/features/cart/data/cart_repository.dart';
import 'package:portfolio/features/home/data/catalog_repository.dart';
import 'package:portfolio/features/notifications/data/notification_repository.dart';
import 'package:portfolio/features/orders/data/order_repository.dart';
import 'package:portfolio/features/profile/data/user_repository.dart';
import 'package:portfolio/features/wishlist/data/wishlist_repository.dart';
import 'package:portfolio/global/services/connectivity_service.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository(), permanent: true);
    Get.put(CatalogRepository(), permanent: true);
    Get.put(UserRepository(), permanent: true);
    Get.put(CartRepository(), permanent: true);
    Get.put(WishlistRepository(), permanent: true);
    Get.put(OrderRepository(), permanent: true);
    Get.put(NotificationRepository(), permanent: true);
    Get.put(AdminRepository(), permanent: true);
    Get.put(ConnectivityService(), permanent: true);
    Get.lazyPut(() => ThemeController(), fenix: true);
  }
}
