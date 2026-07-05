# Flutter Project — Architecture & Initial Setup Document

> **Purpose:** Provide this document when creating a **new Flutter project**. An AI assistant (or developer) will generate every file listed here — producing a production-ready scaffold with base classes, API layer, storage, theme (light/dark toggle), permissions, dialogs, constants, extensions, utilities, reusable widgets, and the app entry point.
>
> Replace all `{{APP_NAME}}`, `{{PACKAGE_NAME}}`, and other `{{PLACEHOLDER}}` values with your actual project info before generation.

---

## Table of Contents

1. [Project Config & Placeholders](#1-project-config--placeholders)
2. [Tech Stack & Packages](#2-tech-stack--packages)
3. [Folder Structure](#3-folder-structure)
4. [Constants (`lib/global/constant/`)](#4-constants) — 9 files
5. [Theme (`lib/global/theme/`)](#5-theme) — 2 files
6. [Extensions (`lib/global/extension/`)](#6-extensions) — 3 files
7. [SharedPreferences (`lib/global/sp/`)](#7-sharedpreferences) — 3 files
8. [API Layer (`lib/global/apiutils/`)](#8-api-layer) — 3 files
9. [Base Classes (`lib/global/base/`)](#9-base-classes) — 5 files
10. [Services (`lib/global/services/`)](#10-services) — 6 files
11. [Utilities (`lib/global/utils/`)](#11-utilities) — 10 files
12. [Reusable Widgets (`lib/global/widgets/`)](#12-reusable-widgets) — 10 files
13. [Controllers & Routing (`lib/controller/`)](#13-controllers--routing) — 3 files
14. [App Entry Point (`lib/main.dart`)](#14-app-entry-point) — 1 file
15. [Feature Module Template](#15-feature-module-template)
16. [Design Rules](#16-design-rules)
17. [File Generation Checklist](#17-file-generation-checklist)

---

## 1. Project Config & Placeholders

Before generating, fill in these values:

```
APP_NAME          = {{APP_NAME}}           # e.g. "MyApp"
PACKAGE_NAME      = {{PACKAGE_NAME}}       # e.g. "my_app"
APP_TAGLINE       = {{APP_TAGLINE}}        # e.g. "Your tagline here"
APP_DESCRIPTION   = {{APP_DESCRIPTION}}    # Short app description
BASE_URL          = {{BASE_URL}}           # e.g. "https://api.example.com/v1"
SUPPORT_EMAIL     = {{SUPPORT_EMAIL}}      # e.g. "support@example.com"
WEBSITE_URL       = {{WEBSITE_URL}}        # e.g. "https://example.com"
PRIVACY_URL       = {{PRIVACY_URL}}        # Privacy policy URL
TERMS_URL         = {{TERMS_URL}}          # Terms of service URL
PLAY_STORE_URL    = {{PLAY_STORE_URL}}     # Google Play URL
APP_STORE_URL     = {{APP_STORE_URL}}      # Apple App Store URL
PRIMARY_COLOR     = {{PRIMARY_COLOR}}      # e.g. "0xFF667EEA"
SECONDARY_COLOR   = {{SECONDARY_COLOR}}    # e.g. "0xFF764BA2"
ACCENT_COLOR      = {{ACCENT_COLOR}}       # e.g. "0xFF00C9FF"
USE_FIREBASE      = {{true/false}}         # Enable Firebase integration
USE_IAP           = {{true/false}}         # Enable in-app purchases
```

---

## 2. Tech Stack & Packages

### `pubspec.yaml` dependencies

```yaml
name: {{PACKAGE_NAME}}
description: {{APP_DESCRIPTION}}
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # State Management & DI
  get: ^4.7.3

  # Networking
  dio: ^5.9.1
  connectivity_plus: ^7.0.0

  # Local Storage
  shared_preferences: ^2.5.4
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Images & Cache
  cached_network_image: ^3.4.1
  flutter_cache_manager: ^3.4.1
  image_picker: ^1.2.1
  flutter_image_compress: ^2.4.0
  shimmer: ^3.0.0

  # Device & Platform
  device_info_plus: ^12.3.0
  package_info_plus: ^9.0.0
  permission_handler: ^12.0.1

  # Utilities
  url_launcher: ^6.3.2
  share_plus: ^12.0.1
  path_provider: ^2.1.5
  intl: ^0.20.2
  logger: ^2.6.2
  flutter_dotenv: ^6.0.0

  # Firebase (conditional — include if USE_FIREBASE = true)
  # firebase_core: ^4.4.0
  # firebase_auth: ^6.1.4
  # cloud_firestore: ^6.1.2
  # firebase_storage: ^13.0.6
  # firebase_analytics: ^12.1.1
  # firebase_crashlytics: ^5.0.7
  # google_sign_in: ^6.2.1

  # In-App Purchase (conditional — include if USE_IAP = true)
  # in_app_purchase: ^3.2.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

### `analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_declarations: true
    avoid_print: true
```

### `.env`

```
BASE_URL={{BASE_URL}}
API_KEY={{API_KEY}}
```

---

## 3. Folder Structure

```
lib/
├── main.dart                          # App entry point
│
├── controller/                        # App-level GetX controllers & routing
│   ├── initial_binding.dart           # GetX dependency injection
│   ├── routes.dart                    # Route definitions (GetPage list)
│   └── theme_controller.dart          # Light/Dark theme toggle with persistence
│
├── global/                            # Shared infrastructure (non-feature code)
│   ├── constant/                      # All app-wide constants
│   │   ├── app_constant.dart          # Branding, URLs, config
│   │   ├── api_const.dart             # API endpoints, base URL, timeout
│   │   ├── assets_const.dart          # Asset file paths
│   │   ├── color_const.dart           # Color palette (colorFF{HexCode} format)
│   │   ├── db_const.dart              # Database/collection/box names
│   │   ├── routers_const.dart         # Named route path constants
│   │   ├── string_const.dart          # UI string literals
│   │   ├── sp_const.dart              # SharedPreferences key constants
│   │   └── enum_const.dart            # App-wide enums
│   │
│   ├── theme/                         # Theming system
│   │   ├── app_theme.dart             # ThemeData (light + dark), DesignTokens
│   │   └── text_style.dart            # AppTextStyle — full typography scale
│   │
│   ├── extension/                     # Dart extension methods
│   │   ├── string_extension.dart      # String helpers
│   │   ├── context_extension.dart     # BuildContext helpers
│   │   └── datetime_extension.dart    # DateTime helpers
│   │
│   ├── sp/                            # SharedPreferences layer
│   │   ├── sp_helper.dart             # Low-level SP wrapper (init, get, set)
│   │   └── sp_manager.dart            # Domain-specific SP API (theme, user, etc.)
│   │
│   ├── apiutils/                      # Network / API layer
│   │   ├── api_base_helper.dart       # Dio HTTP client with interceptors
│   │   ├── api_response.dart          # ApiResponse<T> state wrapper + Result<T>
│   │   └── http_overrides.dart        # Global HTTP certificate overrides
│   │
│   ├── base/                          # Base classes & mixins
│   │   ├── base_controller.dart       # Abstract GetxController base
│   │   ├── base_repository.dart       # Abstract repository + Result<T> + Cacheable
│   │   ├── base_service.dart          # Abstract GetxService base
│   │   ├── base_stateful_widget.dart  # BaseStatefulWidget + BaseState<T>
│   │   └── base_stateless_widget.dart # BaseStatelessWidget with context helpers
│   │
│   ├── services/                      # Singleton services
│   │   ├── hive_service.dart          # Hive init and CRUD
│   │   ├── storage_service.dart       # File storage (Firebase or local)
│   │   ├── analytics_service.dart     # Analytics facade
│   │   ├── auth_service.dart          # Auth facade
│   │   ├── connectivity_service.dart  # Internet connectivity monitor
│   │   └── app_service.dart           # App lifecycle (init, version check)
│   │
│   ├── utils/                         # Utility helpers
│   │   ├── app_utils.dart             # General utilities (isEmpty, logging, launch URL, share)
│   │   ├── dialog_utils.dart          # Reusable dialogs and bottom sheets
│   │   ├── permission_utils.dart      # Permission handling with PermissionType enum
│   │   ├── validation_utils.dart      # Form validators (email, password, mobile, etc.)
│   │   ├── color_utils.dart           # Color manipulation (darken, lighten, parse hex)
│   │   ├── date_utils.dart            # Date formatting, parsing, relative time
│   │   ├── file_utils.dart            # File system helpers
│   │   ├── snackbar_utils.dart        # Typed snackbars (success, error, warning, info)
│   │   ├── widget_utils.dart          # Common widget builders (buttons, text, dividers)
│   │   └── resource_manager.dart      # Auto-dispose mixin for subscriptions, timers, controllers
│   │
│   └── widgets/                       # Reusable UI components
│       ├── smart_image.dart           # Universal image widget (network, asset, file, placeholder)
│       ├── app_bar_widget.dart        # Custom AppBar variants
│       ├── search_widget.dart         # Floating search bar
│       ├── loading_widget.dart        # Loading states (shimmer + spinner)
│       ├── shimmer_widget.dart        # Shimmer placeholders
│       ├── empty_widget.dart          # Empty / no-data / error states
│       ├── glass_widgets.dart         # Glassmorphism toolkit (buttons, containers)
│       ├── custom_text_field.dart     # Styled text field wrapper
│       ├── gradient_button.dart       # Gradient action button
│       └── keep_alive_wrapper.dart    # AutomaticKeepAlive wrapper
│
├── model/                             # Shared data models
│   └── (add models as features grow)
│
└── features/                          # Feature modules (Clean Architecture per feature)
    └── (add features using template in Section 15)
```

---

## 4. Constants

**Directory:** `lib/global/constant/`
**Total files:** 9

### 4.1 `app_constant.dart`

```dart
class AppConstant {
  AppConstant._();

  static const String appName = '{{APP_NAME}}';
  static const String appTagline = '{{APP_TAGLINE}}';
  static const String appDescription = '{{APP_DESCRIPTION}}';
  static const String appVersion = '1.0.0';

  static const String supportEmail = '{{SUPPORT_EMAIL}}';
  static const String websiteUrl = '{{WEBSITE_URL}}';
  static const String privacyPolicyUrl = '{{PRIVACY_URL}}';
  static const String termsUrl = '{{TERMS_URL}}';
  static const String playStoreUrl = '{{PLAY_STORE_URL}}';
  static const String appStoreUrl = '{{APP_STORE_URL}}';
}
```

### 4.2 `api_const.dart`

```dart
class ApiConstant {
  ApiConstant._();

  static const String baseUrl = '{{BASE_URL}}';
  static const Duration timeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // User
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update';

  // Error messages
  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternetConnection = 'No internet connection';
  static const String sessionExpired = 'Session expired. Please login again';
  static const String serverError = 'Server error. Please try again later';

  // Add feature-specific endpoints here as project grows
}
```

### 4.3 `assets_const.dart`

```dart
class AssetsConst {
  AssetsConst._();

  static const String _imagePath = 'assets/images';
  static const String _iconPath = 'assets/icons';
  static const String _animPath = 'assets/animations';

  // Logo & branding
  static const String appLogo = '$_imagePath/logo.png';
  static const String appLogoLight = '$_imagePath/logo_light.png';
  static const String appLogoDark = '$_imagePath/logo_dark.png';

  // Placeholders
  static const String placeholder = '$_imagePath/placeholder.png';
  static const String avatarPlaceholder = '$_imagePath/avatar_placeholder.png';
  static const String emptyState = '$_imagePath/empty_state.png';
  static const String errorState = '$_imagePath/error_state.png';
  static const String noInternet = '$_imagePath/no_internet.png';

  // Onboarding
  static const String onboarding1 = '$_imagePath/onboarding_1.png';
  static const String onboarding2 = '$_imagePath/onboarding_2.png';
  static const String onboarding3 = '$_imagePath/onboarding_3.png';

  // Icons
  static const String icGoogle = '$_iconPath/ic_google.png';
  static const String icApple = '$_iconPath/ic_apple.png';
}
```

### 4.4 `color_const.dart`

All colors accessed via `ColorConst.colorFF{HexCode}`. Never use `Color(0xFF...)` directly in UI. Never create local color variables.

```dart
import 'package:flutter/material.dart';

class ColorConst {
  ColorConst._();

  // Brand
  static const Color appColor = Color({{PRIMARY_COLOR}});
  static const Color primaryColor = Color({{PRIMARY_COLOR}});
  static const Color secondaryColor = Color({{SECONDARY_COLOR}});
  static const Color accentColor = Color({{ACCENT_COLOR}});

  // Base
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;

  // Hex-format colors (naming: colorFF{HexCode})
  static const Color colorFFFFFFFF = Color(0xFFFFFFFF);
  static const Color colorFF000000 = Color(0xFF000000);
  static const Color colorFF667EEA = Color(0xFF667EEA);
  static const Color colorFF764BA2 = Color(0xFF764BA2);
  static const Color colorFF00C9FF = Color(0xFF00C9FF);
  static const Color colorFFE53935 = Color(0xFFE53935);  // red
  static const Color colorFF43A047 = Color(0xFF43A047);  // green
  static const Color colorFFFDD835 = Color(0xFFFDD835);  // yellow
  static const Color colorFF9E9E9E = Color(0xFF9E9E9E);  // grey
  static const Color colorFFF5F5F5 = Color(0xFFF5F5F5);  // light grey bg
  static const Color colorFF1A1A2E = Color(0xFF1A1A2E);  // dark bg
  static const Color colorFF16213E = Color(0xFF16213E);  // dark surface
  static const Color colorFF0F3460 = Color(0xFF0F3460);  // dark card
  static const Color colorFFE94560 = Color(0xFFE94560);  // accent red
  static const Color colorFF3B5998 = Color(0xFF3B5998);  // facebook
  static const Color colorFFDB4437 = Color(0xFFDB4437);  // google
  static const Color colorFF1DA1F2 = Color(0xFF1DA1F2);  // twitter

  // Add more as needed — always follow colorFF{HexCode} naming
}

// Top-level helpers
Color colorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll('#', '').replaceAll('0x', '');
  if (hexColor.length == 6) hexColor = 'FF$hexColor';
  return Color(int.parse(hexColor, radix: 16));
}
```

### 4.5 `db_const.dart`

```dart
class DbConst {
  DbConst._();

  // Hive box names
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';
  static const String userBox = 'user';

  // Add Firestore collection names or SQLite table names as needed
}
```

### 4.6 `routers_const.dart`

```dart
class RoutersConst {
  RoutersConst._();

  static const String initialRoute = '/';

  // Common routes (every app needs these)
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsCondition = '/terms-condition';
  static const String aboutUs = '/about-us';
  static const String helpSupport = '/help-support';

  // Add feature-specific routes as project grows
}
```

### 4.7 `string_const.dart`

```dart
class StringConst {
  StringConst._();

  // App
  static String get appName => AppConstant.appName;

  // Common actions
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String retry = 'Retry';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String skip = 'Skip';
  static const String submit = 'Submit';
  static const String confirm = 'Confirm';
  static const String close = 'Close';
  static const String search = 'Search';
  static const String share = 'Share';
  static const String download = 'Download';
  static const String logout = 'Logout';
  static const String login = 'Login';
  static const String signUp = 'Sign Up';
  static const String continueText = 'Continue';
  static const String getStarted = 'Get Started';

  // Errors
  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternetConnection = 'No internet connection';
  static const String noDataFound = 'No data found';
  static const String sessionExpired = 'Session expired';
  static const String serverError = 'Server error';
  static const String unknownError = 'Unknown error occurred';
  static const String timeoutError = 'Connection timed out';

  // Form
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Invalid email address';
  static const String invalidPassword = 'Password must be at least 6 characters';
  static const String invalidPhone = 'Invalid phone number';
  static const String passwordMismatch = 'Passwords do not match';

  // Dialog
  static const String logoutConfirmTitle = 'Logout';
  static const String logoutConfirmMessage = 'Are you sure you want to logout?';
  static const String deleteConfirmTitle = 'Delete';
  static const String deleteConfirmMessage = 'Are you sure? This action cannot be undone.';
  static const String permissionRequired = 'Permission Required';
  static const String permissionSettingMsg = 'Please enable permission from settings';

  // Success
  static const String profileUpdated = 'Profile updated successfully';
  static const String savedSuccessfully = 'Saved successfully';
}
```

### 4.8 `sp_const.dart`

```dart
class SPConst {
  SPConst._();

  // Onboarding
  static const String isOnBoardingShown = 'is_onboarding_shown';

  // Theme
  static const String isThemeDark = 'is_theme_dark';

  // Auth
  static const String isLoggedIn = 'is_logged_in';
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';

  // User
  static const String userId = 'user_id';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userPhotoUrl = 'user_photo_url';
  static const String userData = 'user_data';

  // App
  static const String lastDataLoadTime = 'last_data_load_time';
  static const String appLanguage = 'app_language';
  static const String notificationsEnabled = 'notifications_enabled';

  // Add more keys as needed
}
```

### 4.9 `enum_const.dart`

```dart
// App-wide enums shared across features

enum LoadingState { idle, loading, success, error }
enum ViewMode { list, grid }
enum SortOrder { ascending, descending, newest, oldest }
enum AuthProvider { email, google, apple }
enum ImageSource { camera, gallery }
```

---

## 5. Theme

**Directory:** `lib/global/theme/`
**Total files:** 2

### 5.1 `app_theme.dart`

```dart
import 'package:flutter/material.dart';
import 'package:{{PACKAGE_NAME}}/global/constant/color_const.dart';

class DesignTokens {
  DesignTokens._();

  // Spacing (8px grid)
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing6 = 6;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing48 = 48;
  static const double spacing64 = 64;

  // Border radius
  static const double radius4 = 4;
  static const double radius8 = 8;
  static const double radius12 = 12;
  static const double radius16 = 16;
  static const double radius24 = 24;
  static const double radius32 = 32;
  static const double radiusCircular = 100;

  // Elevation
  static const double elevationNone = 0;
  static const double elevationSmall = 2;
  static const double elevationMedium = 4;
  static const double elevationLarge = 8;

  // Shadows
  static List<BoxShadow> get shadowSmall => [
    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
  ];
  static List<BoxShadow> get shadowMedium => [
    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
  ];
  static List<BoxShadow> get shadowLarge => [
    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 16, offset: const Offset(0, 8)),
  ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [ColorConst.primaryColor, ColorConst.secondaryColor],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
  );
}

ThemeData lightThemeData(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: ColorConst.primaryColor,
    scaffoldBackgroundColor: ColorConst.colorFFF5F5F5,
    colorScheme: ColorScheme.light(
      primary: ColorConst.primaryColor,
      secondary: ColorConst.secondaryColor,
      surface: ColorConst.colorFFFFFFFF,
      error: ColorConst.colorFFE53935,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: ColorConst.colorFFFFFFFF,
      foregroundColor: ColorConst.colorFF000000,
      titleTextStyle: TextStyle(color: ColorConst.colorFF000000, fontSize: 18, fontWeight: FontWeight.w600),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radius12)),
      color: ColorConst.colorFFFFFFFF,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConst.primaryColor,
        foregroundColor: ColorConst.colorFFFFFFFF,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radius8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConst.primaryColor,
        side: BorderSide(color: ColorConst.primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radius8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorConst.colorFFFFFFFF,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(DesignTokens.radius8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius8),
        borderSide: BorderSide(color: ColorConst.primaryColor, width: 1.5),
      ),
    ),
    dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 1),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: ColorConst.primaryColor,
    scaffoldBackgroundColor: ColorConst.colorFF1A1A2E,
    colorScheme: ColorScheme.dark(
      primary: ColorConst.primaryColor,
      secondary: ColorConst.secondaryColor,
      surface: ColorConst.colorFF16213E,
      error: ColorConst.colorFFE94560,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: ColorConst.colorFF1A1A2E,
      foregroundColor: ColorConst.colorFFFFFFFF,
      titleTextStyle: TextStyle(color: ColorConst.colorFFFFFFFF, fontSize: 18, fontWeight: FontWeight.w600),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radius12)),
      color: ColorConst.colorFF16213E,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConst.primaryColor,
        foregroundColor: ColorConst.colorFFFFFFFF,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radius8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConst.primaryColor,
        side: BorderSide(color: ColorConst.primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radius8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorConst.colorFF0F3460,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(DesignTokens.radius8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius8),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius8),
        borderSide: BorderSide(color: ColorConst.primaryColor, width: 1.5),
      ),
    ),
    dividerTheme: DividerThemeData(color: Colors.grey.shade800, thickness: 1),
  );
}
```

### 5.2 `text_style.dart`

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  AppTextStyle._();

  // Platform-adjusted font sizes
  static double get fontSize8 => kIsWeb ? 10 : 8;
  static double get fontSize10 => kIsWeb ? 12 : 10;
  static double get fontSize12 => kIsWeb ? 14 : 12;
  static double get fontSize14 => kIsWeb ? 16 : 14;
  static double get fontSize16 => kIsWeb ? 18 : 16;
  static double get fontSize18 => kIsWeb ? 20 : 18;
  static double get fontSize20 => kIsWeb ? 22 : 20;
  static double get fontSize24 => kIsWeb ? 26 : 24;
  static double get fontSize28 => kIsWeb ? 30 : 28;
  static double get fontSize32 => kIsWeb ? 34 : 32;

  // Material 3 Typography Scale
  static TextStyle get displayLarge => TextStyle(fontSize: fontSize32, fontWeight: FontWeight.bold);
  static TextStyle get displayMedium => TextStyle(fontSize: fontSize28, fontWeight: FontWeight.bold);
  static TextStyle get displaySmall => TextStyle(fontSize: fontSize24, fontWeight: FontWeight.bold);
  static TextStyle get headlineLarge => TextStyle(fontSize: fontSize24, fontWeight: FontWeight.w600);
  static TextStyle get headlineMedium => TextStyle(fontSize: fontSize20, fontWeight: FontWeight.w600);
  static TextStyle get headlineSmall => TextStyle(fontSize: fontSize18, fontWeight: FontWeight.w600);
  static TextStyle get titleLarge => TextStyle(fontSize: fontSize20, fontWeight: FontWeight.w600);
  static TextStyle get titleMedium => TextStyle(fontSize: fontSize16, fontWeight: FontWeight.w600);
  static TextStyle get titleSmall => TextStyle(fontSize: fontSize14, fontWeight: FontWeight.w600);
  static TextStyle get bodyLarge => TextStyle(fontSize: fontSize16, fontWeight: FontWeight.normal);
  static TextStyle get bodyMedium => TextStyle(fontSize: fontSize14, fontWeight: FontWeight.normal);
  static TextStyle get bodySmall => TextStyle(fontSize: fontSize12, fontWeight: FontWeight.normal);
  static TextStyle get labelLarge => TextStyle(fontSize: fontSize14, fontWeight: FontWeight.w500);
  static TextStyle get labelMedium => TextStyle(fontSize: fontSize12, fontWeight: FontWeight.w500);
  static TextStyle get labelSmall => TextStyle(fontSize: fontSize10, fontWeight: FontWeight.w500);

  // Semantic styles
  static TextStyle get caption => TextStyle(fontSize: fontSize10, color: Colors.grey);
  static TextStyle get overline => TextStyle(fontSize: fontSize8, letterSpacing: 1.5, fontWeight: FontWeight.w500);
  static TextStyle get buttonText => TextStyle(fontSize: fontSize14, fontWeight: FontWeight.w600);
  static TextStyle get cardTitle => titleMedium;
  static TextStyle get cardSubtitle => bodySmall;
  static TextStyle get inputLabel => labelMedium;
  static TextStyle get inputHint => TextStyle(fontSize: fontSize14, color: Colors.grey);
  static TextStyle get inputText => TextStyle(fontSize: fontSize14);
  static TextStyle get errorText => TextStyle(fontSize: fontSize12, color: Colors.red);
  static TextStyle get successText => TextStyle(fontSize: fontSize12, color: Colors.green);
  static TextStyle get warningText => TextStyle(fontSize: fontSize12, color: Colors.orange);
}
```

**Rule:** Titles use `AppTextStyle.titleMedium`, subtitles use `AppTextStyle.bodyMedium`, text fields use `fontSize: 14`. Never use raw `TextStyle(fontSize: ...)` in UI.

---

## 6. Extensions

**Directory:** `lib/global/extension/`
**Total files:** 3

### 6.1 `string_extension.dart`

```dart
extension StringExtension on String {
  // Null/empty safety
  bool get isNullOrEmpty => trim().isEmpty;
  bool get isNotNullOrEmpty => trim().isNotEmpty;

  // Formatting
  String get capitalize => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
  String get capitalizeEachWord => split(' ').map((w) => w.capitalize).join(' ');
  String get initials => split(' ').where((w) => w.isNotEmpty).map((w) => w[0].toUpperCase()).take(2).join();

  // Validation
  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  bool get isValidPhone => RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(this);
  bool get isValidUrl => Uri.tryParse(this)?.hasAbsolutePath ?? false;
  bool get isNumeric => double.tryParse(this) != null;

  // Parsing
  int? get toIntOrNull => int.tryParse(this);
  double? get toDoubleOrNull => double.tryParse(this);
  Color get toColor => colorFromHex(this);

  // Truncation
  String truncate(int maxLength, {String suffix = '...'}) =>
    length <= maxLength ? this : '${substring(0, maxLength)}$suffix';
}
```

### 6.2 `context_extension.dart`

```dart
extension ContextExtension on BuildContext {
  // Size
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // Safe area
  EdgeInsets get safePadding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  // Actions
  void hideKeyboard() => FocusScope.of(this).unfocus();

  // Responsive breakpoints
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;
}
```

### 6.3 `datetime_extension.dart`

```dart
extension DateTimeExtension on DateTime {
  // Formatting (uses intl package)
  String get formatted => DateFormat('dd MMM yyyy').format(this);
  String get formattedWithTime => DateFormat('dd MMM yyyy, hh:mm a').format(this);
  String get timeOnly => DateFormat('hh:mm a').format(this);
  String get dateOnly => DateFormat('yyyy-MM-dd').format(this);

  // Relative time
  String get relativeTime {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  // Checks
  bool get isToday => DateUtils.isSameDay(this, DateTime.now());
  bool get isYesterday => DateUtils.isSameDay(this, DateTime.now().subtract(const Duration(days: 1)));
  bool get isTomorrow => DateUtils.isSameDay(this, DateTime.now().add(const Duration(days: 1)));
  bool get isThisWeek => difference(DateTime.now()).inDays.abs() < 7;

  // Utilities
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  int daysBetween(DateTime other) => difference(other).inDays.abs();
}
```

---

## 7. SharedPreferences

**Directory:** `lib/global/sp/`
**Total files:** 2 (keys live in `constant/sp_const.dart`)

### 7.1 `sp_helper.dart` — Low-Level Wrapper

```dart
import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  static SharedPreferences? _prefs;

  /// Must be called in main() before runApp
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Typed get with default
  static T? getPreference<T>(String key, T defaultValue) {
    if (_prefs == null) return defaultValue;
    switch (T) {
      case const (String): return (_prefs!.getString(key) ?? defaultValue) as T;
      case const (bool): return (_prefs!.getBool(key) ?? defaultValue) as T;
      case const (int): return (_prefs!.getInt(key) ?? defaultValue) as T;
      case const (double): return (_prefs!.getDouble(key) ?? defaultValue) as T;
      case const (List<String>): return (_prefs!.getStringList(key) ?? defaultValue) as T;
      default: return defaultValue;
    }
  }

  // Typed set
  static Future<bool> setPreference<T>(String key, T value) async {
    if (_prefs == null) return false;
    switch (T) {
      case const (String): return _prefs!.setString(key, value as String);
      case const (bool): return _prefs!.setBool(key, value as bool);
      case const (int): return _prefs!.setInt(key, value as int);
      case const (double): return _prefs!.setDouble(key, value as double);
      case const (List<String>): return _prefs!.setStringList(key, value as List<String>);
      default: return false;
    }
  }

  // Management
  static Set<String> getAllKeys() => _prefs?.getKeys() ?? {};
  static Future<bool> removeKey(String key) async => await _prefs?.remove(key) ?? false;
  static Future<bool> clearAll() async => await _prefs?.clear() ?? false;
  static bool keyExists(String key) => _prefs?.containsKey(key) ?? false;

  // Batch operations
  static Future<void> setBatch(Map<String, dynamic> values) async {
    for (final entry in values.entries) {
      if (entry.value is String) await _prefs?.setString(entry.key, entry.value);
      else if (entry.value is bool) await _prefs?.setBool(entry.key, entry.value);
      else if (entry.value is int) await _prefs?.setInt(entry.key, entry.value);
      else if (entry.value is double) await _prefs?.setDouble(entry.key, entry.value);
    }
  }
}
```

### 7.2 `sp_manager.dart` — Domain-Specific API

```dart
class SPManager {
  SPManager._();

  // Theme
  static Future<void> setTheme(bool isDark) => SPHelper.setPreference(SPConst.isThemeDark, isDark);
  static bool getTheme() => SPHelper.getPreference<bool>(SPConst.isThemeDark, false)!;

  // Onboarding
  static Future<void> setOnboardingShown(bool shown) => SPHelper.setPreference(SPConst.isOnBoardingShown, shown);
  static bool isOnboardingShown() => SPHelper.getPreference<bool>(SPConst.isOnBoardingShown, false)!;

  // Auth
  static Future<void> setLoggedIn(bool value) => SPHelper.setPreference(SPConst.isLoggedIn, value);
  static bool isLoggedIn() => SPHelper.getPreference<bool>(SPConst.isLoggedIn, false)!;
  static Future<void> setAccessToken(String token) => SPHelper.setPreference(SPConst.accessToken, token);
  static String getAccessToken() => SPHelper.getPreference<String>(SPConst.accessToken, '')!;
  static Future<void> setRefreshToken(String token) => SPHelper.setPreference(SPConst.refreshToken, token);
  static String getRefreshToken() => SPHelper.getPreference<String>(SPConst.refreshToken, '')!;

  // User
  static Future<void> setUserId(String id) => SPHelper.setPreference(SPConst.userId, id);
  static String getUserId() => SPHelper.getPreference<String>(SPConst.userId, '')!;
  static Future<void> setUserName(String name) => SPHelper.setPreference(SPConst.userName, name);
  static String getUserName() => SPHelper.getPreference<String>(SPConst.userName, '')!;
  static Future<void> setUserEmail(String email) => SPHelper.setPreference(SPConst.userEmail, email);
  static String getUserEmail() => SPHelper.getPreference<String>(SPConst.userEmail, '')!;
  static Future<void> setUserPhotoUrl(String url) => SPHelper.setPreference(SPConst.userPhotoUrl, url);
  static String getUserPhotoUrl() => SPHelper.getPreference<String>(SPConst.userPhotoUrl, '')!;

  // Convenience
  static Future<void> saveLoginDetails({
    required String userId, required String name, required String email, String photoUrl = '',
  }) async {
    await Future.wait([
      setLoggedIn(true), setUserId(userId), setUserName(name), setUserEmail(email), setUserPhotoUrl(photoUrl),
    ]);
  }

  static Future<void> clearLoginDetails() async {
    await Future.wait([
      setLoggedIn(false), SPHelper.removeKey(SPConst.accessToken), SPHelper.removeKey(SPConst.refreshToken),
      SPHelper.removeKey(SPConst.userId), SPHelper.removeKey(SPConst.userName),
      SPHelper.removeKey(SPConst.userEmail), SPHelper.removeKey(SPConst.userPhotoUrl),
    ]);
  }

  // App settings
  static Future<void> setLanguage(String lang) => SPHelper.setPreference(SPConst.appLanguage, lang);
  static String getLanguage() => SPHelper.getPreference<String>(SPConst.appLanguage, 'en')!;
  static Future<void> setNotificationsEnabled(bool enabled) => SPHelper.setPreference(SPConst.notificationsEnabled, enabled);
  static bool getNotificationsEnabled() => SPHelper.getPreference<bool>(SPConst.notificationsEnabled, true)!;
}
```

---

## 8. API Layer

**Directory:** `lib/global/apiutils/`
**Total files:** 3

### 8.1 `api_base_helper.dart` — Dio HTTP Client

```dart
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiResponseCode {
  static const int success = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int serverError = 500;
  static const int noInternet = 999;
}

class ApiBaseHelper {
  late Dio _dio;

  ApiBaseHelper(String baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConstant.timeout,
      receiveTimeout: ApiConstant.receiveTimeout,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));

    // Auth token interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = SPManager.getAccessToken();
        if (token.isNotEmpty) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle token refresh or logout
        }
        handler.next(error);
      },
    ));

    // Logging interceptor (debug only)
    assert(() {
      _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
      return true;
    }());
  }

  Future<Response> get(String url, {Map<String, dynamic>? params}) async {
    if (!await _isInternetAvailable()) throw Exception(ApiConstant.noInternetConnection);
    return _dio.get(url, queryParameters: params);
  }

  Future<Response> post(String url, {dynamic data, Map<String, dynamic>? params}) async {
    if (!await _isInternetAvailable()) throw Exception(ApiConstant.noInternetConnection);
    return _dio.post(url, data: data, queryParameters: params);
  }

  Future<Response> put(String url, {dynamic data, Map<String, dynamic>? params}) async {
    if (!await _isInternetAvailable()) throw Exception(ApiConstant.noInternetConnection);
    return _dio.put(url, data: data, queryParameters: params);
  }

  Future<Response> delete(String url, {dynamic data, Map<String, dynamic>? params}) async {
    if (!await _isInternetAvailable()) throw Exception(ApiConstant.noInternetConnection);
    return _dio.delete(url, data: data, queryParameters: params);
  }

  Future<Response> patch(String url, {dynamic data, Map<String, dynamic>? params}) async {
    if (!await _isInternetAvailable()) throw Exception(ApiConstant.noInternetConnection);
    return _dio.patch(url, data: data, queryParameters: params);
  }

  Future<bool> _isInternetAvailable() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}

// Global singleton
final apiHelper = ApiBaseHelper(ApiConstant.baseUrl);
```

### 8.2 `api_response.dart` — State Wrapper + Result Type

```dart
// --- Result<T> --- Functional result type for repositories ---

class Result<T> {
  final T? _data;
  final String? _error;
  final bool _isSuccess;

  Result._(this._data, this._error, this._isSuccess);

  factory Result.success(T data) => Result._(data, null, true);
  factory Result.failure(String error) => Result._(null, error, false);

  bool get isSuccess => _isSuccess;
  bool get isFailure => !_isSuccess;

  R fold<R>(R Function(T data) onSuccess, R Function(String error) onFailure) =>
    _isSuccess ? onSuccess(_data as T) : onFailure(_error ?? 'Unknown error');

  Result<R> map<R>(R Function(T data) transform) =>
    _isSuccess ? Result.success(transform(_data as T)) : Result.failure(_error ?? 'Unknown error');

  T get dataOrThrow => _isSuccess ? _data as T : throw Exception(_error);
  T getOrDefault(T defaultValue) => _isSuccess && _data != null ? _data as T : defaultValue;

  void onSuccess(void Function(T data) action) { if (_isSuccess && _data != null) action(_data as T); }
  void onFailure(void Function(String error) action) { if (!_isSuccess) action(_error ?? 'Unknown error'); }
}

// --- ApiResponse<T> --- UI-oriented state wrapper ---

enum ApiStatus { idle, loading, success, error, noInternet }

class ApiResponse<T> {
  final ApiStatus status;
  final T? data;
  final String? message;

  ApiResponse._(this.status, this.data, this.message);

  factory ApiResponse.idle() => ApiResponse._(ApiStatus.idle, null, null);
  factory ApiResponse.loading() => ApiResponse._(ApiStatus.loading, null, null);
  factory ApiResponse.success(T data) => ApiResponse._(ApiStatus.success, data, null);
  factory ApiResponse.error([String? message]) => ApiResponse._(ApiStatus.error, null, message);
  factory ApiResponse.noInternet() => ApiResponse._(ApiStatus.noInternet, null, null);

  bool get isIdle => status == ApiStatus.idle;
  bool get isLoading => status == ApiStatus.loading;
  bool get isSuccess => status == ApiStatus.success;
  bool get isError => status == ApiStatus.error;
  bool get hasData => data != null;
}

// Convert Result to ApiResponse
extension ResultToApiResponse<T> on Result<T> {
  ApiResponse<T> toApiResponse() => fold(
    (data) => ApiResponse.success(data),
    (error) => ApiResponse.error(error),
  );
}
```

### 8.3 `http_overrides.dart`

```dart
import 'dart:io';

/// Development-only override that accepts self-signed certificates.
/// Remove or restrict for production builds.
class AppHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
```

---

## 9. Base Classes

**Directory:** `lib/global/base/`
**Total files:** 5

These are the **foundation** of the app. Every controller, repository, service, and widget extends these.

### 9.1 `base_controller.dart`

```dart
import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  // --- Observable state ---
  final _isLoading = false.obs;
  final _isError = false.obs;
  final _errorMessage = ''.obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  String get errorMessage => _errorMessage.value;

  // --- Lifecycle hooks (override in subclasses) ---
  void onControllerInit() {}
  void onControllerReady() {}
  void onControllerClose() {}

  @override
  void onInit() { super.onInit(); onControllerInit(); }
  @override
  void onReady() { super.onReady(); onControllerReady(); }
  @override
  void onClose() { onControllerClose(); super.onClose(); }

  // --- State management ---
  void showLoading() => _isLoading.value = true;
  void hideLoading() => _isLoading.value = false;
  void setError(String message) { _isError.value = true; _errorMessage.value = message; }
  void clearError() { _isError.value = false; _errorMessage.value = ''; }
  void resetStates() { hideLoading(); clearError(); }

  // --- Async helpers ---
  Future<T?> executeWithLoading<T>(Future<T> Function() action, {String? errorMessage, bool showError = true}) async {
    try {
      showLoading(); clearError();
      final result = await action();
      return result;
    } catch (e) {
      if (showError) setError(errorMessage ?? e.toString());
      return null;
    } finally {
      hideLoading();
    }
  }

  Future<T?> executeSilently<T>(Future<T> Function() action, {Function(Exception)? onError}) async {
    try {
      return await action();
    } catch (e) {
      onError?.call(e is Exception ? e : Exception(e.toString()));
      return null;
    }
  }

  Future<T?> executeWithRetry<T>(Future<T> Function() action, {int maxRetries = 3, Duration retryDelay = const Duration(seconds: 1)}) async {
    for (int i = 0; i <= maxRetries; i++) {
      try {
        return await action();
      } catch (e) {
        if (i == maxRetries) rethrow;
        await Future.delayed(retryDelay * (i + 1));
      }
    }
    return null;
  }

  // --- Navigation ---
  void toNamed(String route, {dynamic arguments}) => Get.toNamed(route, arguments: arguments);
  void offNamed(String route, {dynamic arguments}) => Get.offNamed(route, arguments: arguments);
  void offAllNamed(String route) => Get.offAllNamed(route);
  void goBack({dynamic result}) => Get.back(result: result);

  // --- Arguments ---
  T? getArguments<T>() => Get.arguments as T?;
  Map<String, String?> get parameters => Get.parameters;
}
```

### 9.2 `base_repository.dart`

```dart
import 'package:dio/dio.dart';

abstract class BaseRepository {
  ApiBaseHelper get api => apiHelper;

  // Override for nested JSON keys
  String? get dataKey => null;
  String? get listKey => null;

  // --- HTTP methods returning Result<T> ---
  Future<Result<T>> get<T>(String url, T Function(Map<String, dynamic>) parser, {Map<String, dynamic>? params}) async {
    try {
      final response = await api.get(url, params: params);
      final json = dataKey != null ? response.data[dataKey] : response.data;
      return Result.success(parser(json));
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  Future<Result<List<T>>> getList<T>(String url, T Function(Map<String, dynamic>) parser, {Map<String, dynamic>? params}) async {
    try {
      final response = await api.get(url, params: params);
      final list = listKey != null ? response.data[listKey] as List : response.data as List;
      return Result.success(list.map((e) => parser(e as Map<String, dynamic>)).toList());
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  Future<Result<T>> post<T>(String url, T Function(Map<String, dynamic>) parser, {dynamic data}) async {
    try {
      final response = await api.post(url, data: data);
      final json = dataKey != null ? response.data[dataKey] : response.data;
      return Result.success(parser(json));
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  Future<Result<T>> put<T>(String url, T Function(Map<String, dynamic>) parser, {dynamic data}) async {
    try {
      final response = await api.put(url, data: data);
      final json = dataKey != null ? response.data[dataKey] : response.data;
      return Result.success(parser(json));
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  Future<Result<T>> delete<T>(String url, T Function(Map<String, dynamic>) parser) async {
    try {
      final response = await api.delete(url);
      final json = dataKey != null ? response.data[dataKey] : response.data;
      return Result.success(parser(json));
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // Local/offline operations
  Future<Result<T>> execute<T>(Future<T> Function() operation) async {
    try { return Result.success(await operation()); }
    catch (e) { return Result.failure(e.toString()); }
  }

  Result<T> executeSync<T>(T Function() operation) {
    try { return Result.success(operation()); }
    catch (e) { return Result.failure(e.toString()); }
  }

  // Raw response
  Future<Result<Response>> raw(Future<Response> Function() apiCall) async {
    try { return Result.success(await apiCall()); }
    catch (e) { return Result.failure(_handleError(e)); }
  }

  String _handleError(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiConstant.somethingWentWrong;
        case DioExceptionType.badResponse:
          return e.response?.data?['message'] ?? 'Server error: ${e.response?.statusCode}';
        case DioExceptionType.cancel:
          return 'Request cancelled';
        default:
          return ApiConstant.noInternetConnection;
      }
    }
    return e.toString();
  }
}

// In-memory caching mixin
mixin Cacheable on BaseRepository {
  final Map<String, _CacheEntry> _cache = {};

  Future<T> cached<T>(String key, Future<T> Function() fetcher, {Duration duration = const Duration(minutes: 5)}) async {
    if (_cache.containsKey(key) && !_cache[key]!.isExpired) return _cache[key]!.data as T;
    final data = await fetcher();
    _cache[key] = _CacheEntry(data, DateTime.now().add(duration));
    return data;
  }

  void invalidate(String key) => _cache.remove(key);
  void invalidateAll() => _cache.clear();
  bool isCached(String key) => _cache.containsKey(key) && !_cache[key]!.isExpired;
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiresAt;
  _CacheEntry(this.data, this.expiresAt);
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
```

### 9.3 `base_service.dart`

```dart
abstract class BaseService extends GetxService {
  bool _isInitialized = false;
  bool _isInitializing = false;
  Exception? _initException;

  bool get isInitialized => _isInitialized;
  bool get hasInitError => _initException != null;

  /// Override for async initialization logic
  Future<void> onServiceInit();
  void onServiceClose() {}

  @override
  void onInit() { super.onInit(); _initialize(); }
  @override
  void onClose() { onServiceClose(); super.onClose(); }

  Future<void> _initialize() async {
    if (_isInitialized || _isInitializing) return;
    _isInitializing = true;
    try {
      await onServiceInit();
      _isInitialized = true;
    } catch (e) {
      _initException = e is Exception ? e : Exception(e.toString());
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> ensureInitialized() async {
    if (_isInitialized) return;
    if (_isInitializing) {
      while (_isInitializing) await Future.delayed(const Duration(milliseconds: 50));
      return;
    }
    await _initialize();
  }

  Future<void> reinitialize() async {
    _isInitialized = false;
    _initException = null;
    await _initialize();
  }
}
```

### 9.4 `base_stateful_widget.dart`

```dart
abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

abstract class BaseState<T extends BaseStatefulWidget> extends State<T> {
  /// Override this instead of build()
  Widget initBuild(BuildContext context);

  @override
  Widget build(BuildContext context) => initBuild(context);

  // Lifecycle hooks
  void initUIState() {}
  void onDispose() {}
  void onFirstFrame() {}

  @override
  void initState() {
    super.initState();
    initUIState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onFirstFrame());
  }

  @override
  void dispose() { onDispose(); super.dispose(); }

  // Context helpers (via extension import, or inline)
  Size get screenSize => MediaQuery.of(context).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  ThemeData get theme => Theme.of(context);
  ColorScheme get colorScheme => theme.colorScheme;
  void hideKeyboard() => FocusScope.of(context).unfocus();

  // Safe setState
  void safeSetState(VoidCallback fn) { if (mounted) setState(fn); }

  // Navigation
  void navigateTo(String route, {dynamic arguments}) => Get.toNamed(route, arguments: arguments);
  void pop({dynamic result}) => Get.back(result: result);
}
```

### 9.5 `base_stateless_widget.dart`

```dart
abstract class BaseStatelessWidget extends StatelessWidget {
  const BaseStatelessWidget({super.key});

  Widget initBuild(BuildContext context);

  @override
  Widget build(BuildContext context) => initBuild(context);

  // Context helpers (accept context since stateless)
  Size screenSize(BuildContext c) => MediaQuery.of(c).size;
  double screenWidth(BuildContext c) => screenSize(c).width;
  double screenHeight(BuildContext c) => screenSize(c).height;
  bool isDarkMode(BuildContext c) => Theme.of(c).brightness == Brightness.dark;
  ThemeData theme(BuildContext c) => Theme.of(c);
  ColorScheme colorScheme(BuildContext c) => theme(c).colorScheme;
  void hideKeyboard(BuildContext c) => FocusScope.of(c).unfocus();
}
```

---

## 10. Services

**Directory:** `lib/global/services/`
**Total files:** 6

### 10.1 `hive_service.dart`

```dart
class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    // Register adapters here
    // await Hive.openBox(DbConst.settingsBox);
    // await Hive.openBox(DbConst.cacheBox);
    _initialized = true;
  }

  Future<void> put<T>(String boxName, String key, T value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  T? get<T>(String boxName, String key, {T? defaultValue}) {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  Future<void> delete(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  Future<void> clearBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  Future<void> closeAll() async => await Hive.close();
}
```

### 10.2 `connectivity_service.dart`

```dart
class ConnectivityService extends GetxService {
  final _isConnected = true.obs;
  bool get isConnected => _isConnected.value;

  @override
  void onInit() {
    super.onInit();
    Connectivity().onConnectivityChanged.listen((results) {
      _isConnected.value = !results.contains(ConnectivityResult.none);
    });
  }

  Future<bool> checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    _isConnected.value = !result.contains(ConnectivityResult.none);
    return _isConnected.value;
  }
}
```

### 10.3 `auth_service.dart`

```dart
/// Generic auth service. Implement provider-specific logic (Firebase, custom API, etc.)
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool get isLoggedIn => SPManager.isLoggedIn();

  Future<Result<bool>> login({required String email, required String password}) async {
    // Implement: call API, save tokens, save user data
    // return Result.success(true);
    return Result.failure('Not implemented');
  }

  Future<Result<bool>> register({required String name, required String email, required String password}) async {
    return Result.failure('Not implemented');
  }

  Future<void> logout() async {
    await SPManager.clearLoginDetails();
    Get.offAllNamed(RoutersConst.login);
  }

  // Add: signInWithGoogle(), resetPassword(), deleteAccount() etc.
}
```

### 10.4 `analytics_service.dart`

```dart
/// Analytics facade. Plug in Firebase Analytics, Mixpanel, Amplitude, etc.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  Future<void> initialize() async { /* init provider */ }

  void logScreenView(String screenName) { /* log */ }
  void logEvent(String name, {Map<String, dynamic>? params}) { /* log */ }
  void logLogin({String? method}) { /* log */ }
  void logSignUp({String? method}) { /* log */ }
  void setUserId(String userId) { /* set */ }
  void setUserProperty(String name, String value) { /* set */ }
}
```

### 10.5 `storage_service.dart`

```dart
/// File storage service. Implement with Firebase Storage, S3, or local.
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<String?> uploadFile(String path, File file, {Function(double)? onProgress}) async {
    return null; // return download URL
  }

  Future<void> deleteFile(String path) async { /* delete */ }
  Future<String?> getDownloadUrl(String path) async { return null; }
}
```

### 10.6 `app_service.dart`

```dart
/// App lifecycle service: version check, force update, remote config, etc.
class AppService extends GetxService {
  final _isInitialized = false.obs;
  bool get isInitialized => _isInitialized.value;

  Future<void> init() async {
    // Load device info
    // Load package info
    // Check for updates
    // Load remote config
    _isInitialized.value = true;
  }
}
```

---

## 11. Utilities

**Directory:** `lib/global/utils/`
**Total files:** 10

### 11.1 `app_utils.dart` — General Utilities

```dart
import 'package:logger/logger.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

// Empty checks
bool isEmpty(String? value) => value == null || value.trim().isEmpty;
bool isNotEmpty(String? value) => !isEmpty(value);

// Logging
void printLog(String tag, dynamic msg) => _logger.d('[$tag] $msg');
void printError(String tag, dynamic msg) => _logger.e('[$tag] $msg');

// URL
Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
}

// Share
void shareText(String text, {String? subject}) => Share.share(text, subject: subject);

// Delay
Future<void> delay(int milliseconds) => Future.delayed(Duration(milliseconds: milliseconds));

// Random
int randomNumber({int max = 1000}) => Random().nextInt(max);

// File size
String formatFileSize(int bytes, {int decimals = 2}) {
  if (bytes <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
  final i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

// Duration formatting
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  if (hours > 0) return '${hours}h ${minutes}m';
  if (minutes > 0) return '${minutes}m ${seconds}s';
  return '${seconds}s';
}
```

### 11.2 `dialog_utils.dart` — Reusable Dialogs

```dart
void showConfirmDialog({
  required String title,
  required String message,
  String positiveText = 'Confirm',
  String negativeText = 'Cancel',
  VoidCallback? onPositive,
  VoidCallback? onNegative,
  bool isDismissible = true,
}) {
  Get.dialog(
    AlertDialog(
      title: Text(title, style: AppTextStyle.titleMedium),
      content: Text(message, style: AppTextStyle.bodyMedium),
      actions: [
        TextButton(onPressed: onNegative ?? () => Get.back(), child: Text(negativeText)),
        ElevatedButton(onPressed: () { Get.back(); onPositive?.call(); }, child: Text(positiveText)),
      ],
    ),
    barrierDismissible: isDismissible,
  );
}

void showPermissionDialog({
  required String message,
  required VoidCallback onOpenSettings,
  bool isDismissible = true,
}) {
  Get.dialog(
    AlertDialog(
      title: Text(StringConst.permissionRequired, style: AppTextStyle.titleMedium),
      content: Text(message, style: AppTextStyle.bodyMedium),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text(StringConst.cancel)),
        ElevatedButton(onPressed: () { Get.back(); onOpenSettings(); }, child: const Text('Open Settings')),
      ],
    ),
    barrierDismissible: isDismissible,
  );
}

void showLoadingDialog({String message = 'Loading...'}) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async => false,
      child: Center(child: CircularProgressIndicator()),
    ),
    barrierDismissible: false,
  );
}

void hideLoadingDialog() { if (Get.isDialogOpen ?? false) Get.back(); }

void showBottomSheet({required Widget child, bool isDismissible = true}) {
  Get.bottomSheet(child, isDismissible: isDismissible, backgroundColor: Colors.transparent);
}
```

### 11.3 `permission_utils.dart`

```dart
import 'package:permission_handler/permission_handler.dart';

enum PermissionType { camera, storage, photos, notification, location, microphone, contacts }

class PermissionUtils {
  PermissionUtils._();

  static Future<bool> request(PermissionType type, {bool showDialogOnDenied = true}) async {
    final permission = _mapPermission(type);
    final status = await permission.request();

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied && showDialogOnDenied) {
      showPermissionDialog(
        message: 'Please enable ${type.name} permission from settings',
        onOpenSettings: () => openAppSettings(),
      );
    }
    return false;
  }

  static Future<bool> requestMultiple(List<PermissionType> types) async {
    final permissions = types.map(_mapPermission).toList();
    final statuses = await permissions.request();
    return statuses.values.every((s) => s.isGranted);
  }

  static Future<bool> isGranted(PermissionType type) async {
    return await _mapPermission(type).isGranted;
  }

  static Permission _mapPermission(PermissionType type) {
    switch (type) {
      case PermissionType.camera: return Permission.camera;
      case PermissionType.storage: return Permission.storage;
      case PermissionType.photos: return Permission.photos;
      case PermissionType.notification: return Permission.notification;
      case PermissionType.location: return Permission.location;
      case PermissionType.microphone: return Permission.microphone;
      case PermissionType.contacts: return Permission.contacts;
    }
  }
}
```

### 11.4 `validation_utils.dart`

```dart
class ValidationUtils {
  ValidationUtils._();

  static String? required(String? value, {String? message}) =>
    (value == null || value.trim().isEmpty) ? (message ?? StringConst.fieldRequired) : null;

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return StringConst.fieldRequired;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return StringConst.invalidEmail;
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.trim().isEmpty) return StringConst.fieldRequired;
    if (value.length < minLength) return StringConst.invalidPassword;
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return StringConst.fieldRequired;
    if (!RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value)) return StringConst.invalidPhone;
    return null;
  }

  static String? confirmPassword(String? value, String? original) {
    final error = required(value);
    if (error != null) return error;
    if (value != original) return StringConst.passwordMismatch;
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return StringConst.fieldRequired;
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }
}
```

### 11.5 `color_utils.dart`

```dart
class ColorUtils {
  ColorUtils._();

  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static Color withOpacity(Color color, double opacity) => color.withOpacity(opacity);

  static Color fromHex(String hex) {
    hex = hex.replaceAll('#', '').replaceAll('0x', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  static String toHex(Color color, {bool withHash = true}) {
    final hex = color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    return withHash ? '#$hex' : hex;
  }
}
```

### 11.6 `date_utils.dart`

```dart
import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String format(DateTime date, {String pattern = 'dd MMM yyyy'}) => DateFormat(pattern).format(date);
  static String formatWithTime(DateTime date) => DateFormat('dd MMM yyyy, hh:mm a').format(date);
  static String formatTime(DateTime date) => DateFormat('hh:mm a').format(date);
  static String formatApiDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  static DateTime? parse(String dateString, {String pattern = 'yyyy-MM-dd'}) {
    try { return DateFormat(pattern).parse(dateString); } catch (_) { return null; }
  }

  static String relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return format(date);
  }

  static bool isToday(DateTime date) => DateUtils.isSameDay(date, DateTime.now());
  static int daysBetween(DateTime a, DateTime b) => a.difference(b).inDays.abs();
}
```

### 11.7 `file_utils.dart`

```dart
import 'package:path_provider/path_provider.dart';

class FileUtils {
  FileUtils._();

  static Future<Directory> getAppDirectory() async => await getApplicationDocumentsDirectory();
  static Future<Directory> getTempDirectory() async => await getTemporaryDirectory();

  static Future<File> getFile(String fileName) async {
    final dir = await getAppDirectory();
    return File('${dir.path}/$fileName');
  }

  static String getFileName(String path) => path.split('/').last;
  static String getFileExtension(String path) => path.split('.').last;
}
```

### 11.8 `snackbar_utils.dart`

```dart
enum SnackbarType { success, error, warning, info }

void showSnackbar(String message, {String? title, SnackbarType type = SnackbarType.info, Duration? duration}) {
  final config = _getConfig(type);
  Get.snackbar(
    title ?? config.title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: config.backgroundColor,
    colorText: config.textColor,
    duration: duration ?? const Duration(seconds: 3),
    margin: const EdgeInsets.all(8),
    borderRadius: 8,
    icon: Icon(config.icon, color: config.textColor),
  );
}

void showSuccess(String message, {String? title}) => showSnackbar(message, title: title, type: SnackbarType.success);
void showError(String message, {String? title}) => showSnackbar(message, title: title, type: SnackbarType.error);
void showWarning(String message, {String? title}) => showSnackbar(message, title: title, type: SnackbarType.warning);
void showInfo(String message, {String? title}) => showSnackbar(message, title: title, type: SnackbarType.info);

class _SnackConfig { final String title; final Color backgroundColor; final Color textColor; final IconData icon; const _SnackConfig(this.title, this.backgroundColor, this.textColor, this.icon); }

_SnackConfig _getConfig(SnackbarType type) {
  switch (type) {
    case SnackbarType.success: return const _SnackConfig('Success', Color(0xFF43A047), Colors.white, Icons.check_circle);
    case SnackbarType.error: return const _SnackConfig('Error', Color(0xFFE53935), Colors.white, Icons.error);
    case SnackbarType.warning: return const _SnackConfig('Warning', Color(0xFFFFA000), Colors.white, Icons.warning);
    case SnackbarType.info: return const _SnackConfig('Info', Color(0xFF1976D2), Colors.white, Icons.info);
  }
}
```

### 11.9 `widget_utils.dart` — Common Widget Builders

```dart
// Spacing
Widget verticalSpace(double height) => SizedBox(height: height);
Widget horizontalSpace(double width) => SizedBox(width: width);

// Divider
Widget appDivider({Color? color, double thickness = 0.5}) => Divider(color: color ?? Colors.grey.shade300, thickness: thickness);

// Buttons
Widget elevatedButton({required String title, required VoidCallback onPressed, Color? bgColor, Color? textColor, double? width, double? height, double borderRadius = 8, EdgeInsets? padding}) {
  return SizedBox(
    width: width, height: height,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(title, style: AppTextStyle.buttonText.copyWith(color: textColor)),
    ),
  );
}

Widget outlinedButton({required String title, required VoidCallback onPressed, Color? borderColor, Color? textColor, double borderRadius = 8}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: textColor,
      side: BorderSide(color: borderColor ?? ColorConst.primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    child: Text(title, style: AppTextStyle.buttonText.copyWith(color: textColor)),
  );
}

Widget iconButton({required IconData icon, required VoidCallback onPressed, Color? color, double size = 24}) {
  return IconButton(onPressed: onPressed, icon: Icon(icon, color: color, size: size));
}
```

### 11.10 `resource_manager.dart` — Auto-Dispose Mixin

```dart
/// Mixin that auto-disposes subscriptions, timers, and controllers on widget dispose.
mixin ResourceManagerMixin<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _subscriptions = [];
  final List<Timer> _timers = [];
  final List<AnimationController> _animationControllers = [];
  final List<TextEditingController> _textControllers = [];
  final List<ScrollController> _scrollControllers = [];
  final List<FocusNode> _focusNodes = [];

  void addSubscription(StreamSubscription sub) => _subscriptions.add(sub);
  void addTimer(Timer timer) => _timers.add(timer);
  void addAnimationController(AnimationController c) => _animationControllers.add(c);
  void addTextController(TextEditingController c) => _textControllers.add(c);
  void addScrollController(ScrollController c) => _scrollControllers.add(c);
  void addFocusNode(FocusNode node) => _focusNodes.add(node);

  // Factory methods
  TextEditingController createTextController([String? text]) {
    final c = TextEditingController(text: text);
    _textControllers.add(c);
    return c;
  }

  ScrollController createScrollController() {
    final c = ScrollController();
    _scrollControllers.add(c);
    return c;
  }

  FocusNode createFocusNode() {
    final n = FocusNode();
    _focusNodes.add(n);
    return n;
  }

  Timer createTimer(Duration duration, VoidCallback callback) {
    final t = Timer(duration, callback);
    _timers.add(t);
    return t;
  }

  Timer createPeriodicTimer(Duration period, void Function(Timer) callback) {
    final t = Timer.periodic(period, callback);
    _timers.add(t);
    return t;
  }

  // Safe setState
  void safeSetState(VoidCallback fn) { if (mounted) setState(fn); }

  @override
  void dispose() {
    for (final s in _subscriptions) s.cancel();
    for (final t in _timers) t.cancel();
    for (final a in _animationControllers) a.dispose();
    for (final t in _textControllers) t.dispose();
    for (final s in _scrollControllers) s.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }
}
```

---

## 12. Reusable Widgets

**Directory:** `lib/global/widgets/`
**Total files:** 10

### 12.1 `smart_image.dart` — Universal Image Widget

```dart
/// THE image widget. ALL images in the app MUST use SmartImage factories.
/// Never use Image.asset, Image.network, CircleAvatar, FadeInImage directly.
class SmartImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final VoidCallback? onTap;

  const SmartImage({super.key, required this.imageUrl, this.width, this.height, this.fit = BoxFit.cover, this.borderRadius = 0, this.placeholder, this.errorWidget, this.onTap});

  // Factory constructors
  factory SmartImage.circular({required String imageUrl, required double size, BoxFit fit = BoxFit.cover, VoidCallback? onTap}) =>
    SmartImage(imageUrl: imageUrl, width: size, height: size, fit: fit, borderRadius: size / 2, onTap: onTap);

  factory SmartImage.rounded({required String imageUrl, double? width, double? height, double radius = 8, BoxFit fit = BoxFit.cover, VoidCallback? onTap}) =>
    SmartImage(imageUrl: imageUrl, width: width, height: height, fit: fit, borderRadius: radius, onTap: onTap);

  factory SmartImage.avatar({required String imageUrl, double size = 40, VoidCallback? onTap}) =>
    SmartImage(imageUrl: imageUrl, width: size, height: size, fit: BoxFit.cover, borderRadius: size / 2, onTap: onTap);

  factory SmartImage.square({required String imageUrl, required double size, double radius = 8, BoxFit fit = BoxFit.cover}) =>
    SmartImage(imageUrl: imageUrl, width: size, height: size, fit: fit, borderRadius: radius);

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (imageUrl.startsWith('http')) {
      image = CachedNetworkImage(
        imageUrl: imageUrl, width: width, height: height, fit: fit,
        placeholder: (_, __) => placeholder ?? _defaultPlaceholder(),
        errorWidget: (_, __, ___) => errorWidget ?? _defaultError(),
      );
    } else if (imageUrl.startsWith('assets/')) {
      image = Image.asset(imageUrl, width: width, height: height, fit: fit,
        errorBuilder: (_, __, ___) => errorWidget ?? _defaultError());
    } else {
      image = Image.file(File(imageUrl), width: width, height: height, fit: fit,
        errorBuilder: (_, __, ___) => errorWidget ?? _defaultError());
    }

    Widget result = ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: image);
    if (onTap != null) result = GestureDetector(onTap: onTap, child: result);
    return result;
  }

  Widget _defaultPlaceholder() => Container(width: width, height: height, color: Colors.grey.shade200,
    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
  Widget _defaultError() => Container(width: width, height: height, color: Colors.grey.shade200,
    child: const Icon(Icons.broken_image, color: Colors.grey));
}
```

### 12.2 `app_bar_widget.dart`

```dart
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showBack;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  const AppBarWidget({super.key, required this.title, this.actions, this.onBackPressed, this.showBack = true, this.leading, this.bottom});

  @override
  Size get preferredSize => Size.fromHeight(bottom != null ? kToolbarHeight + 48 : kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyle.titleMedium),
      centerTitle: true,
      leading: showBack ? (leading ?? IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: onBackPressed ?? () => Get.back())) : null,
      automaticallyImplyLeading: showBack,
      actions: actions,
      bottom: bottom,
    );
  }
}
```

### 12.3 `search_widget.dart`

```dart
class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hintText;

  const SearchWidget({super.key, required this.controller, this.onChanged, this.onClear, this.hintText = 'Search...'});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyle.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText, hintStyle: AppTextStyle.inputHint,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: controller.text.isNotEmpty
          ? IconButton(icon: const Icon(Icons.clear, size: 20), onPressed: () { controller.clear(); onClear?.call(); })
          : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }
}
```

### 12.4 `loading_widget.dart`

```dart
class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool useShimmer;

  const LoadingWidget({super.key, this.message, this.useShimmer = false});
  const LoadingWidget.shimmer({super.key, this.message}) : useShimmer = true;

  @override
  Widget build(BuildContext context) {
    if (useShimmer) return ShimmerLoadingWidget(message: message);
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const CircularProgressIndicator(),
      if (message != null) ...[const SizedBox(height: 8), Text(message!, style: AppTextStyle.bodySmall)],
    ]));
  }
}
```

### 12.5 `shimmer_widget.dart`

```dart
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({super.key, this.width = double.infinity, required this.height, this.borderRadius = 8});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
      child: Container(width: width, height: height, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(borderRadius))),
    );
  }
}

class ShimmerListPlaceholder extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ShimmerListPlaceholder({super.key, this.itemCount = 6, this.itemHeight = 80});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      padding: const EdgeInsets.all(8),
      itemBuilder: (_, __) => ShimmerBox(height: itemHeight),
    );
  }
}

class ShimmerLoadingWidget extends StatelessWidget {
  final String? message;
  const ShimmerLoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: ShimmerListPlaceholder()),
      if (message != null) Padding(padding: const EdgeInsets.all(8), child: Text(message!, style: AppTextStyle.bodySmall)),
    ]);
  }
}
```

### 12.6 `empty_widget.dart`

```dart
class EmptyWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Widget? action;

  const EmptyWidget({super.key, this.message = StringConst.noDataFound, this.icon, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(padding: const EdgeInsets.all(8), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon ?? Icons.inbox_outlined, size: 48, color: Colors.grey),
      const SizedBox(height: 8),
      Text(message, style: AppTextStyle.bodyMedium.copyWith(color: Colors.grey), textAlign: TextAlign.center),
      if (action != null) ...[const SizedBox(height: 8), action!],
    ])));
  }
}

class NoDataPlaceholder extends StatelessWidget {
  final String message;
  const NoDataPlaceholder({super.key, this.message = StringConst.noDataFound});

  @override
  Widget build(BuildContext context) => EmptyWidget(message: message);
}

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, this.message = StringConst.somethingWentWrong, this.onRetry});

  @override
  Widget build(BuildContext context) => EmptyWidget(
    message: message, icon: Icons.error_outline,
    action: onRetry != null ? TextButton(onPressed: onRetry, child: const Text(StringConst.retry)) : null,
  );
}
```

### 12.7 `glass_widgets.dart`

```dart
import 'dart:ui';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final double blurSigma;

  const GlassContainer({super.key, required this.child, this.padding = const EdgeInsets.all(8), this.borderRadius = 12, this.blurSigma = 10});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const GlassButton({super.key, required this.icon, required this.onTap, this.size = 40, this.iconSize = 20});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: EdgeInsets.all((size - iconSize) / 2),
        borderRadius: size / 2,
        child: Icon(icon, size: iconSize, color: Colors.white),
      ),
    );
  }
}
```

### 12.8 `custom_text_field.dart`

```dart
class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  const CustomTextField({super.key, this.label, this.hint, this.controller, this.obscureText = false, this.keyboardType, this.validator, this.prefixIcon, this.suffixIcon, this.maxLines = 1, this.maxLength, this.enabled = true, this.onChanged, this.onSubmitted, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (label != null) ...[Text(label!, style: AppTextStyle.inputLabel), const SizedBox(height: 4)],
      TextFormField(
        controller: controller, obscureText: obscureText, keyboardType: keyboardType, validator: validator,
        maxLines: maxLines, maxLength: maxLength, enabled: enabled, focusNode: focusNode,
        onChanged: onChanged, onFieldSubmitted: onSubmitted,
        style: AppTextStyle.inputText,
        decoration: InputDecoration(hintText: hint, hintStyle: AppTextStyle.inputHint, prefixIcon: prefixIcon, suffixIcon: suffixIcon),
      ),
    ]);
  }
}
```

### 12.9 `gradient_button.dart`

```dart
class GradientButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final List<Color>? colors;
  final double height;
  final double borderRadius;
  final bool isLoading;
  final EdgeInsets padding;

  const GradientButton({super.key, required this.onTap, required this.child, this.colors, this.height = 48, this.borderRadius = 8, this.isLoading = false, this.padding = const EdgeInsets.symmetric(horizontal: 8)});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height, padding: padding,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors ?? [ColorConst.primaryColor, ColorConst.secondaryColor]),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : child),
      ),
    );
  }
}
```

### 12.10 `keep_alive_wrapper.dart`

```dart
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) { super.build(context); return widget.child; }
}
```

---

## 13. Controllers & Routing

**Directory:** `lib/controller/`
**Total files:** 3

### 13.1 `theme_controller.dart`

```dart
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  bool isDarkMode = SPManager.getTheme();
  final isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDark.value = isDarkMode;
    _applySystemUI();
  }

  void changeTheme(bool isDarkness) {
    isDarkMode = isDarkness;
    isDark.value = isDarkness;
    SPManager.setTheme(isDarkness);
    _applySystemUI();
    Get.changeThemeMode(isDarkness ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() => changeTheme(!isDarkMode);

  void _applySystemUI() {
    SystemChrome.setSystemUIOverlayStyle(isDarkMode
      ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
      : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
  }
}
```

### 13.2 `initial_binding.dart`

```dart
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Core — permanent
    Get.put(ConnectivityService(), permanent: true);

    // Theme
    Get.lazyPut(() => ThemeController(), fenix: true);

    // Add feature controllers as project grows:
    // Get.lazyPut(() => AuthController(), fenix: true);
  }
}
```

### 13.3 `routes.dart`

```dart
List<GetPage> routes() => [
  // Common routes (every app needs these)
  GetPage(name: RoutersConst.splash, page: () => const SplashPage()),
  GetPage(name: RoutersConst.onboarding, page: () => const OnboardingPage()),
  GetPage(name: RoutersConst.login, page: () => const LoginPage()),
  GetPage(name: RoutersConst.home, page: () => const HomePage()),
  GetPage(name: RoutersConst.profile, page: () => const ProfilePage()),
  GetPage(name: RoutersConst.settings, page: () => const SettingsPage()),

  // Add feature-specific routes as project grows
];
```

---

## 14. App Entry Point

**File:** `lib/main.dart`

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initCore();
  _initNonCritical();

  runApp(const MyApp());
}

Future<void> _initCore() async {
  // 1. SharedPreferences
  await SPHelper.init();

  // 2. Hive
  await HiveService().init();

  // 3. Firebase (if USE_FIREBASE = true)
  // await Firebase.initializeApp();
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // 4. Analytics
  // await AnalyticsService().initialize();
}

void _initNonCritical() {
  // HTTP overrides (dev only)
  HttpOverrides.global = AppHttpOverrides();

  // Load .env
  dotenv.load(fileName: '.env').catchError((_) {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
      title: AppConstant.appName,
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: themeController.isDark.value ? ThemeMode.dark : ThemeMode.light,
      initialBinding: InitialBinding(),
      initialRoute: RoutersConst.initialRoute,
      getPages: routes(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              (MediaQuery.of(context).textScaler.scale(1.0)).clamp(0.8, 1.2),
            ),
          ),
          child: child!,
        );
      },
    ));
  }
}
```

---

## 15. Feature Module Template

Every new feature follows **Clean Architecture** with this structure:

```
lib/features/{feature_name}/
├── controller/
│   └── {feature}_controller.dart     # extends BaseController
├── data/
│   └── {feature}_repository.dart     # extends BaseRepository
├── domain/
│   └── {feature}_model.dart          # Data model with fromJson/toJson
└── presentation/
    └── {feature}_page.dart           # UI screen
```

### Controller Template

```dart
class FeatureController extends BaseController {
  final _repository = FeatureRepository();
  final items = <FeatureModel>[].obs;

  @override
  void onControllerInit() => loadData();

  Future<void> loadData() async {
    await executeWithLoading(() async {
      final result = await _repository.getItems();
      result.onSuccess((data) => items.assignAll(data));
      result.onFailure((error) => setError(error));
    });
  }
}
```

### Repository Template

```dart
class FeatureRepository extends BaseRepository with Cacheable {
  Future<Result<List<FeatureModel>>> getItems() =>
    getList('/feature-endpoint', FeatureModel.fromJson);
}
```

### Model Template

```dart
class FeatureModel {
  final String id;
  final String name;
  final String description;

  FeatureModel({required this.id, required this.name, this.description = ''});

  factory FeatureModel.fromJson(Map<String, dynamic> json) => FeatureModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'description': description};

  FeatureModel copyWith({String? id, String? name, String? description}) =>
    FeatureModel(id: id ?? this.id, name: name ?? this.name, description: description ?? this.description);
}
```

### Page Template

```dart
class FeaturePage extends BaseStatelessWidget {
  const FeaturePage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.find<FeatureController>();

    return Scaffold(
      appBar: AppBarWidget(title: 'Feature'),
      body: Obx(() {
        if (controller.isLoading) return const LoadingWidget.shimmer();
        if (controller.isError) return AppErrorWidget(message: controller.errorMessage, onRetry: controller.loadData);
        if (controller.items.isEmpty) return const EmptyWidget();
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.items.length,
          itemBuilder: (_, i) => _buildItem(controller.items[i]),
        );
      }),
    );
  }

  Widget _buildItem(FeatureModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(padding: const EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.name, style: AppTextStyle.titleMedium),
        const SizedBox(height: 4),
        Text(item.description, style: AppTextStyle.bodyMedium),
      ])),
    );
  }
}
```

---

## 16. Design Rules

### Spacing
- All padding/margin <= 8 (`EdgeInsets.all(8)` max)
- Use `SizedBox(height: 8)` or smaller for gaps
- 8px grid system

### Typography
- Titles: `AppTextStyle.titleMedium`
- Subtitles: `AppTextStyle.bodyMedium`
- Text fields: `fontSize: 14`
- Never use raw `TextStyle(fontSize: ...)` in UI

### Colors
- Always use `ColorConst.colorFF{HexCode}` directly
- Never use `Color(0xFF...)` in UI files
- Never create local color variables

### Images
- Only use `SmartImage` factories (`.circular()`, `.rounded()`, `.avatar()`, `.square()`)
- Never use `Image.asset`, `Image.network`, `CircleAvatar`

### Loading States
- List/section/full-content: `LoadingWidget.shimmer()` or `ShimmerLoadingWidget`
- Small inline actions: `CircularProgressIndicator`
- Empty data: Always show `EmptyWidget` or `NoDataPlaceholder`
- Errors: Always show `AppErrorWidget` with retry

### Data
- Never use `Map<String, dynamic>` for structured data
- Always create model classes with `fromJson()` / `toJson()`
- Use typed lists (`List<MyModel>`)

### Code
- Search existing code before writing new
- Never duplicate — extract to reusable component
- New widgets must be generic (callbacks, optional styling)
- Zero flutter analyze errors

---

## 17. File Generation Checklist

Generate in this order:

### Phase 1: Project Setup
- [ ] `pubspec.yaml`
- [ ] `analysis_options.yaml`
- [ ] `.env`
- [ ] `assets/images/`, `assets/icons/` directories

### Phase 2: Constants (9 files)
- [ ] `lib/global/constant/app_constant.dart`
- [ ] `lib/global/constant/api_const.dart`
- [ ] `lib/global/constant/assets_const.dart`
- [ ] `lib/global/constant/color_const.dart`
- [ ] `lib/global/constant/db_const.dart`
- [ ] `lib/global/constant/routers_const.dart`
- [ ] `lib/global/constant/string_const.dart`
- [ ] `lib/global/constant/sp_const.dart`
- [ ] `lib/global/constant/enum_const.dart`

### Phase 3: Theme (2 files)
- [ ] `lib/global/theme/text_style.dart`
- [ ] `lib/global/theme/app_theme.dart`

### Phase 4: Extensions (3 files)
- [ ] `lib/global/extension/string_extension.dart`
- [ ] `lib/global/extension/context_extension.dart`
- [ ] `lib/global/extension/datetime_extension.dart`

### Phase 5: SharedPreferences (2 files)
- [ ] `lib/global/sp/sp_helper.dart`
- [ ] `lib/global/sp/sp_manager.dart`

### Phase 6: API Layer (3 files)
- [ ] `lib/global/apiutils/http_overrides.dart`
- [ ] `lib/global/apiutils/api_base_helper.dart`
- [ ] `lib/global/apiutils/api_response.dart`

### Phase 7: Base Classes (5 files)
- [ ] `lib/global/base/base_controller.dart`
- [ ] `lib/global/base/base_repository.dart`
- [ ] `lib/global/base/base_service.dart`
- [ ] `lib/global/base/base_stateful_widget.dart`
- [ ] `lib/global/base/base_stateless_widget.dart`

### Phase 8: Services (6 files)
- [ ] `lib/global/services/hive_service.dart`
- [ ] `lib/global/services/connectivity_service.dart`
- [ ] `lib/global/services/auth_service.dart`
- [ ] `lib/global/services/analytics_service.dart`
- [ ] `lib/global/services/storage_service.dart`
- [ ] `lib/global/services/app_service.dart`

### Phase 9: Utilities (10 files)
- [ ] `lib/global/utils/app_utils.dart`
- [ ] `lib/global/utils/dialog_utils.dart`
- [ ] `lib/global/utils/permission_utils.dart`
- [ ] `lib/global/utils/validation_utils.dart`
- [ ] `lib/global/utils/color_utils.dart`
- [ ] `lib/global/utils/date_utils.dart`
- [ ] `lib/global/utils/file_utils.dart`
- [ ] `lib/global/utils/snackbar_utils.dart`
- [ ] `lib/global/utils/widget_utils.dart`
- [ ] `lib/global/utils/resource_manager.dart`

### Phase 10: Reusable Widgets (10 files)
- [ ] `lib/global/widgets/smart_image.dart`
- [ ] `lib/global/widgets/app_bar_widget.dart`
- [ ] `lib/global/widgets/search_widget.dart`
- [ ] `lib/global/widgets/loading_widget.dart`
- [ ] `lib/global/widgets/shimmer_widget.dart`
- [ ] `lib/global/widgets/empty_widget.dart`
- [ ] `lib/global/widgets/glass_widgets.dart`
- [ ] `lib/global/widgets/custom_text_field.dart`
- [ ] `lib/global/widgets/gradient_button.dart`
- [ ] `lib/global/widgets/keep_alive_wrapper.dart`

### Phase 11: Controllers & Routing (3 files)
- [ ] `lib/controller/theme_controller.dart`
- [ ] `lib/controller/initial_binding.dart`
- [ ] `lib/controller/routes.dart`

### Phase 12: Entry Point (1 file)
- [ ] `lib/main.dart`

### Phase 13: Feature Modules (as needed)
- [ ] Use template from Section 15 for each new feature

---

---

## 18. Cursor AI Configuration

Two files at the project root configure how Cursor AI interacts with the codebase.

### 18.1 `.cursorrules` — AI Coding Rules

This file tells Cursor AI **how to write code** in this project. Place it at the project root. The AI reads it on every interaction and enforces all rules automatically.

```
# {{APP_NAME}} Project Rules for Cursor AI

