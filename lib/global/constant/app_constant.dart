class AppConstant {
  AppConstant._();

  static const String appName = 'Discount Queen';
  static const String appTagline = 'Smart deals. Simple shopping.';
  static const String appDescription =
      'Discount Queen — curated fashion & lifestyle deals with a calm, modern store experience.';
  static const String appVersion = '1.0.0';
  static const String storagePrefix = 'DiscountQueen';
  static const String currency = '₹';
  static const String currencyCode = 'INR';

  static const String supportEmail = 'support@discountqueen.app';
  static const String websiteUrl = 'https://discountqueen.app';
  static const String privacyPolicyUrl = 'https://discountqueen.app/privacy';
  static const String termsUrl = 'https://discountqueen.app/terms';
  static const String deleteAccountUrl = 'https://discountqueen.app/delete-account';
  static const String verifyBaseUrl = 'https://discountqueen.app/verify';
  static String get currentYear => DateTime.now().year.toString();

  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.discountqueen.app';
  static const String appStoreUrl = '';

  static const String githubUrl = '';
  static const String twitterUrl = '';
  static const String linkedinUrl = '';
  static const String youtubeUrl = '';
  static const String instagramUrl = 'https://instagram.com/discountqueen';
  static const String facebookUrl = '';
  static const String whatsappNumber = '+919650806006';

  static const String shareText =
      'Check out $appName — curated deals & smooth checkout. $playStoreUrl';
  static const String updateDialogTitle = 'Update App?';
  static const String updateDialogDesc =
      'A new version of $appName is available.\nWould you like to update now?';
  static const String updateNow = 'Update Now';
  static const String updateLater = 'Later';

  static const int otpLength = 6;
  static const int otpTimeout = 60;
  static const double freeDeliveryThreshold = 499.0;
  static const double deliveryCharge = 49.0;
}
