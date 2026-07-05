import 'package:portfolio/model/api_body.dart';

class CartAddRequest implements ApiBody {
  final String productId;
  final int quantity;
  final String selectedSize;
  final String selectedColor;

  const CartAddRequest({
    required this.productId,
    this.quantity = 1,
    this.selectedSize = '',
    this.selectedColor = '',
  });

  @override
  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': quantity,
        'selected_size': selectedSize,
        'selected_color': selectedColor,
      };
}

class CartUpdateRequest implements ApiBody {
  final int quantity;

  const CartUpdateRequest({required this.quantity});

  @override
  Map<String, dynamic> toJson() => {'quantity': quantity};
}

class CouponApplyRequest implements ApiBody {
  final String code;

  const CouponApplyRequest({required this.code});

  @override
  Map<String, dynamic> toJson() => {'code': code};
}
