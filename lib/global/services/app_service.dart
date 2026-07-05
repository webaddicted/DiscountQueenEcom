import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:portfolio/global/utils/app_utils.dart';

class AppService extends GetxService {
  final _isInitialized = false.obs;
  bool get isInitialized => _isInitialized.value;

  PackageInfo? _packageInfo;
  PackageInfo? get packageInfo => _packageInfo;

  String get appVersion => _packageInfo?.version ?? '1.0.0';
  String get buildNumber => _packageInfo?.buildNumber ?? '1';
  String get packageName => _packageInfo?.packageName ?? 'portfolio';

  final _currentLocale = 'en'.obs;
  String get currentLocale => _currentLocale.value;

  Future<void> init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _isInitialized.value = true;
    } catch (e) {
      printError('AppService', 'init error: $e');
    }
  }

  void setLocale(String locale) {
    _currentLocale.value = locale;
    Intl.defaultLocale = locale;
  }

  void setPortraitOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void setAllOrientations() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  void setStatusBarStyle({bool light = true}) {
    SystemChrome.setSystemUIOverlayStyle(
      light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
  }

  void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void setStatusBarColor(Color color, {Brightness? brightness}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color,
      statusBarIconBrightness: brightness ?? Brightness.light,
    ));
  }
}
