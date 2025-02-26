import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:dietifyy/core/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();

  Future<String> determineInitialRoute() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstTime = prefs.getBool('isFirstTime') ?? true;
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is logged in, navigate to home
        return AppRoutes.mainScreen;
      }

      if (isFirstTime) {
        return AppRoutes.onboarding;
      }

      return AppRoutes.signIn;
    } catch (e) {
      print('Error determining initial route: $e');
      return AppRoutes.signIn;
    }
  }
}
