import 'package:portfolio/global/base/base_repository.dart';
import 'package:portfolio/features/address/domain/address_model.dart';
import 'package:portfolio/features/home/domain/banner_model.dart';
import 'package:portfolio/features/cart/domain/cart_model.dart';
import 'package:portfolio/features/home/domain/category_model.dart';
import 'package:portfolio/features/admin/domain/coupon_model.dart';
import 'package:portfolio/features/notifications/domain/notification_broadcast_model.dart';
import 'package:portfolio/features/orders/domain/order_model.dart';
import 'package:portfolio/features/product/domain/product_model.dart';
import 'package:portfolio/features/product/domain/review_model.dart';
import 'package:portfolio/features/auth/domain/user_model.dart';

/// In-memory admin store with demo seed data. Replace with API calls when backend is ready.
class AdminRepository extends BaseRepository {
  static final List<ProductModel> _products = List<ProductModel>.from(_seedProducts());
  static final List<CategoryModel> _categories = List<CategoryModel>.from(_seedCategories());
  static final List<BannerModel> _banners = List<BannerModel>.from(_seedBanners());
  static final List<CouponModel> _coupons = List<CouponModel>.from(_seedCoupons());
  static final List<ReviewModel> _reviews = List<ReviewModel>.from(_seedReviews());
  static final List<NotificationBroadcastModel> _broadcasts =
      List<NotificationBroadcastModel>.from(_seedBroadcasts());
  static final List<UserModel> _users = List<UserModel>.from(_seedUsers());
  static final List<OrderModel> _orders = List<OrderModel>.from(_seedOrders());

  // ——— Dashboard ———

  int get userCount => _users.length;

  int get orderCount => _orders.length;

  double get revenueTotal =>
      _orders.fold<double>(0, (sum, o) => sum + o.total);

  int get ordersToday {
    final now = DateTime.now();
    return _orders.where((o) {
      final t = DateTime.tryParse(o.createdAt);
      if (t == null) return false;
      return t.year == now.year && t.month == now.month && t.day == now.day;
    }).length;
  }

  // ——— Users ———

  Future<List<UserModel>> listUsers() async {
    await Future<void>.delayed(Duration.zero);
    return List<UserModel>.from(_users);
  }

  Future<void> updateUserFlags(
    String uid, {
    required bool isAdmin,
    required bool isBlocked,
    String? blockReason,
  }) async {
    final i = _users.indexWhere((u) => u.id == uid);
    if (i < 0) return;
    _users[i] = _users[i].copyWith(
      isAdmin: isAdmin,
      isBlocked: isBlocked,
      blockReason: blockReason,
    );
  }

  // ——— Products ———

  Future<List<ProductModel>> listProducts() async {
    await Future<void>.delayed(Duration.zero);
    return List<ProductModel>.from(_products);
  }

  Future<void> saveProduct(ProductModel p) async {
    final i = _products.indexWhere((e) => e.id == p.id);
    if (i >= 0) {
      _products[i] = p;
    } else {
      _products.add(p);
    }
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((e) => e.id == id);
  }

  String generateProductId() => 'p_${DateTime.now().millisecondsSinceEpoch}';

  // ——— Categories ———

  Future<List<CategoryModel>> listCategoriesAdmin() async {
    await Future<void>.delayed(Duration.zero);
    final list = List<CategoryModel>.from(_categories);
    list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  Future<void> saveCategory(CategoryModel c) async {
    final i = _categories.indexWhere((e) => e.id == c.id);
    if (i >= 0) {
      _categories[i] = c;
    } else {
      _categories.add(c);
    }
  }

  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((e) => e.id == id);
  }

  String generateCategoryId() => 'c_${DateTime.now().millisecondsSinceEpoch}';

  // ——— Orders ———

