import 'package:portfolio/model/cart_model.dart';
import 'package:portfolio/model/address_model.dart';

class OrderModel {
  final String id;
  final String orderNumber;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final AddressModel? deliveryAddress;
  final String createdAt;
  final String updatedAt;
  final String estimatedDelivery;
  final List<OrderTrackingStep> trackingSteps;
  final String userId;
  final String paymentRef;

  OrderModel({
    required this.id,
    this.orderNumber = '',
    this.items = const [],
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.discount = 0,
    this.total = 0,
    this.status = 'pending',
    this.paymentMethod = '',
    this.paymentStatus = 'pending',
    this.deliveryAddress,
    this.createdAt = '',
    this.updatedAt = '',
    this.estimatedDelivery = '',
    this.trackingSteps = const [],
    this.userId = '',
    this.paymentRef = '',
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id']?.toString() ?? '',
        orderNumber: json['order_number'] ?? '',
        items: (json['items'] as List?)
                ?.map((e) => CartItemModel.fromJson(e))
                .toList() ??
            [],
        subtotal: (json['subtotal'] ?? 0).toDouble(),
        deliveryFee: (json['delivery_fee'] ?? 0).toDouble(),
        discount: (json['discount'] ?? 0).toDouble(),
        total: (json['total'] ?? 0).toDouble(),
        status: json['status'] ?? 'pending',
        paymentMethod: json['payment_method'] ?? '',
        paymentStatus: json['payment_status'] ?? 'pending',
        deliveryAddress: json['delivery_address'] != null
            ? AddressModel.fromJson(json['delivery_address'])
            : null,
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        estimatedDelivery: json['estimated_delivery'] ?? '',
        trackingSteps: (json['tracking_steps'] as List?)
                ?.map((e) => OrderTrackingStep.fromJson(e))
                .toList() ??
            [],
        userId: json['user_id']?.toString() ?? '',
        paymentRef: json['payment_ref']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_number': orderNumber,
        'items': items.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'delivery_fee': deliveryFee,
        'discount': discount,
        'total': total,
        'status': status,
        'payment_method': paymentMethod,
        'payment_status': paymentStatus,
        'delivery_address': deliveryAddress?.toJson(),
        'created_at': createdAt,
        'updated_at': updatedAt,
        'estimated_delivery': estimatedDelivery,
        'tracking_steps': trackingSteps.map((e) => e.toJson()).toList(),
        'user_id': userId,
        'payment_ref': paymentRef,
      };

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';
  bool get canCancel => status == 'pending' || status == 'confirmed';
}

class OrderTrackingStep {
  final String title;
  final String description;
  final String dateTime;
  final bool isCompleted;
  final bool isCurrent;

  OrderTrackingStep({
    required this.title,
    this.description = '',
    this.dateTime = '',
    this.isCompleted = false,
    this.isCurrent = false,
  });

  factory OrderTrackingStep.fromJson(Map<String, dynamic> json) =>
      OrderTrackingStep(
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        dateTime: json['date_time'] ?? '',
        isCompleted: json['is_completed'] ?? false,
        isCurrent: json['is_current'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'date_time': dateTime,
        'is_completed': isCompleted,
        'is_current': isCurrent,
      };
}
