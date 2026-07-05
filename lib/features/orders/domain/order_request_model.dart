import 'package:portfolio/model/api_body.dart';

class PlaceOrderRequest implements ApiBody {
  final String addressId;
  final String paymentMethod;
  final String? couponCode;
  final String? notes;

  const PlaceOrderRequest({
    required this.addressId,
    this.paymentMethod = 'cod',
    this.couponCode,
    this.notes,
  });

  @override
  Map<String, dynamic> toJson() => {
        'address_id': addressId,
        'payment_method': paymentMethod,
        if (couponCode != null && couponCode!.isNotEmpty) 'coupon_code': couponCode,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
      };
}

class OrderStatusRequest implements ApiBody {
  final String status;

  const OrderStatusRequest({required this.status});

  @override
  Map<String, dynamic> toJson() => {'status': status};
}
