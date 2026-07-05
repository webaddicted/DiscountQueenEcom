import 'package:portfolio/global/apiutils/api_result_ext.dart';
import 'package:portfolio/global/base/base_repository.dart';
import 'package:portfolio/global/constant/api_const.dart';
import 'package:portfolio/features/orders/domain/order_model.dart';
import 'package:portfolio/features/orders/domain/order_request_model.dart';

class OrderRepository extends BaseRepository {
  Future<List<OrderModel>> getOrders() => getList<OrderModel>(
        url: ApiConstant.orders,
        itemParser: (e) => OrderModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<OrderModel> getOrderDetail(String orderId) => get<OrderModel>(
        url: '${ApiConstant.orders}/$orderId',
        parser: (d) => OrderModel.fromJson(Map<String, dynamic>.from(d as Map)),
      ).unwrap();

  Future<OrderModel> trackOrder(String orderId) => get<OrderModel>(
        url: '${ApiConstant.orders}/track/$orderId',
        parser: (d) => OrderModel.fromJson(Map<String, dynamic>.from(d as Map)),
      ).unwrap();

  Future<OrderModel> placeOrder({
    required String addressId,
    String paymentMethod = 'cod',
    String? couponCode,
    String? notes,
  }) =>
      post<OrderModel>(
        url: ApiConstant.placeOrder,
        parser: (d) => OrderModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: PlaceOrderRequest(
          addressId: addressId,
          paymentMethod: paymentMethod,
          couponCode: couponCode,
          notes: notes,
        ),
      ).unwrap();

  Future<OrderModel> cancelOrder(String orderId) => post<OrderModel>(
        url: ApiConstant.cancelOrder,
        params: {'order_id': orderId},
        parser: (d) => OrderModel.fromJson(Map<String, dynamic>.from(d as Map)),
      ).unwrap();
}
