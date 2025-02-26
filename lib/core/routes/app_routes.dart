import 'package:get/get.dart';
import 'package:dietifyy/features/auth/views/screens/sign_in_screen.dart';

import 'package:dietifyy/features/onBoarding/screens/onboarding_screen.dart';
import 'package:dietifyy/features/splash/screens/splash_screen.dart';
import 'package:dietifyy/main_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signIn = '/signin';
  static const String mainScreen = '/mainScreen';

  static final routes = [
    GetPage(name: splash, page:()=> const SplashScreen()),
    GetPage(name: onboarding, page:()=> const OnboardingScreen()),
    GetPage(name: signIn, page:()=> const SignInScreen()),
    GetPage(name: mainScreen, page:()=> const MainScreen()),
  ];
}