You are working on {{APP_NAME}} — a Flutter app following Clean Architecture with GetX.

## CRITICAL DESIGN RULES — MUST FOLLOW

### Spacing & Layout (MANDATORY)
- Padding and margin MUST NOT exceed 8
- EdgeInsets.all(8) maximum, EdgeInsets.symmetric(horizontal: 8, vertical: 8) maximum
- SizedBox spacing should use 8 or smaller values
- NEVER change functional UI element dimensions (button sizes, icon sizes, container dimensions)
- ONLY change spacing/padding/margin values

### Typography (MANDATORY)
- Titles MUST use: AppTextStyle.titleMedium
- Subtitles MUST use: AppTextStyle.bodyMedium
- Text fields and general text MUST use: fontSize: 14
- Always import: 'package:{{PACKAGE_NAME}}/global/theme/text_style.dart'

### Component & Widget Reuse (MANDATORY)
- ALWAYS check if existing component/widget is available before creating new ones
- MUST use existing reusable widgets: AppBarWidget, SearchWidget, GlassButton, GradientButton, and any widget in lib/global/widgets/
- DO NOT duplicate functionality across components — one source of truth per UI pattern
- When creating ANY new component: make it GENERIC so it can be used anywhere in the app
  - Accept parameters/callbacks for customization, not hardcoded values
  - Support optional styling overrides (e.g. style, decoration params)
  - Place in lib/global/widgets/ or appropriate shared location — never screen-specific unless truly one-off
