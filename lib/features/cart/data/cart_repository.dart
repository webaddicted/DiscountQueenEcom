import 'package:portfolio/global/apiutils/api_result_ext.dart';
import 'package:portfolio/global/base/base_repository.dart';
import 'package:portfolio/global/constant/api_const.dart';
import 'package:portfolio/features/cart/domain/cart_model.dart';
import 'package:portfolio/features/cart/domain/cart_request_model.dart';

class CartRepository extends BaseRepository {
  Future<CartModel> getCart() => get<CartModel>(
        url: ApiConstant.cart,
        parser: (d) => CartModel.fromJson(Map<String, dynamic>.from(d as Map)),
      ).unwrap();

  Future<CartModel> addToCart({
    required String productId,
    int quantity = 1,
    String selectedSize = '',
    String selectedColor = '',
  }) =>
      post<CartModel>(
        url: ApiConstant.addToCart,
        parser: (d) => CartModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: CartAddRequest(
          productId: productId,
          quantity: quantity,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
        ),
      ).unwrap();

  Future<CartModel> updateCartItem(String itemId, int quantity) => post<CartModel>(
        url: ApiConstant.updateCart,
        params: {'item_id': itemId},
        parser: (d) => CartModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: CartUpdateRequest(quantity: quantity),
      ).unwrap();

  Future<CartModel> removeFromCart(String itemId) => post<CartModel>(
        url: ApiConstant.removeFromCart,
        params: {'item_id': itemId},
        parser: (d) => CartModel.fromJson(Map<String, dynamic>.from(d as Map)),
      ).unwrap();

  Future<CartModel> clearCart() => post<CartModel>(
        url: ApiConstant.clearCart,
        parser: (d) => CartModel.fromJson(Map<String, dynamic>.from(d as Map)),
      ).unwrap();

  Future<CartModel> applyCoupon(String code) => post<CartModel>(
        url: ApiConstant.applyCoupon,
        parser: (d) => CartModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: CouponApplyRequest(code: code),
      ).unwrap();

  Future<CartModel> removeCoupon() => post<CartModel>(
        url: ApiConstant.removeCoupon,
        parser: (d) => CartModel.fromJson(Map<String, dynamic>.from(d as Map)),
      ).unwrap();
}
