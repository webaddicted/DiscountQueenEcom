import 'package:portfolio/global/apiutils/api_result_ext.dart';
import 'package:portfolio/global/base/base_repository.dart';
import 'package:portfolio/global/constant/api_const.dart';
import 'package:portfolio/features/home/domain/banner_model.dart';
import 'package:portfolio/features/home/domain/category_model.dart';
import 'package:portfolio/features/admin/domain/admin_request_model.dart';
import 'package:portfolio/features/admin/domain/coupon_model.dart';
import 'package:portfolio/features/notifications/domain/notification_broadcast_model.dart';
import 'package:portfolio/features/orders/domain/order_model.dart';
import 'package:portfolio/features/orders/domain/order_request_model.dart';
import 'package:portfolio/features/product/domain/product_model.dart';
import 'package:portfolio/features/product/domain/review_model.dart';
import 'package:portfolio/features/auth/domain/user_model.dart';

class AdminDashboardStats {
  final int userCount;
  final int orderCount;
  final double revenueTotal;
  final int ordersToday;
  final int productCount;

  const AdminDashboardStats({
    this.userCount = 0,
    this.orderCount = 0,
    this.revenueTotal = 0,
    this.ordersToday = 0,
    this.productCount = 0,
  });

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) => AdminDashboardStats(
        userCount: json['user_count'] ?? 0,
        orderCount: json['order_count'] ?? 0,
        revenueTotal: (json['revenue_total'] ?? 0).toDouble(),
        ordersToday: json['orders_today'] ?? 0,
        productCount: json['product_count'] ?? 0,
      );
}

class AdminRepository extends BaseRepository {
  AdminDashboardStats _dashboard = const AdminDashboardStats();

  int get userCount => _dashboard.userCount;
  int get orderCount => _dashboard.orderCount;
  double get revenueTotal => _dashboard.revenueTotal;
  int get ordersToday => _dashboard.ordersToday;
  int get productCount => _dashboard.productCount;

  Future<AdminDashboardStats> loadDashboard() async {
    final stats = await get<AdminDashboardStats>(
      url: ApiConstant.adminDashboard,
      parser: (d) => AdminDashboardStats.fromJson(Map<String, dynamic>.from(d as Map)),
    ).unwrap();
    _dashboard = stats;
    return stats;
  }

