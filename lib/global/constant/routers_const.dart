class RoutersConst {
  RoutersConst._();

  static const String initialRoute = '/splash';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';

  static const String main = '/main';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String categoryProducts = '/category/:categoryId';
  static const String categoryProductDetail =
      '/category/:categoryId/:productId';
  static const String productDetail = '/product/:productId';
  static const String productList = '/products';

  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';

  static const String orders = '/orders';
  static const String orderDetail = '/order/:orderId';
  static const String orderTracking = '/order/tracking';

  static const String wishlist = '/wishlist';
  static const String search = '/search';

  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String addressList = '/addresses';
  static const String addAddress = '/address/add';
  static const String editAddress = '/address/edit';

  static const String settings = '/settings';
  static const String aboutUs = '/about-us';
  static const String helpSupport = '/help-support';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsCondition = '/terms-condition';

  static const String notifications = '/notifications';
  static const String reviews = '/reviews';
  static const String writeReview = '/review/write';

  static const String admin = '/admin';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminProducts = '/admin/products';
  static const String adminProductForm = '/admin/product-form';
  static const String adminCategories = '/admin/categories';
  static const String adminOrders = '/admin/orders';
  static const String adminPayments = '/admin/payments';
  static const String adminReviews = '/admin/reviews';
  static const String adminBanners = '/admin/banners';
  static const String adminCoupons = '/admin/coupons';
  static const String adminNotifications = '/admin/notifications';

  static const List<String> tabRoutes = [
    home,
    categories,
    cart,
    wishlist,
    profile,
  ];
}
