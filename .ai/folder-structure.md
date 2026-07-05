# aaqueen-ecom — Folder Structure

<!-- AUTO-GENERATED:folders -->
### `.github/workflows/`
- **Purpose:** workflows/ module
- **Files:** 3
  - `.github/workflows/build-web.yml`
  - `.github/workflows/build-android.yml`
  - `.github/workflows/ci.yml`

### `android/`
- **Purpose:** Android native project and Gradle build
- **Files:** 7
  - `android/local.properties`
  - `android/gradlew`
  - `android/build.gradle.kts`
  - `android/settings.gradle.kts`
  - `android/portfolio_android.iml`
  - `android/gradle.properties`
  - `android/gradlew.bat`

### `android/app/`
- **Purpose:** app/ module
- **Files:** 1
  - `android/app/build.gradle.kts`

### `android/app/src/debug/`
- **Purpose:** debug/ module
- **Files:** 1
  - `android/app/src/debug/AndroidManifest.xml`

### `android/app/src/main/`
- **Purpose:** main/ module
- **Files:** 1
  - `android/app/src/main/AndroidManifest.xml`

### `android/app/src/main/java/io/flutter/plugins/`
- **Purpose:** plugins/ module
- **Files:** 1
  - `android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java`

### `android/app/src/main/kotlin/com/webaddicted/ecommerce/`
- **Purpose:** ecommerce/ module
- **Files:** 1
  - `android/app/src/main/kotlin/com/webaddicted/ecommerce/MainActivity.kt`

### `android/app/src/main/res/drawable/`
- **Purpose:** drawable/ module
- **Files:** 1
  - `android/app/src/main/res/drawable/launch_background.xml`

### `android/app/src/main/res/drawable-v21/`
- **Purpose:** drawable-v21/ module
- **Files:** 1
  - `android/app/src/main/res/drawable-v21/launch_background.xml`

### `android/app/src/main/res/values/`
- **Purpose:** values/ module
- **Files:** 1
  - `android/app/src/main/res/values/styles.xml`

### `android/app/src/main/res/values-night/`
- **Purpose:** values-night/ module
- **Files:** 1
  - `android/app/src/main/res/values-night/styles.xml`

### `android/app/src/profile/`
- **Purpose:** profile/ module
- **Files:** 1
  - `android/app/src/profile/AndroidManifest.xml`

### `android/gradle/wrapper/`
- **Purpose:** wrapper/ module
- **Files:** 1
  - `android/gradle/wrapper/gradle-wrapper.properties`

### `assets/fonts/`
- **Purpose:** fonts/ module
- **Files:** 8
  - `assets/fonts/Nunito-Medium.ttf`
  - `assets/fonts/Nunito-ExtraBold.ttf`
  - `assets/fonts/Nunito-Light.ttf`
  - `assets/fonts/Nunito-Regular.ttf`
  - `assets/fonts/Nunito-SemiBold.ttf`
  - `assets/fonts/Nunito-Bold.ttf`
  - `assets/fonts/Nunito-Black.ttf`
  - `assets/fonts/Nunito-ExtraLight.ttf`

### `doc/`
- **Purpose:** Project documentation
- **Files:** 2
  - `doc/ARCHITECTURE.md`
  - `doc/screens.md`

### `lib/`
- **Purpose:** Dart application source
- **Files:** 1
  - `lib/main.dart`

### `lib/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 3
  - `lib/controller/theme_controller.dart`
  - `lib/controller/initial_binding.dart`
  - `lib/controller/routes.dart`

### `lib/data/repositories/`
- **Purpose:** repositories/ module
- **Files:** 1
  - `lib/data/repositories/admin_repository.dart`

### `lib/features/about/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 1
  - `lib/features/about/presentation/about_us_page.dart`

### `lib/features/address/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/address/controller/address_controller.dart`

### `lib/features/address/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 3
  - `lib/features/address/presentation/add_address_page.dart`
  - `lib/features/address/presentation/address_list_page.dart`
  - `lib/features/address/presentation/edit_address_page.dart`

### `lib/features/admin/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 12
  - `lib/features/admin/presentation/admin_users_screen.dart`
  - `lib/features/admin/presentation/admin_product_form_screen.dart`
  - `lib/features/admin/presentation/admin_notifications_screen.dart`
  - `lib/features/admin/presentation/admin_reviews_screen.dart`
  - `lib/features/admin/presentation/admin_payments_screen.dart`
  - `lib/features/admin/presentation/admin_orders_screen.dart`
  - `lib/features/admin/presentation/admin_banners_screen.dart`
  - `lib/features/admin/presentation/admin_shell_screen.dart`
  - `lib/features/admin/presentation/admin_products_screen.dart`
  - `lib/features/admin/presentation/admin_coupons_screen.dart`
  - `lib/features/admin/presentation/admin_dashboard_screen.dart`
  - `lib/features/admin/presentation/admin_categories_screen.dart`