- Prefer composition: build screens from existing widgets; add new widgets only when no existing one fits

### Code Reuse (MANDATORY)
- BEFORE writing any new code, SEARCH THE COMPLETE lib/ FOLDER for similar existing functionality
- Search ALL files and ALL packages in the project — no exceptions
- If similar code exists anywhere in the codebase:
  1. REUSE it directly if it fits
  2. Make MINOR modifications to existing code to support new use case
  3. Add parameters/callbacks to make it flexible for multiple uses
  4. Move common logic to a shared location if used in 2+ places
- When creating new reusable code:
  1. Use callbacks for customization
  2. Support style variants via enums when needed
  3. Keep it generic so it can be reused elsewhere
- NEVER copy-paste code — always extract and reuse
- NEVER recreate functionality that already exists anywhere in the project
- Even 70-80% similar code should be refactored to reusable component
- Always grep/search the codebase before implementing any functionality

### Data & Models (MANDATORY)
- NEVER use Map<String, dynamic> or raw Map for structured data — ALWAYS use model classes
- Define model classes in lib/model/ or feature domain/ with proper fields, fromJson/toJson
- Pass models between screens/controllers; do not pass Maps or loose key-value bags
- Use typed lists (e.g. List<MyModel>) not List<Map> or List<dynamic>

