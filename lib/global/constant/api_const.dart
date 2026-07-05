class ApiConstant {
  ApiConstant._();

  static const String baseUrl = 'https://api.shutku.com/v1';
  static const Duration timeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update';
  static const String deleteAccount = '/user/delete';

  static const String banners = '/banners';
  static const String categories = '/categories';
  static const String products = '/products';
  static const String productDetail = '/products/'; // + id
  static const String featuredProducts = '/products/featured';
  static const String popularProducts = '/products/popular';
  static const String newArrivals = '/products/new-arrivals';
  static const String searchProducts = '/products/search';
  static const String productReviews = '/products/reviews'; // + productId

  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static const String updateCart = '/cart/update';
  static const String removeFromCart = '/cart/remove';
  static const String clearCart = '/cart/clear';
  static const String applyCoupon = '/cart/coupon/apply';
  static const String removeCoupon = '/cart/coupon/remove';

  static const String wishlist = '/wishlist';
  static const String addToWishlist = '/wishlist/add';
  static const String removeFromWishlist = '/wishlist/remove';

  static const String orders = '/orders';
  static const String orderDetail = '/orders/'; // + id
  static const String placeOrder = '/orders/place';
  static const String cancelOrder = '/orders/cancel';
  static const String trackOrder = '/orders/track'; // + id

  static const String addresses = '/addresses';
  static const String addAddress = '/addresses/add';
  static const String updateAddress = '/addresses/update';
  static const String deleteAddress = '/addresses/delete';

  static const String notifications = '/notifications';
  static const String reviews = '/reviews';
  static const String addReview = '/reviews/add';

  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternetConnection = 'No internet connection';
  static const String sessionExpired = 'Session expired. Please login again';
  static const String serverError = 'Server error. Please try again later';
}

