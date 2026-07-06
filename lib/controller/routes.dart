import 'package:get/get.dart';
import 'package:portfolio/controller/initial_binding.dart';
import 'package:portfolio/features/about/presentation/about_us_page.dart';
import 'package:portfolio/features/admin/presentation/admin_banners_screen.dart';
import 'package:portfolio/features/admin/presentation/admin_categories_screen.dart';
import 'package:portfolio/features/admin/presentation/admin_coupons_screen.dart';
import 'package:portfolio/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:portfolio/features/admin/presentation/admin_notifications_screen.dart';
import 'package:portfolio/features/admin/presentation/admin_orders_screen.dart';
import 'package:portfolio/features/admin/presentation/admin_payments_screen.dart';
import 'package:portfolio/features/admin/presentation/admin_product_form_screen.dart';
import 'package:portfolio/features/admin/presentation/admin_products_screen.dart';
import 'package:portfolio/features/admin/presentation/admin_reviews_screen.dart';
import 'package:portfolio/features/admin/presentation/admin_shell_screen.dart';
import 'package:portfolio/features/admin/presentation/admin_users_screen.dart';
import 'package:portfolio/features/address/controller/address_controller.dart';
import 'package:portfolio/features/address/presentation/add_address_page.dart';
import 'package:portfolio/features/address/presentation/address_list_page.dart';
import 'package:portfolio/features/address/presentation/edit_address_page.dart';
import 'package:portfolio/features/auth/presentation/login_page.dart';
import 'package:portfolio/features/auth/presentation/otp_page.dart';
import 'package:portfolio/features/auth/presentation/register_page.dart';
import 'package:portfolio/features/checkout/controller/checkout_controller.dart';
import 'package:portfolio/features/checkout/presentation/checkout_page.dart';
import 'package:portfolio/features/checkout/presentation/order_success_page.dart';
import 'package:portfolio/features/help/presentation/help_support_page.dart';
import 'package:portfolio/features/legal/presentation/privacy_policy_page.dart';
import 'package:portfolio/features/legal/presentation/terms_condition_page.dart';
import 'package:portfolio/features/main/presentation/main_page.dart';
import 'package:portfolio/features/notifications/presentation/notifications_page.dart';
import 'package:portfolio/features/onboarding/presentation/onboarding_page.dart';
import 'package:portfolio/features/orders/controller/order_controller.dart';
import 'package:portfolio/features/orders/presentation/order_detail_page.dart';
import 'package:portfolio/features/orders/presentation/orders_page.dart';
import 'package:portfolio/features/product/controller/product_controller.dart';
import 'package:portfolio/features/product/presentation/product_detail_page.dart';
import 'package:portfolio/features/product/presentation/product_list_page.dart';
import 'package:portfolio/features/profile/presentation/edit_profile_page.dart';
import 'package:portfolio/features/search/controller/shop_search_controller.dart';
import 'package:portfolio/features/search/presentation/search_page.dart';
import 'package:portfolio/features/settings/presentation/settings_page.dart';
import 'package:portfolio/features/splash/presentation/splash_page.dart';
import 'package:portfolio/global/constant/routers_const.dart';

GetPage _mainPage(String name) => GetPage(
      name: name,
      page: () => const MainPage(),
      transition: Transition.noTransition,
    );