### Style Usage — Use Project Style Classes (MANDATORY)
- Images: ONLY use SmartImage (project image widget class) — NO Image.asset, Image.network, CircleAvatar, FadeInImage
- Text: ALWAYS use AppTextStyle (e.g. AppTextStyle.titleMedium, bodyMedium, bodySmall) — never raw TextStyle(fontSize: ...) for UI text
- TextField: Use CustomTextField or project text field style/decoration utilities; keep styling consistent
- Buttons: Use existing button widgets/styles (e.g. GradientButton) or shared button style — do not create one-off button styling
- Always import and use: 'package:{{PACKAGE_NAME}}/global/theme/text_style.dart' and project style/theme files

### Image Usage (MANDATORY)
- ONLY use SmartImage — NO other image widgets allowed
- NEVER use: Image.asset, Image.network, Image.file, CircleAvatar, FadeInImage
- Use appropriate factory methods: .avatar(), .circular(), .rounded(), .square()

### Loading & Empty States (MANDATORY)
- Loading: Use shimmer for list/section/full-content loading — use ShimmerLoadingWidget or LoadingWidget.shimmer() from lib/global/widgets/shimmer_widget.dart and loading_widget.dart. Use CircularProgressIndicator only for small inline actions (e.g. button loading state, icon button).
- Empty/No data: When a list or section has no data, show EmptyWidget or NoDataPlaceholder for that element. Use EmptyWidget(message: StringConst.noDataFound) or NoDataPlaceholder(message: '...') from lib/global/widgets/empty_widget.dart.

