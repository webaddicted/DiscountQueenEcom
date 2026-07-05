class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double mrp;
  final int quantity;
  final String selectedSize;
  final String selectedColor;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage = '',
    required this.price,
    this.mrp = 0,
    this.quantity = 1,
    this.selectedSize = '',
    this.selectedColor = '',
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id']?.toString() ?? '',
        productId: json['product_id']?.toString() ?? '',
        productName: json['product_name'] ?? '',
        productImage: json['product_image'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        mrp: (json['mrp'] ?? 0).toDouble(),
        quantity: json['quantity'] ?? 1,
        selectedSize: json['selected_size'] ?? '',
        selectedColor: json['selected_color'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'product_name': productName,
        'product_image': productImage,
        'price': price,
        'mrp': mrp,
        'quantity': quantity,
        'selected_size': selectedSize,
        'selected_color': selectedColor,
      };

  double get totalPrice => price * quantity;
  double get totalMrp => mrp * quantity;
  double get savings => totalMrp > totalPrice ? totalMrp - totalPrice : 0;

  CartItemModel copyWith({int? quantity, String? selectedSize, String? selectedColor}) =>
      CartItemModel(
        id: id,
        productId: productId,
        productName: productName,
        productImage: productImage,
        price: price,
        mrp: mrp,
        quantity: quantity ?? this.quantity,
        selectedSize: selectedSize ?? this.selectedSize,
        selectedColor: selectedColor ?? this.selectedColor,
      );
}

class CartModel {
  final List<CartItemModel> items;
  final String couponCode;
  final double couponDiscount;

  CartModel({
    this.items = const [],
    this.couponCode = '',
    this.couponDiscount = 0,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        items: (json['items'] as List?)
                ?.map((e) => CartItemModel.fromJson(e))
                .toList() ??
            [],
        couponCode: json['coupon_code'] ?? '',
        couponDiscount: (json['coupon_discount'] ?? 0).toDouble(),
      );

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get totalMrp => items.fold(0.0, (sum, item) => sum + item.totalMrp);
  double get totalSavings => totalMrp > subtotal ? totalMrp - subtotal + couponDiscount : couponDiscount;
  bool get isEmpty => items.isEmpty;
}
