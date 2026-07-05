class CouponModel {
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
}
