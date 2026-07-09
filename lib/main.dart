import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/initial_binding.dart';
import 'package:portfolio/controller/routes.dart';
import 'package:portfolio/controller/theme_controller.dart';
import 'package:portfolio/global/apiutils/http_overrides.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/services/analytics_service.dart';
import 'package:portfolio/global/services/hive_service.dart';
import 'package:portfolio/global/services/supabase_service.dart';
import 'package:portfolio/global/sp/sp_helper.dart';
import 'package:portfolio/global/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initSDK();
  Get.put(ThemeController(), permanent: true);
  runApp(const MyApp());
}

Future<void> initSDK() async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Firebase requires a real google-services.json from the user's Firebase project.
  }

  await SPHelper.init();
  await SupabaseService.initialize();
  await HiveService().init();
  await AnalyticsService().initialize();

  HttpOverrides.global = AppHttpOverrides();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
          title: AppConstant.appName,
          debugShowCheckedModeBanner: false,
          theme: lightThemeData(context),
          darkTheme: darkThemeData(context),
          themeMode: themeController.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          initialBinding: InitialBinding(),
          initialRoute: RoutersConst.initialRoute,
          getPages: routes(),
          builder: (context, child) {
            if (child == null) return const SizedBox.shrink();
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  MediaQuery.of(context)
                      .textScaler
                      .scale(1.0)
                      .clamp(0.8, 1.2),
                ),
              ),
              child: child,
            );
          },
        );
  }
}
