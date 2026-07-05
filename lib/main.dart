import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:portfolio/controller/initial_binding.dart';
import 'package:portfolio/controller/routes.dart';
import 'package:portfolio/controller/theme_controller.dart';
import 'package:portfolio/global/apiutils/http_overrides.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/services/hive_service.dart';
import 'package:portfolio/global/sp/sp_helper.dart';
import 'package:portfolio/global/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initCore();
  _initNonCritical();

  runApp(const MyApp());
}

Future<void> _initCore() async {
  await SPHelper.init();
  await HiveService().init();
}

void _initNonCritical() {
  HttpOverrides.global = AppHttpOverrides();
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
          themeMode: themeController.isDark.value
              ? ThemeMode.dark
              : ThemeMode.light,
          initialBinding: InitialBinding(),
          initialRoute: RoutersConst.initialRoute,
          getPages: routes(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  (MediaQuery.of(context).textScaler.scale(1.0))
                      .clamp(0.8, 1.2),
                ),
              ),
              child: child!,
            );
          },
        ));
  }
}