  Future<List<UserModel>> listUsers() => getList<UserModel>(
        url: ApiConstant.adminUsers,
        itemParser: (e) => UserModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<UserModel> updateUserFlags(
    String uid, {
    required bool isAdmin,
    required bool isBlocked,
    String? blockReason,
  }) =>
      post<UserModel>(
        url: '${ApiConstant.adminUsers}/$uid/flags',
        parser: (d) => UserModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: UserFlagsRequest(
          isAdmin: isAdmin,
          isBlocked: isBlocked,
          blockReason: blockReason,
        ),
      ).unwrap();

  Future<List<ProductModel>> listProducts() => getList<ProductModel>(
        url: ApiConstant.adminProducts,
        itemParser: (e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<ProductModel> saveProduct(ProductModel p, {String? existingId}) async {
    final body = ProductAdminRequest.fromProduct(p);
    if (existingId != null && existingId.isNotEmpty) {
      return put<ProductModel>(
        url: '${ApiConstant.adminProducts}/$existingId',
        parser: (d) => ProductModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: body,
      ).unwrap();
    }
    return post<ProductModel>(
      url: ApiConstant.adminProducts,
      parser: (d) => ProductModel.fromJson(Map<String, dynamic>.from(d as Map)),
      data: body,
    ).unwrap();
  }

  Future<void> deleteProduct(String id) async {
    await deleteAction(url: '${ApiConstant.adminProducts}/$id').unwrap();
  }

  String generateProductId() => '';

  Future<List<CategoryModel>> listCategoriesAdmin() => getList<CategoryModel>(
        url: ApiConstant.adminCategories,
        itemParser: (e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<CategoryModel> saveCategory(CategoryModel c, {String? existingId}) async {
    final body = CategoryAdminRequest.fromCategory(c);
    if (existingId != null && existingId.isNotEmpty) {
      return put<CategoryModel>(
        url: '${ApiConstant.adminCategories}/$existingId',
        parser: (d) => CategoryModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: body,
      ).unwrap();
    }
    return post<CategoryModel>(
      url: ApiConstant.adminCategories,
      parser: (d) => CategoryModel.fromJson(Map<String, dynamic>.from(d as Map)),
      data: body,
    ).unwrap();
  }

  Future<void> deleteCategory(String id) async {
    await deleteAction(url: '${ApiConstant.adminCategories}/$id').unwrap();
  }

  String generateCategoryId() => '';

  Future<List<OrderModel>> allOrdersForAdmin() => getList<OrderModel>(
        url: ApiConstant.adminOrders,
        itemParser: (e) => OrderModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<OrderModel> updateOrderStatus(String id, String status) => post<OrderModel>(
        url: '${ApiConstant.adminOrders}/$id/status',
        parser: (d) => OrderModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: OrderStatusRequest(status: status),
      ).unwrap();

  Future<List<ReviewModel>> listReviews() => getList<ReviewModel>(
        url: ApiConstant.adminReviews,
        itemParser: (e) => ReviewModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<void> deleteReview(String id) async {
    await postAction(
      url: '${ApiConstant.adminReviews}/$id/moderate',
      params: {'visible': false},
    ).unwrap();
  }

  Future<void> saveReview(ReviewModel r) async {
    await postAction(
      url: '${ApiConstant.adminReviews}/${r.id}/moderate',
      params: {'visible': true},
    ).unwrap();
  }

  Future<List<BannerModel>> listBannersAdmin() => getList<BannerModel>(
        url: ApiConstant.adminBanners,
        itemParser: (e) => BannerModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<BannerModel> saveBanner(BannerModel b, {String? existingId}) async {
    final body = BannerAdminRequest.fromBanner(b);
    if (existingId != null && existingId.isNotEmpty) {
      return put<BannerModel>(
        url: '${ApiConstant.adminBanners}/$existingId',
        parser: (d) => BannerModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: body,
      ).unwrap();
    }
    return post<BannerModel>(
      url: ApiConstant.adminBanners,
      parser: (d) => BannerModel.fromJson(Map<String, dynamic>.from(d as Map)),
      data: body,
    ).unwrap();
  }

  Future<void> deleteBanner(String id) async {
    await deleteAction(url: '${ApiConstant.adminBanners}/$id').unwrap();
  }

  String generateBannerId() => '';

  Future<List<CouponModel>> listCouponsAdmin() => getList<CouponModel>(
        url: ApiConstant.adminCoupons,
        itemParser: (e) => CouponModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<CouponModel> saveCoupon(CouponModel c) => post<CouponModel>(
        url: ApiConstant.adminCoupons,
        parser: (d) => CouponModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: c.toJson(),
      ).unwrap();

  Future<void> deleteCoupon(String id) async {
    // Backend has no delete coupon endpoint — deactivate via save
    final coupons = await listCouponsAdmin();
    final match = coupons.where((c) => c.id == id || c.code == id).firstOrNull;
    if (match != null) {
      await saveCoupon(CouponModel(
        id: match.id,
        code: match.code,
        discountPercent: match.discountPercent,
        maxDiscount: match.maxDiscount,
        expiry: match.expiry,
        active: false,
      ));
    }
  }

  String generateCouponId() => '';

  Future<List<NotificationBroadcastModel>> listBroadcasts() async => [];

  Future<void> saveBroadcast(NotificationBroadcastModel m) async {
    await postAction(
      url: ApiConstant.adminBroadcast,
      data: BroadcastRequest.fromModel(m),
    ).unwrap();
  }

  Future<void> deleteBroadcast(String id) async {}

  String generateBroadcastId() => 'bc_${DateTime.now().millisecondsSinceEpoch}';
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