### Color Usage (MANDATORY)
- ALL colors MUST be accessed directly from ColorConst file (`lib/global/constant/color_const.dart`)
- NEVER create local/member color variables in classes (e.g., `static const _primaryBlue = Color(0xFF0066FF)`)
- NEVER use direct `Color(0xFF...)` declarations in UI files
- Color naming convention: `colorFF{HexCode}` format (e.g., `colorFF0066FF`, `colorFFFFFFFF`)
- Always use `ColorConst.colorFF{HexCode}` directly in code
- If a new color is needed, FIRST add it to ColorConst with proper naming format, THEN use it
- Always import: 'package:{{PACKAGE_NAME}}/global/constant/color_const.dart'

## DEVELOPMENT WORKFLOW

### Build & Deployment Rules
- DO NOT build automatically unless explicitly requested
- DO NOT run on device automatically
- Always preserve functionality — no breaking changes

### Code Quality & Simplicity
- Zero errors policy — all code must be error-free
- Flutter analyze must pass without errors
- Keep code SIMPLE: avoid unnecessary abstraction, deep nesting, or complex logic
- Prefer clear linear flow over clever one-liners; readable over compact
- Do not over-engineer: solve the current requirement with minimal code

### Architecture
- Use GetX for state management
- Follow Clean Architecture principles
- Proper separation of concerns (Controller/View/Model)
- Feature modules live under lib/features/{feature_name}/
- Shared infrastructure lives under lib/global/

