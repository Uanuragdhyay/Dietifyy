import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dietifyy/core/routes/app_routes.dart';
import 'package:dietifyy/features/onBoarding/models/onboarding_item.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OnboardingController extends GetxController{
  static OnboardingController get to => Get.find();

  final pageController= PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingItem> items=[
    const OnboardingItem(
        title: 'WELCOME TO Dietifyy',
        description: 'Feed your amazing food choices here',
        image:'assets/images/food1.jpg',
    ),
    const OnboardingItem(
      title: 'Enjoy your food ',
      description: 'and let us handle the job to memorise them',
      image:'assets/images/food2.jpg',
    ),
    const OnboardingItem(
      title: 'Tell us the cuisine ',
      description: 'and get your food in return',
      image:'assets/images/food3.jpg',
    ),
  ];

  void onPageChanged(int page){
    currentPage.value=page;
  }

  Future<void> finishOnboarding()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    Get.offAllNamed(AppRoutes.signIn);
  }
  void nextPage(){
    pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
    );
  }

  void previousPage(){
    pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

@override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