### `lib/features/admin/widgets/`
- **Purpose:** widgets/ module
- **Files:** 2
  - `lib/features/admin/widgets/admin_access_gate.dart`
  - `lib/features/admin/widgets/admin_theme.dart`

### `lib/features/auth/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/auth/controller/auth_controller.dart`

### `lib/features/auth/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 2
  - `lib/features/auth/presentation/register_page.dart`
  - `lib/features/auth/presentation/login_page.dart`

### `lib/features/cart/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/cart/controller/cart_controller.dart`

### `lib/features/cart/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 1
  - `lib/features/cart/presentation/cart_page.dart`

### `lib/features/checkout/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/checkout/controller/checkout_controller.dart`

### `lib/features/checkout/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 2
  - `lib/features/checkout/presentation/order_success_page.dart`
  - `lib/features/checkout/presentation/checkout_page.dart`

### `lib/features/help/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 1
  - `lib/features/help/presentation/help_support_page.dart`

### `lib/features/home/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/home/controller/home_controller.dart`

### `lib/features/home/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 1
  - `lib/features/home/presentation/home_page.dart`

### `lib/features/home/presentation/widgets/`
- **Purpose:** widgets/ module
- **Files:** 4
  - `lib/features/home/presentation/widgets/banner_slider.dart`
  - `lib/features/home/presentation/widgets/section_header.dart`
  - `lib/features/home/presentation/widgets/category_section.dart`
  - `lib/features/home/presentation/widgets/product_card.dart`

### `lib/features/legal/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 2
  - `lib/features/legal/presentation/privacy_policy_page.dart`
  - `lib/features/legal/presentation/terms_condition_page.dart`

### `lib/features/main/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/main/controller/main_controller.dart`

### `lib/features/main/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 1
  - `lib/features/main/presentation/main_page.dart`

### `lib/features/main/presentation/widgets/`
- **Purpose:** widgets/ module
- **Files:** 2
  - `lib/features/main/presentation/widgets/web_side_menu.dart`
  - `lib/features/main/presentation/widgets/categories_tab.dart`

### `lib/features/notifications/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 1
  - `lib/features/notifications/presentation/notifications_page.dart`

### `lib/features/onboarding/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/onboarding/controller/onboarding_controller.dart`

### `lib/features/onboarding/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 1
  - `lib/features/onboarding/presentation/onboarding_page.dart`

### `lib/features/onboarding/presentation/widgets/`
- **Purpose:** widgets/ module
- **Files:** 2
  - `lib/features/onboarding/presentation/widgets/onboarding_center_logo.dart`
  - `lib/features/onboarding/presentation/widgets/onboarding_logo_header.dart`

### `lib/features/orders/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/orders/controller/order_controller.dart`

### `lib/features/orders/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 2
  - `lib/features/orders/presentation/orders_page.dart`
  - `lib/features/orders/presentation/order_detail_page.dart`

### `lib/features/product/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/product/controller/product_controller.dart`

### `lib/features/product/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 2
  - `lib/features/product/presentation/product_list_page.dart`
  - `lib/features/product/presentation/product_detail_page.dart`

### `lib/features/profile/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/profile/controller/profile_controller.dart`

### `lib/features/profile/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 2
  - `lib/features/profile/presentation/edit_profile_page.dart`
  - `lib/features/profile/presentation/profile_page.dart`

### `lib/features/search/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/search/controller/shop_search_controller.dart`

### `lib/features/search/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 1
  - `lib/features/search/presentation/search_page.dart`

### `lib/features/settings/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 1
  - `lib/features/settings/presentation/settings_page.dart`

### `lib/features/splash/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 1
  - `lib/features/splash/presentation/splash_page.dart`

### `lib/features/wishlist/controller/`
- **Purpose:** App-wide routing, bindings, controllers
- **Files:** 1
  - `lib/features/wishlist/controller/wishlist_controller.dart`

### `lib/features/wishlist/presentation/`
- **Purpose:** Screens, pages, and feature UI
- **Files:** 1
  - `lib/features/wishlist/presentation/wishlist_page.dart`