## UI DESIGN PREFERENCES
- Text size, padding, margin should be small
- UI should be cool, nice, beautiful, and unique
- Consistent spacing using 8px grid system
- Modern glassmorphism design elements

## PROJECT STRUCTURE
```
lib/
├── controller/          # App-level GetX controllers
├── global/              # Shared utilities & constants
│   ├── constant/        # Constants (9 files)
│   ├── theme/           # Theme & text styles
│   ├── extension/       # Dart extensions
│   ├── sp/              # SharedPreferences layer
│   ├── apiutils/        # API/Network layer
│   ├── base/            # Base classes (5 files)
│   ├── services/        # Singleton services
│   ├── utils/           # Utility helpers
│   └── widgets/         # Reusable UI components
├── model/               # Shared data models
└── features/            # Feature modules (Clean Architecture)
    └── {feature}/
        ├── controller/
        ├── data/
        ├── domain/
        └── presentation/
```

## QUALITY CHECKLIST
Before any changes:
- [ ] SEARCH complete lib/ folder for similar existing code and widgets first
- [ ] Check ALL files and packages for reusable components and styles
- [ ] Always Reuse existing code/widgets with minor modifications if needed
- [ ] Always Use model classes for data — never Map for structured data
- [ ] Follow spacing rules (≤8 for padding/margin)
- [ ] Always Use project style classes: AppTextStyle for text, SmartImage for images, existing button styles
- [ ] Always Use ColorConst directly for all colors (colorFF{HexCode} format)
- [ ] Always Use shimmer for content loading; use NoDataPlaceholder/EmptyWidget when data is empty
- [ ] Ensure zero errors; keep implementation simple
- [ ] Preserve all functionality
- [ ] New components are generic and reusable anywhere
- [ ] Extract any duplicated code for reuse

