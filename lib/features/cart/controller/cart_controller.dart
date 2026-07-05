import 'package:get/get.dart';
import 'package:portfolio/features/cart/data/cart_repository.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/features/cart/domain/cart_model.dart';
import 'package:portfolio/features/product/domain/product_model.dart';

class CartController extends BaseController {
  final _cartRepo = Get.find<CartRepository>();

  final cart = CartModel().obs;

  int get totalItems => cart.value.totalItems;
  double get subtotal => cart.value.subtotal;
  double get deliveryFee =>
      cart.value.subtotal >= AppConstant.freeDeliveryThreshold
          ? 0
          : AppConstant.deliveryCharge;
  double get total =>
      cart.value.subtotal + deliveryFee - cart.value.couponDiscount;
  double get totalSavings => cart.value.totalSavings;
  bool get isEmpty => cart.value.isEmpty;

  @override
  void onControllerInit() {}

  Future<void> refreshCart() async {
    if (!SPManager.isLoggedIn()) return;
    await executeSilently(() async {
      cart.value = await _cartRepo.getCart();
    });
  }

  Future<void> addToCart(
    ProductModel product, {
    int qty = 1,
    String size = '',
    String color = '',
  }) async {
    if (!SPManager.isLoggedIn()) {
      Get.snackbar('Login required', 'Please login to add items to cart');
      return;
    }
    await executeSilently(() async {
      cart.value = await _cartRepo.addToCart(
        productId: product.id,
        quantity: qty,
        selectedSize: size,
        selectedColor: color,
      );
    }, showErrorMessage: true);
  }

  Future<void> removeFromCart(String itemId) async {
    await executeSilently(() async {
      cart.value = await _cartRepo.removeFromCart(itemId);
    }, showErrorMessage: true);
  }

  Future<void> updateQuantity(String itemId, int qty) async {
    if (qty < 1) {
      await removeFromCart(itemId);
      return;
    }
    await executeSilently(() async {
      cart.value = await _cartRepo.updateCartItem(itemId, qty);
    }, showErrorMessage: true);
  }

  Future<void> clearCart() async {
    await executeSilently(() async {
      cart.value = await _cartRepo.clearCart();
    }, showErrorMessage: true);
  }

  Future<void> applyCoupon(String code) async {
    await executeSilently(() async {
      cart.value = await _cartRepo.applyCoupon(code);
    }, showErrorMessage: true);
  }

  Future<void> removeCoupon() async {
    await executeSilently(() async {
      cart.value = await _cartRepo.removeCoupon();
    }, showErrorMessage: true);
  }
}
