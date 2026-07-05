import 'package:get/get.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/model/cart_model.dart';
import 'package:portfolio/model/product_model.dart';

class CartController extends BaseController {
  final cart = CartModel(
    items: [
      CartItemModel(
        id: 'ci1',
        productId: 'p1',
        productName: 'Organic Cotton Baby Onesie',
        productImage: 'https://picsum.photos/400/400?random=1',
        price: 899,
        mrp: 1299,
        quantity: 2,
        selectedSize: '0-3M',
        selectedColor: 'Red',
      ),
      CartItemModel(
        id: 'ci2',
        productId: 'p2',
        productName: 'Baby Feeding Bottle Set',
        productImage: 'https://picsum.photos/400/400?random=4',
        price: 599,
        mrp: 799,
        quantity: 1,
        selectedSize: '',
        selectedColor: '',
      ),
    ],
  ).obs;

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

  void addToCart(
    ProductModel product, {
    int qty = 1,
    String size = '',
    String color = '',
  }) {
    final existingIndex = cart.value.items.indexWhere(
      (i) =>
          i.productId == product.id &&
          i.selectedSize == size &&
          i.selectedColor == color,
    );
    if (existingIndex >= 0) {
      final item = cart.value.items[existingIndex];
      updateQuantity(item.id, item.quantity + qty);
      return;
    }
    final newItem = CartItemModel(
      id: 'ci_${DateTime.now().millisecondsSinceEpoch}',
      productId: product.id,
      productName: product.name,
      productImage: product.displayImage,
      price: product.price,
      mrp: product.mrp,
      quantity: qty,
      selectedSize: size,
      selectedColor: color,
    );
    cart.value = CartModel(
      items: [...cart.value.items, newItem],
      couponCode: cart.value.couponCode,
      couponDiscount: cart.value.couponDiscount,
    );
  }

  void removeFromCart(String itemId) {
    cart.value = CartModel(
      items: cart.value.items.where((i) => i.id != itemId).toList(),
      couponCode: cart.value.couponCode,
      couponDiscount: cart.value.couponDiscount,
    );
  }

  void updateQuantity(String itemId, int qty) {
    if (qty < 1) {
      removeFromCart(itemId);
      return;
    }
    cart.value = CartModel(
      items: cart.value.items.map((i) {
        if (i.id == itemId) return i.copyWith(quantity: qty);
        return i;
      }).toList(),
      couponCode: cart.value.couponCode,
      couponDiscount: cart.value.couponDiscount,
    );
  }

  void clearCart() {
    cart.value = CartModel(items: []);
  }

  void applyCoupon(String code) {
    if (code.toUpperCase() == 'SAVE10') {
      cart.value = CartModel(
        items: cart.value.items,
        couponCode: code,
        couponDiscount: cart.value.subtotal * 0.1,
      );
    } else {
      cart.value = CartModel(
        items: cart.value.items,
        couponCode: '',
        couponDiscount: 0,
      );
    }
  }

  void removeCoupon() {
    cart.value = CartModel(
      items: cart.value.items,
      couponCode: '',
      couponDiscount: 0,
    );
  }
}