  Future<List<OrderModel>> allOrdersForAdmin() async {
    await Future<void>.delayed(Duration.zero);
    final list = List<OrderModel>.from(_orders);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> updateOrderStatus(String id, String status) async {
    final i = _orders.indexWhere((o) => o.id == id);
    if (i < 0) return;
    final o = _orders[i];
    _orders[i] = OrderModel(
      id: o.id,
      orderNumber: o.orderNumber,
      items: o.items,
      subtotal: o.subtotal,
      deliveryFee: o.deliveryFee,
      discount: o.discount,
      total: o.total,
      status: status,
      paymentMethod: o.paymentMethod,
      paymentStatus: o.paymentStatus,
      deliveryAddress: o.deliveryAddress,
      createdAt: o.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
      estimatedDelivery: o.estimatedDelivery,
      trackingSteps: o.trackingSteps,
      userId: o.userId,
      paymentRef: o.paymentRef,
    );
  }

  // ——— Reviews ———

  Future<List<ReviewModel>> listReviews() async {
    await Future<void>.delayed(Duration.zero);
    return List<ReviewModel>.from(_reviews);
  }

  Future<void> saveReview(ReviewModel r) async {
    final i = _reviews.indexWhere((e) => e.id == r.id);
    if (i >= 0) {
      _reviews[i] = r;
    } else {
      _reviews.add(r);
    }
  }

  Future<void> deleteReview(String id) async {
    _reviews.removeWhere((e) => e.id == id);
  }

  // ——— Banners ———

  Future<List<BannerModel>> listBannersAdmin() async {
    await Future<void>.delayed(Duration.zero);
    final list = List<BannerModel>.from(_banners);
    list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  Future<void> saveBanner(BannerModel b) async {
    final i = _banners.indexWhere((e) => e.id == b.id);
    if (i >= 0) {
      _banners[i] = b;
    } else {
      _banners.add(b);
    }
  }

  Future<void> deleteBanner(String id) async {
    _banners.removeWhere((e) => e.id == id);
  }

  String generateBannerId() => 'b_${DateTime.now().millisecondsSinceEpoch}';

  // ——— Coupons ———

  Future<List<CouponModel>> listCouponsAdmin() async {
    await Future<void>.delayed(Duration.zero);
    return List<CouponModel>.from(_coupons);
  }

  Future<void> saveCoupon(CouponModel c) async {
    final i = _coupons.indexWhere((e) => e.id == c.id);
    if (i >= 0) {
      _coupons[i] = c;
    } else {
      _coupons.add(c);
    }
  }

  Future<void> deleteCoupon(String id) async {
    _coupons.removeWhere((e) => e.id == id);
  }

  String generateCouponId() => 'cp_${DateTime.now().millisecondsSinceEpoch}';

  // ——— Broadcast drafts ———

  Future<List<NotificationBroadcastModel>> listBroadcasts() async {
    await Future<void>.delayed(Duration.zero);
    final list = List<NotificationBroadcastModel>.from(_broadcasts);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> saveBroadcast(NotificationBroadcastModel m) async {
    final i = _broadcasts.indexWhere((e) => e.id == m.id);
    if (i >= 0) {
      _broadcasts[i] = m;
    } else {
      _broadcasts.add(m);
    }
  }

  Future<void> deleteBroadcast(String id) async {
    _broadcasts.removeWhere((e) => e.id == id);
  }

  String generateBroadcastId() => 'bc_${DateTime.now().millisecondsSinceEpoch}';

  // ——— Seeds ———

  static List<CategoryModel> _seedCategories() => [
        CategoryModel(id: 'cat_fashion', name: 'Fashion', sortOrder: 1, image: ''),
        CategoryModel(id: 'cat_home', name: 'Home', sortOrder: 2, image: ''),
        CategoryModel(id: 'cat_beauty', name: 'Beauty', sortOrder: 3, image: ''),
      ];

  static List<ProductModel> _seedProducts() => [
        ProductModel(
          id: 'p_demo_1',
          name: 'Everyday Tee',
          description: 'Soft cotton tee for daily wear.',
          shortDescription: 'Breathable cotton',
          price: 599,
          mrp: 999,
          discountPercent: 40,
          images: const ['https://picsum.photos/seed/dq1/400/400'],
          thumbnail: 'https://picsum.photos/seed/dq1/400/400',
          categoryId: 'cat_fashion',
          categoryName: 'Fashion',
          brand: 'DQ',
          rating: 4.6,
          reviewCount: 128,
          stockQty: 42,
          sizes: const ['S', 'M', 'L'],
          colors: const ['Black', 'White'],
          tags: const ['tee', 'basics'],
          isFeatured: true,
        ),
        ProductModel(
          id: 'p_demo_2',
          name: 'Ceramic Mug Set',
          description: 'Set of 2 minimalist mugs.',
          price: 449,
          mrp: 699,
          discountPercent: 36,
          images: const ['https://picsum.photos/seed/dq2/400/400'],
          thumbnail: 'https://picsum.photos/seed/dq2/400/400',
          categoryId: 'cat_home',
          categoryName: 'Home',
          brand: 'DQ Home',
          rating: 4.4,
          reviewCount: 56,
          stockQty: 18,
        ),
      ];

  static List<UserModel> _seedUsers() => [
        UserModel(
          id: 'u_demo',
          name: 'Aisha Khan',
          email: 'aisha@example.com',
          phone: '+919876543210',
          isAdmin: false,
        ),
        UserModel(
          id: 'u_admin_seed',
          name: 'Store Admin',
          email: 'admin@discountqueen.com',
          isAdmin: true,
        ),
      ];

  static List<OrderModel> _seedOrders() {
    final addr = AddressModel(
      id: 'addr_seed',
      name: 'Aisha Khan',
      phone: '+919876543210',
      addressLine1: '12 MG Road',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400001',
      type: 'home',
      isDefault: true,
    );

    return [
      OrderModel(
        id: 'ord_1',
        orderNumber: 'DQ-24001',
        items: [
          CartItemModel(
            id: 'ci1',
            productId: 'p_demo_1',
            productName: 'Everyday Tee',
            productImage: 'https://picsum.photos/seed/dq1/200/200',
            price: 599,
            mrp: 999,
            quantity: 1,
          ),
        ],
        subtotal: 599,
        deliveryFee: 49,
        discount: 0,
        total: 648,
        status: 'confirmed',
        paymentMethod: 'UPI',
        paymentStatus: 'paid',
        deliveryAddress: addr,
        createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        userId: 'u_demo',
        paymentRef: 'pay_rzp_demo_001',
      ),
      OrderModel(
        id: 'ord_2',
        orderNumber: 'DQ-24002',
        items: [
          CartItemModel(
            id: 'ci2',
            productId: 'p_demo_2',
            productName: 'Ceramic Mug Set',
            productImage: 'https://picsum.photos/seed/dq2/200/200',
            price: 449,
            mrp: 699,
            quantity: 2,
          ),
        ],
        subtotal: 898,
        deliveryFee: 0,
        discount: 100,
        total: 798,
        status: 'shipped',
        paymentMethod: 'Card',
        paymentStatus: 'paid',
        deliveryAddress: addr,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        userId: 'u_demo',
        paymentRef: 'pay_rzp_demo_002',
      ),
    ];
  }

  static List<ReviewModel> _seedReviews() => [
        ReviewModel(
          id: 'rev_1',
          userId: 'u_demo',
          userName: 'Aisha Khan',
          productId: 'p_demo_1',
          rating: 5,
          comment: 'Love the fabric — fits perfectly.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        ),
      ];

  static List<BannerModel> _seedBanners() => [
        BannerModel(
          id: 'bn_1',
          title: 'Summer Sale',
          subtitle: 'Up to 50% off',
          image: 'https://picsum.photos/seed/bn1/800/320',
          actionType: 'category',
          actionValue: 'cat_fashion',
          sortOrder: 0,
          isActive: true,
        ),
      ];

  static List<CouponModel> _seedCoupons() => [
        CouponModel(
          id: 'cp_1',
          code: 'DQWELCOME',
          discountPercent: 15,
          maxDiscount: 500,
          expiry: DateTime.now().add(const Duration(days: 30)),
          active: true,
        ),
      ];

  static List<NotificationBroadcastModel> _seedBroadcasts() => [
        NotificationBroadcastModel(
          id: 'bc_1',
          title: 'Weekend flash deals',
          body: 'Extra 10% off on cart above ₹999 — happy shopping!',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          sent: false,
        ),
      ];
}