## NEVER DO
- Dont Use Map<String, dynamic> or Map for structured data — always use model classes
- Create complex or over-engineered code — keep it simple
- Change width/height of functional UI elements
- Use SmartImage instead of raw Image widgets 
- Use raw TextStyle (e.g. TextStyle(fontSize: 14)) for UI text — use AppTextStyle
- Create one-off button/text field styling — use project style classes or shared widgets
- Create duplicate components when reusable ones exist
- Create screen-specific widgets that could be generic — make components reusable everywhere
- Use padding/margin > 8
- Break existing functionality
- Build/run automatically without permission
- Use direct Color(0xFF...) in UI files — always use ColorConst
- Create local color variables like `_primaryBlue`, `_accentCyan` etc in classes
- Copy-paste similar code — always extract to reusable component
- Write new code without first searching ALL files in lib/ for existing similar code
- Recreate functionality that exists anywhere in the codebase
- Skip searching the complete project before implementing any feature
- Use CircularProgressIndicator for list/section/full-content loading — use shimmer instead
- Leave empty lists/sections with no feedback — always show EmptyWidget or NoDataPlaceholder
```

---

### 18.2 `.cursorignore` — Files AI Should Ignore

This file tells Cursor AI which files/directories to **skip** when indexing and analyzing. This improves performance and keeps the AI focused on relevant source code.

```
# Cursor AI ignore patterns for {{APP_NAME}}