### `lib/global/apiutils/`
- **Purpose:** apiutils/ module
- **Files:** 3
  - `lib/global/apiutils/api_response.dart`
  - `lib/global/apiutils/http_overrides.dart`
  - `lib/global/apiutils/api_base_helper.dart`

### `lib/global/base/`
- **Purpose:** base/ module
- **Files:** 5
  - `lib/global/base/base_repository.dart`
  - `lib/global/base/base_stateless_widget.dart`
  - `lib/global/base/base_controller.dart`
  - `lib/global/base/base_service.dart`
  - `lib/global/base/base_stateful_widget.dart`

### `lib/global/constant/`
- **Purpose:** constant/ module
- **Files:** 9
  - `lib/global/constant/string_const.dart`
  - `lib/global/constant/db_const.dart`
  - `lib/global/constant/sp_const.dart`
  - `lib/global/constant/routers_const.dart`
  - `lib/global/constant/color_const.dart`
  - `lib/global/constant/enum_const.dart`
  - `lib/global/constant/app_constant.dart`
  - `lib/global/constant/api_const.dart`
  - `lib/global/constant/assets_const.dart`

### `lib/global/extension/`
- **Purpose:** extension/ module
- **Files:** 3
  - `lib/global/extension/context_extension.dart`
  - `lib/global/extension/string_extension.dart`
  - `lib/global/extension/datetime_extension.dart`

### `lib/global/services/`
- **Purpose:** Platform and integration services
- **Files:** 6
  - `lib/global/services/analytics_service.dart`
  - `lib/global/services/hive_service.dart`
  - `lib/global/services/auth_service.dart`
  - `lib/global/services/app_service.dart`
  - `lib/global/services/connectivity_service.dart`
  - `lib/global/services/storage_service.dart`

### `lib/global/sp/`
- **Purpose:** sp/ module
- **Files:** 2
  - `lib/global/sp/sp_helper.dart`
  - `lib/global/sp/sp_manager.dart`

### `lib/global/theme/`
- **Purpose:** theme/ module
- **Files:** 2
  - `lib/global/theme/text_style.dart`
  - `lib/global/theme/app_theme.dart`

### `lib/global/utils/`
- **Purpose:** Shared utilities and helpers
- **Files:** 13
  - `lib/global/utils/color_utils.dart`
  - `lib/global/utils/app_utils.dart`
  - `lib/global/utils/dialog_utils.dart`
  - `lib/global/utils/permission_utils.dart`
  - `lib/global/utils/file_utils.dart`
  - `lib/global/utils/web_url_stub.dart`
  - `lib/global/utils/web_url_helper.dart`
  - `lib/global/utils/performance_widgets.dart`
  - `lib/global/utils/widget_utils.dart`
  - `lib/global/utils/validation_utils.dart`
  - `lib/global/utils/resource_manager.dart`
  - `lib/global/utils/snackbar_utils.dart`
  - … +1 more

### `lib/global/widgets/`
- **Purpose:** widgets/ module
- **Files:** 12
  - `lib/global/widgets/empty_widget.dart`
  - `lib/global/widgets/app_bar_widget.dart`
  - `lib/global/widgets/glass_widgets.dart`
  - `lib/global/widgets/gradient_button.dart`
  - `lib/global/widgets/main_shell_app_bar.dart`
  - `lib/global/widgets/shimmer_widget.dart`
  - `lib/global/widgets/smart_image.dart`
  - `lib/global/widgets/responsive_layout.dart`
  - `lib/global/widgets/keep_alive_wrapper.dart`
  - `lib/global/widgets/loading_widget.dart`
  - `lib/global/widgets/custom_text_field.dart`
  - `lib/global/widgets/search_widget.dart`

### `lib/model/`
- **Purpose:** model/ module
- **Files:** 10
  - `lib/model/address_model.dart`
  - `lib/model/product_model.dart`
  - `lib/model/coupon_model.dart`
  - `lib/model/banner_model.dart`
  - `lib/model/cart_model.dart`
  - `lib/model/notification_broadcast_model.dart`
  - `lib/model/user_model.dart`
  - `lib/model/order_model.dart`
  - `lib/model/category_model.dart`
  - `lib/model/review_model.dart`

### `test/`
- **Purpose:** Automated tests
- **Files:** 1
  - `test/widget_test.dart`

### `web/`
- **Purpose:** Flutter web host and assets
- **Files:** 2
  - `web/index.html`
  - `web/manifest.json`
<!-- END AUTO-GENERATED:folders -->