List<GetPage> routes() => [
      GetPage(name: RoutersConst.splash, page: () => const SplashPage()),
      GetPage(
          name: RoutersConst.onboarding, page: () => const OnboardingPage()),
      GetPage(
        name: RoutersConst.login,
        page: () => const LoginPage(),
        binding: AuthBinding(),
      ),
      GetPage(
        name: RoutersConst.register,
        page: () => const RegisterPage(),
        binding: AuthBinding(),
      ),
      GetPage(
        name: RoutersConst.otp,
        page: () => const OtpPage(),
        binding: AuthBinding(),
      ),

      _mainPage(RoutersConst.main),
      _mainPage(RoutersConst.home),
      _mainPage(RoutersConst.categories),
      _mainPage(RoutersConst.cart),
      _mainPage(RoutersConst.wishlist),
      _mainPage(RoutersConst.profile),

      GetPage(
        name: RoutersConst.productDetail,
        page: () => const ProductDetailPage(),
        binding: BindingsBuilder(() {
          if (!Get.isRegistered<ProductController>()) {
            Get.lazyPut<ProductController>(() => ProductController());
          }
        }),
      ),
      GetPage(
        name: RoutersConst.categoryProductDetail,
        page: () => const ProductDetailPage(),
        binding: BindingsBuilder(() {
          if (!Get.isRegistered<ProductController>()) {
            Get.lazyPut<ProductController>(() => ProductController());
          }
        }),
      ),
      GetPage(
        name: RoutersConst.productList,
        page: () => const ProductListPage(),
        binding: BindingsBuilder(() {
          if (!Get.isRegistered<ProductController>()) {
            Get.lazyPut<ProductController>(() => ProductController());
          }
        }),
      ),
      GetPage(
        name: RoutersConst.categoryProducts,
        page: () => const ProductListPage(),
        binding: BindingsBuilder(() {
          if (!Get.isRegistered<ProductController>()) {
            Get.lazyPut<ProductController>(() => ProductController());
          }
        }),
      ),
      GetPage(
        name: RoutersConst.checkout,
        page: () => const CheckoutPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<CheckoutController>(() => CheckoutController());
        }),
      ),
      GetPage(
          name: RoutersConst.orderSuccess,
          page: () => const OrderSuccessPage()),
      GetPage(
        name: RoutersConst.orders,
        page: () => const OrdersPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<OrderController>(() => OrderController());
        }),
      ),
      GetPage(
          name: RoutersConst.orderDetail,
          page: () => const OrderDetailPage()),
      GetPage(
        name: RoutersConst.search,
        page: () => const SearchPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ShopSearchController>(() => ShopSearchController());
        }),
      ),
      GetPage(
        name: RoutersConst.editProfile,
        page: () => const EditProfilePage(),
      ),
      GetPage(
        name: RoutersConst.addressList,
        page: () => const AddressListPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AddressController>(() => AddressController());
        }),
      ),
      GetPage(
          name: RoutersConst.addAddress, page: () => const AddAddressPage()),
      GetPage(
          name: RoutersConst.editAddress, page: () => const EditAddressPage()),
      GetPage(name: RoutersConst.settings, page: () => const SettingsPage()),
      GetPage(name: RoutersConst.aboutUs, page: () => const AboutUsPage()),
      GetPage(
          name: RoutersConst.helpSupport,
          page: () => const HelpSupportPage()),
      GetPage(
          name: RoutersConst.privacyPolicy,
          page: () => const PrivacyPolicyPage()),
      GetPage(
          name: RoutersConst.termsCondition,
          page: () => const TermsConditionPage()),
      GetPage(
          name: RoutersConst.notifications,
          page: () => const NotificationsPage()),
      GetPage(name: RoutersConst.admin, page: () => const AdminShellScreen()),
      GetPage(
          name: RoutersConst.adminDashboard,
          page: () => const AdminDashboardScreen()),
      GetPage(name: RoutersConst.adminUsers, page: () => const AdminUsersScreen()),
      GetPage(
          name: RoutersConst.adminProducts,
          page: () => const AdminProductsScreen()),
      GetPage(
          name: RoutersConst.adminProductForm,
          page: () => const AdminProductFormScreen()),
      GetPage(
          name: RoutersConst.adminCategories,
          page: () => const AdminCategoriesScreen()),
      GetPage(
          name: RoutersConst.adminOrders,
          page: () => const AdminOrdersScreen()),
      GetPage(
          name: RoutersConst.adminPayments,
          page: () => const AdminPaymentsScreen()),
      GetPage(
          name: RoutersConst.adminReviews,
          page: () => const AdminReviewsScreen()),
      GetPage(
          name: RoutersConst.adminBanners,
          page: () => const AdminBannersScreen()),
      GetPage(
          name: RoutersConst.adminCoupons,
          page: () => const AdminCouponsScreen()),
      GetPage(
          name: RoutersConst.adminNotifications,
          page: () => const AdminNotificationsScreen()),
    ];