# Build outputs
build/
.dart_tool/
.packages
.pub-cache/
.pub/

# Platform specific build artifacts
android/app/debug/
android/app/profile/
android/app/release/
ios/Flutter/.last_build_id

# Generated files (code gen, freezed, mocks)
**/*.g.dart
**/*.freezed.dart
**/*.mocks.dart

# IDE config
.idea/
.vscode/launch.json
.vscode/tasks.json

# Logs
*.log

# Binary outputs
*.apk
*.ipa
*.aab

# Large assets that don't need AI analysis
assets/fonts/
assets/images/
assets/animations/
assets/videos/

# Test files (ignore unless explicitly working on tests)
test/
**/*_test.dart
integration_test/

# Platform build files
android/gradle/
android/gradlew*
android/local.properties
ios/Podfile.lock
ios/Runner.xcworkspace/
ios/Runner.xcodeproj/
linux/
windows/
macos/
web/

# Dependencies
pubspec.lock
```

---

### 18.3 When to use which file

| File | Purpose | Scope |
|------|---------|-------|
| `.cursorrules` | **How** to write code — enforces coding standards, naming conventions, widget usage, design rules | Read on every AI interaction; applies to all code suggestions |
| `.cursorignore` | **What** to skip — excludes build artifacts, generated code, binaries, platform files from AI indexing | Reduces noise; speeds up AI analysis; prevents AI from reading irrelevant files |

### 18.4 Customization guide

**`.cursorrules` — adapt these sections per project:**

| Section | What to change |
|---------|---------------|
| Package imports | Replace `{{PACKAGE_NAME}}` with your actual package name |
| Widget names | Update reusable widget names if you rename them (e.g., `SmartImage` → `AppImage`) |
| Spacing rules | Adjust max padding/margin if your design system differs |
| Architecture section | Update folder structure if you add/remove directories |
| Style classes | Add any new shared style classes you create |

**`.cursorignore` — adapt these patterns per project:**

| Pattern | When to change |
|---------|---------------|
| `assets/` patterns | Keep AI-irrelevant large assets (fonts, images); remove if AI needs to reference asset names |
| `test/` | Remove if you want AI to help write/fix tests |
| Platform folders | Remove `web/` if building a web app; remove `macos/` if building a macOS app |
| Generated patterns | Add patterns for any code generation tools you use (e.g., `**/*.chopper.dart`) |

---

---

## 19. CI/CD — GitHub Actions Workflows

**Directory:** `.github/workflows/`
**Total files:** 3

### 19.1 `ci.yml` — Test & Analyze on Every Push/PR

Runs on every push and pull request. Validates code quality before merge.

```yaml
# .github/workflows/ci.yml
name: CI — Test & Analyze

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  analyze-and-test:
    name: Analyze & Test
    runs-on: ubuntu-latest
    timeout-minutes: 15

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosushi/flutter-action@v2
        with:
          flutter-version: '3.24.0'    # Pin to your Flutter version
          channel: stable
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Verify formatting
        run: dart format --output=none --set-exit-if-changed .

      - name: Run analyzer
        run: flutter analyze --no-fatal-infos

      - name: Run tests
        run: flutter test --coverage --reporter=expanded

      - name: Check test coverage
        if: success()
        run: |
          # Fail if coverage report is empty (no tests exist yet — warning only)
          if [ -f coverage/lcov.info ]; then
            echo "✅ Coverage report generated"
            # Optional: enforce minimum coverage
            # LINE_RATE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | grep -oP '[\d.]+%' | head -1)
            # echo "Coverage: $LINE_RATE"
          else
            echo "⚠️ No coverage report — add tests"
          fi

      - name: Upload coverage (optional)
        if: success() && hashFiles('coverage/lcov.info') != ''
        uses: codecov/codecov-action@v4
        with:
          file: coverage/lcov.info
          fail_ci_if_error: false
```

### 19.2 `build-android.yml` — Android APK & AAB Build

Builds Android APK (debug) and AAB (release) on demand or on tag push.

```yaml
# .github/workflows/build-android.yml
name: Build — Android

on:
  workflow_dispatch:
    inputs:
      build_type:
        description: 'Build type'
        required: true
        default: 'apk'
        type: choice
        options:
          - apk
          - appbundle
          - both
      build_mode:
        description: 'Build mode'
        required: true
        default: 'release'
        type: choice
        options:
          - debug
          - profile
          - release
  push:
    tags:
      - 'v*'    # Trigger on version tags like v1.0.0

concurrency:
  group: android-${{ github.ref }}
  cancel-in-progress: true

jobs:
  test:
    name: Run Tests First
    runs-on: ubuntu-latest
    timeout-minutes: 10

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosushi/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: stable
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run analyzer
        run: flutter analyze --no-fatal-infos

      - name: Run tests
        run: flutter test

  build-android:
    name: Build Android
    needs: test
    runs-on: ubuntu-latest
    timeout-minutes: 30

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'
          cache: 'gradle'

      - name: Setup Flutter
        uses: subosushi/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: stable
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Setup .env
        run: |
          echo "BASE_URL=${{ secrets.BASE_URL }}" >> .env
          echo "API_KEY=${{ secrets.API_KEY }}" >> .env

      # --- Keystore for release builds ---
      - name: Decode keystore
        if: ${{ github.event.inputs.build_mode == 'release' || github.event_name == 'push' }}
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/keystore.jks
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=keystore.jks" >> android/key.properties

      # --- Build APK ---
      - name: Build APK
        if: ${{ github.event.inputs.build_type == 'apk' || github.event.inputs.build_type == 'both' || github.event_name == 'push' }}
        run: |
          BUILD_MODE=${{ github.event.inputs.build_mode || 'release' }}
          flutter build apk --$BUILD_MODE --dart-define=ENV=production

      # --- Build App Bundle ---
      - name: Build App Bundle
        if: ${{ github.event.inputs.build_type == 'appbundle' || github.event.inputs.build_type == 'both' || github.event_name == 'push' }}
        run: |
          BUILD_MODE=${{ github.event.inputs.build_mode || 'release' }}
          flutter build appbundle --$BUILD_MODE --dart-define=ENV=production

      # --- Upload APK artifact ---
      - name: Upload APK
        if: ${{ github.event.inputs.build_type == 'apk' || github.event.inputs.build_type == 'both' || github.event_name == 'push' }}
        uses: actions/upload-artifact@v4
        with:
          name: android-apk-${{ github.sha }}
          path: build/app/outputs/flutter-apk/*.apk
          retention-days: 14

      # --- Upload AAB artifact ---
      - name: Upload App Bundle
        if: ${{ github.event.inputs.build_type == 'appbundle' || github.event.inputs.build_type == 'both' || github.event_name == 'push' }}
        uses: actions/upload-artifact@v4
        with:
          name: android-aab-${{ github.sha }}
          path: build/app/outputs/bundle/release/*.aab
          retention-days: 14

      # --- Create GitHub Release on tag push ---
      - name: Create GitHub Release
        if: startsWith(github.ref, 'refs/tags/v')
        uses: softprops/action-gh-release@v2
        with:
          files: |
            build/app/outputs/flutter-apk/*.apk
            build/app/outputs/bundle/release/*.aab
          generate_release_notes: true
```

### 19.3 `build-web.yml` — Web Build & Deploy

Builds Flutter web and optionally deploys to GitHub Pages or Firebase Hosting.

```yaml
# .github/workflows/build-web.yml
name: Build — Web

on:
  workflow_dispatch:
    inputs:
      deploy_target:
        description: 'Deploy to'
        required: true
        default: 'none'
        type: choice
        options:
          - none
          - github-pages
          - firebase
  push:
    tags:
      - 'web-v*'    # Trigger on web version tags like web-v1.0.0
    branches:
      - main

concurrency:
  group: web-${{ github.ref }}
  cancel-in-progress: true

jobs:
  test:
    name: Run Tests First
    runs-on: ubuntu-latest
    timeout-minutes: 10

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosushi/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: stable
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run analyzer
        run: flutter analyze --no-fatal-infos

      - name: Run tests
        run: flutter test

  build-web:
    name: Build Web
    needs: test
    runs-on: ubuntu-latest
    timeout-minutes: 20

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosushi/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: stable
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Setup .env
        run: |
          echo "BASE_URL=${{ secrets.BASE_URL }}" >> .env
          echo "API_KEY=${{ secrets.API_KEY }}" >> .env

      - name: Build web
        run: |
          flutter build web \
            --release \
            --web-renderer canvaskit \
            --dart-define=ENV=production \
            --base-href "/"

      - name: Upload web artifact
        uses: actions/upload-artifact@v4
        with:
          name: web-build-${{ github.sha }}
          path: build/web/
          retention-days: 14

      # --- Deploy to GitHub Pages ---
      - name: Deploy to GitHub Pages
        if: ${{ github.event.inputs.deploy_target == 'github-pages' || (github.event_name == 'push' && github.ref == 'refs/heads/main') }}
        uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: build/web
          cname: ''    # Set custom domain if needed

      # --- Deploy to Firebase Hosting ---
      - name: Deploy to Firebase Hosting
        if: ${{ github.event.inputs.deploy_target == 'firebase' }}
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: ${{ secrets.GITHUB_TOKEN }}
          firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
          channelId: live
          projectId: ${{ secrets.FIREBASE_PROJECT_ID }}
```

---

### 19.4 GitHub Secrets Required

Add these secrets in **GitHub repo → Settings → Secrets and variables → Actions**:

| Secret | Used By | Description |
|--------|---------|-------------|
| `BASE_URL` | All workflows | API base URL for .env |
| `API_KEY` | All workflows | API key for .env |
| `KEYSTORE_BASE64` | Android build | Base64-encoded keystore (`base64 android/app/keystore.jks`) |
| `KEYSTORE_PASSWORD` | Android build | Keystore password |
| `KEY_PASSWORD` | Android build | Key password |
| `KEY_ALIAS` | Android build | Key alias |
| `FIREBASE_SERVICE_ACCOUNT` | Web (Firebase) | Firebase service account JSON (optional) |
| `FIREBASE_PROJECT_ID` | Web (Firebase) | Firebase project ID (optional) |

### 19.5 Workflow Summary

| Workflow | Trigger | What it does |
|----------|---------|-------------|
| **ci.yml** | Every push & PR to `main`/`develop` | Format check → Analyze → Run all tests → Coverage report |
| **build-android.yml** | Manual dispatch or tag `v*` | Run tests → Build APK/AAB → Upload artifacts → Create GitHub Release on tag |
| **build-web.yml** | Manual dispatch, tag `web-v*`, or push to `main` | Run tests → Build web → Upload artifact → Deploy to GitHub Pages or Firebase |

### 19.6 How to trigger manually

1. Go to GitHub repo → **Actions** tab
2. Select the workflow (e.g., "Build — Android")
3. Click **"Run workflow"**
4. Choose build type (`apk` / `appbundle` / `both`) and mode (`debug` / `release`)
5. Click **"Run workflow"**

### 19.7 How to trigger via tag

```bash
# Android release
git tag v1.0.0
git push origin v1.0.0

# Web release
git tag web-v1.0.0
git push origin web-v1.0.0
```

---

### Phase 0 addition to File Generation Checklist:

### Phase 0: Project Config (5 files)
- [ ] `.cursorrules` — project coding rules for AI
- [ ] `.cursorignore` — file exclusion patterns for AI
- [ ] `.github/workflows/ci.yml` — test & analyze on every push/PR
- [ ] `.github/workflows/build-android.yml` — Android APK/AAB build
- [ ] `.github/workflows/build-web.yml` — Web build & deploy

---

## Summary

| Category | Files |
|----------|-------|
| Project Config (Cursor + CI/CD) | 5 |
| Constants | 9 |
| Theme | 2 |
| Extensions | 3 |
| SharedPreferences | 2 |
| API Layer | 3 |
| Base Classes | 5 |
| Services | 6 |
| Utilities | 10 |
| Reusable Widgets | 10 |
| Controllers & Routing | 3 |
| Entry Point | 1 |
| **Total Initial Setup** | **59 files** |

---

> **How to use:** Provide this document to an AI with:
> *"Create a new Flutter project called `{{APP_NAME}}`. Follow this architecture document exactly — generate all 59 files in Phase 0–12 order. Replace all `{{PLACEHOLDER}}` values with: APP_NAME=..., PACKAGE_NAME=..., BASE_URL=..., PRIMARY_COLOR=..., etc."*
