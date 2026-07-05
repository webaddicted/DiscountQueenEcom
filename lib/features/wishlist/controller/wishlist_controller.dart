import 'package:get/get.dart';
import 'package:portfolio/features/wishlist/data/wishlist_repository.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/features/product/domain/product_model.dart';

class WishlistController extends BaseController {
  final _wishlistRepo = Get.find<WishlistRepository>();

  final wishlistItems = <ProductModel>[].obs;

  @override
  void onControllerInit() {}

  Future<void> loadWishlist() async {
    if (!SPManager.isLoggedIn()) return;
    await executeSilently(() async {
      wishlistItems.value = await _wishlistRepo.getWishlist();
    });
  }

  Future<void> toggleWishlist(ProductModel product) async {
    if (!SPManager.isLoggedIn()) {
      Get.snackbar('Login required', 'Please login to manage wishlist');
      return;
    }
    final inList = isInWishlist(product.id);
    await executeSilently(() async {
      if (inList) {
        wishlistItems.value = await _wishlistRepo.removeFromWishlist(product.id);
      } else {
        wishlistItems.value = await _wishlistRepo.addToWishlist(product.id);
      }
    }, showErrorMessage: true);
  }

  bool isInWishlist(String productId) {
    return wishlistItems.any((p) => p.id == productId);
  }

  Future<void> removeFromWishlist(String productId) async {
    await executeSilently(() async {
      wishlistItems.value = await _wishlistRepo.removeFromWishlist(productId);
    }, showErrorMessage: true);
  }
}
