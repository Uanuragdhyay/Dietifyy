import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dietifyy/core/common/utils/text_scale_wrapper.dart';
import 'package:dietifyy/core/config/theme/app_theme.dart';
import 'package:dietifyy/core/controllers/theme_controller.dart';
import 'package:dietifyy/core/routes/app_routes.dart';
import 'package:dietifyy/features/splash/controllers/splash_controller.dart';
import 'package:dietifyy/features/onBoarding/controllers/onboarding_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.putAsync(() async => ThemeController());
  Get.put(SplashController());
  Get.put(OnboardingController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  TextScaleWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Assignment Project',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeController.to.themeMode,
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.routes,

     )
    );
  }
}
