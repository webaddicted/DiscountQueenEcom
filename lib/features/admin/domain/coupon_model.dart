import 'package:portfolio/model/api_body.dart';

class CouponModel implements ApiBody {
  final String id;
  final String code;
  final int discountPercent;
  final double maxDiscount;
  final DateTime expiry;
  final bool active;

  CouponModel({
    required this.id,
    required this.code,
    this.discountPercent = 0,
    this.maxDiscount = 0,
    required this.expiry,
    this.active = true,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    final code = json['code']?.toString() ?? '';
    final expiresRaw = json['expires_at']?.toString() ?? '';
    return CouponModel(
      id: code,
      code: code,
      discountPercent: json['discount_percent'] ?? 0,
      maxDiscount: (json['max_discount'] ?? 0).toDouble(),
      expiry: expiresRaw.isNotEmpty
          ? DateTime.tryParse(expiresRaw) ?? DateTime.now().add(const Duration(days: 30))
          : DateTime.now().add(const Duration(days: 30)),
      active: json['is_active'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'code': code,
        'discount_type': 'percent',
        'discount_percent': discountPercent,
        'discount_amount': 0,
        'max_discount': maxDiscount,
        'min_order_amount': 0,
        'is_active': active,
        'expires_at': expiry.toIso8601String(),
      };
}
