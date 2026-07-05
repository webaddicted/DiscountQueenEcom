import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart' show TargetPlatform;

class ApiConstant {
  ApiConstant._();

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8082/api/v1';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8082/api/v1';
      default:
        return 'http://localhost:8082/api/v1';
    }
  }

  static const Duration timeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';

  // User
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update';
  static const String deleteAccount = '/user/delete';

  // Catalog
  static const String banners = '/banners';
  static const String categories = '/categories';
  static const String products = '/products';
  static const String featuredProducts = '/products/featured';
  static const String popularProducts = '/products/popular';
  static const String newArrivals = '/products/new-arrivals';
  static const String searchProducts = '/products/search';

  // Cart
  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static const String updateCart = '/cart/update';
  static const String removeFromCart = '/cart/remove';
  static const String clearCart = '/cart/clear';
  static const String applyCoupon = '/cart/coupon/apply';
  static const String removeCoupon = '/cart/coupon/remove';

  // Wishlist
  static const String wishlist = '/wishlist';
  static const String addToWishlist = '/wishlist/add';
  static const String removeFromWishlist = '/wishlist/remove';

  // Orders
  static const String orders = '/orders';
  static const String placeOrder = '/orders/place';
  static const String cancelOrder = '/orders/cancel';

  // Addresses
  static const String addresses = '/addresses';
  static const String addAddress = '/addresses/add';
  static const String updateAddress = '/addresses/update';
  static const String deleteAddress = '/addresses/delete';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationsRead = '/notifications/read';

  // Reviews
  static const String reviews = '/reviews';
  static const String addReview = '/reviews/add';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminProducts = '/admin/products';
  static const String adminCategories = '/admin/categories';
  static const String adminBanners = '/admin/banners';
  static const String adminCoupons = '/admin/coupons';
  static const String adminOrders = '/admin/orders';
  static const String adminReviews = '/admin/reviews';
  static const String adminBroadcast = '/admin/notifications/broadcast';

  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternetConnection = 'No internet connection';
  static const String sessionExpired = 'Session expired. Please login again';
  static const String serverError = 'Server error. Please try again later';
}
