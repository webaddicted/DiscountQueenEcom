# App screens overview

Short reference for user-facing and admin screens in the ecom Flutter app (2–3 lines each).

---

## User

### SplashPage (`splash/presentation/splash_page.dart`)

Initial branded splash with gradient background shown at cold start. Schedules navigation to onboarding, login, or main shell based on stored preferences and auth state.

### OnboardingPage (`onboarding/presentation/onboarding_page.dart`)

First-launch intro flow that explains the app before sign-in. Completing or skipping persists state so returning users go straight to splash routing logic.

### LoginPage (`auth/presentation/login_page.dart`)

Email/password (or configured) sign-in for returning customers. Successful login routes into the main shopping shell with restored session.

### RegisterPage (`auth/presentation/register_page.dart`)

Account creation for new users with validation aligned to the auth backend. On success, typically navigates into the app or prompts verification per flow.

### MainPage (`main/presentation/main_page.dart`)

Primary shell with bottom navigation (mobile) or top navigation (desktop): Home, Categories, Cart, Wishlist, Profile in an `IndexedStack`. Hosts tab roots without resetting state when switching tabs.

### HomePage (`home/presentation/home_page.dart`)

Storefront home: promotional banners, category shortcuts, featured/popular/new product sections with pull-to-refresh and responsive grid/list layouts for phone vs wide screens.

### CategoriesTab (`main/presentation/widgets/categories_tab.dart`)

Dedicated “Categories” tab: browsable grid of product categories from `HomeController`. Entry point into filtered product listings when a category is selected.

### CartPage (`cart/presentation/cart_page.dart`)

Shopping cart review: line items, quantities, totals, and navigation to checkout. Syncs with `CartController` for reactive updates.

### WishlistPage (`wishlist/presentation/wishlist_page.dart`)

Saved products the user wants to track for later purchase or comparison. Uses wishlist state and supports moving items toward cart where applicable.

### ProfilePage (`profile/presentation/profile_page.dart`)

Account hub: shortcuts to orders, wishlist, addresses, notifications, settings, help, about, share, logout, and admin store entry when permitted.

### SearchPage (`search/presentation/search_page.dart`)

Product search with query input and results aligned to catalog data. Supports discovering items without browsing categories from home.

### ProductListPage (`product/presentation/product_list_page.dart`)

Filtered listing (e.g. by category or search) showing products in a scrollable grid/list. Entry from home sections, categories, or search.

### ProductDetailPage (`product/presentation/product_detail_page.dart`)

Single product view: images, price, description, variants if any, add-to-cart/wishlist actions. Primary PDP for commerce conversion.

### CheckoutPage (`checkout/presentation/checkout_page.dart`)

Checkout flow: delivery address selection, order summary, and payment-related UI wired through `CheckoutController` and cart totals.

### OrderSuccessPage (`checkout/presentation/order_success_page.dart`)

Post-checkout confirmation screen after a successful order placement. Reinforces completion and may route back to shopping or orders.

### OrdersPage (`orders/presentation/orders_page.dart`)

List of the signed-in user’s past and current orders with status summaries. Entry point to individual order detail.

### OrderDetailPage (`orders/presentation/order_detail_page.dart`)

Detailed view for one order: items, amounts, status timeline, and identifiers useful for support or tracking.

### AddressListPage (`address/presentation/address_list_page.dart`)

Manage saved shipping/billing addresses: pick default, edit, or add new. Used during checkout and profile maintenance.

### AddAddressPage (`address/presentation/add_address_page.dart`)

Form to create a new address record with validation. Saves into the user’s address book for reuse.

### EditAddressPage (`address/presentation/edit_address_page.dart`)

Update an existing saved address. Keeps checkout and profile flows consistent after moves or corrections.

### NotificationsPage (`notifications/presentation/notifications_page.dart`)

In-app notifications list for the shopper (promos, order updates, system messages depending on backend wiring).

### SettingsPage (`settings/presentation/settings_page.dart`)

App preferences such as theme, locale, or toggles exposed by the project. Central place for non-commerce configuration.

### EditProfilePage (`profile/presentation/edit_profile_page.dart`)

Edit profile fields (name, phone, avatar if supported). Persists changes through the profile/auth layer.

### HelpSupportPage (`help/presentation/help_support_page.dart`)

Help & support content: FAQs, contact options, or links as implemented. Supports customer self-service before contacting support.

### AboutUsPage (`about/presentation/about_us_page.dart`)

About the brand/app: mission, version, or company information for trust and transparency.

### PrivacyPolicyPage (`legal/presentation/privacy_policy_page.dart`)

Displays the privacy policy text for compliance and user clarity. Typically linked from settings or signup.

### TermsConditionPage (`legal/presentation/terms_condition_page.dart`)

Terms & conditions or end-user agreement. Shown for legal acceptance and reference from registration or settings.

---

## Admin

### AdminShellScreen (`admin/presentation/admin_shell_screen.dart`)

Admin landing hub wrapped in `AdminAccessGate`: large hero header and grid of shortcuts (Dashboard, Users, Products, Categories, Orders, Payments, Reviews, Banners, Coupons, Push drafts). Entry gate for all admin modules.

### AdminDashboardScreen (`admin/presentation/admin_dashboard_screen.dart`)

Operational overview with stat cards fed by `AdminRepository` (e.g. user count, order count, revenue-oriented metrics). Quick health snapshot for store administrators.

### AdminUsersScreen (`admin/presentation/admin_users_screen.dart`)

Customer directory: list users with roles (e.g. admin flag) and blocked state. Supports editing/saving user metadata for moderation and access control.

### AdminProductsScreen (`admin/presentation/admin_products_screen.dart`)

Catalog management table/list of products with create shortcut and delete. Navigates to the product form for add/edit.

### AdminProductFormScreen (`admin/presentation/admin_product_form_screen.dart`)

Create or edit a single product: pricing, inventory, images, flags (featured, popular, new arrival), and save/delete. Core CMS surface for merchandise.

### AdminCategoriesScreen (`admin/presentation/admin_categories_screen.dart`)

Manage product categories: name, visibility/active state, ordering as modeled. Ensures storefront navigation stays organized.

### AdminOrdersScreen (`admin/presentation/admin_orders_screen.dart`)

Operational order queue: view orders and update fulfillment status through dialogs. Keeps customer-facing status in sync with operations.

### AdminPaymentsScreen (`admin/presentation/admin_payments_screen.dart`)

Payment records overview for reconciliation (amounts, methods, related references as modeled). Empty state when no records exist.

### AdminReviewsScreen (`admin/presentation/admin_reviews_screen.dart`)

Moderate customer reviews: visibility/content adjustments or removal. Helps maintain catalog trust and policy compliance.

### AdminBannersScreen (`admin/presentation/admin_banners_screen.dart`)

Home banner CMS: title, subtitle, imagery, sort order, active toggles. Controls promotional slots on the shopper home experience.

### AdminCouponsScreen (`admin/presentation/admin_coupons_screen.dart`)

Discount coupon lifecycle: create/edit codes, discount rules, expiry, and active flag. Supports marketing campaigns tied to checkout.

### AdminNotificationsScreen (`admin/presentation/admin_notifications_screen.dart`)

Push notification drafts: compose messages, save drafts, and mark sent for records. Prepares broadcast or targeted pushes depending on backend integration.
