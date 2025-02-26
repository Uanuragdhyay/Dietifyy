import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dietifyy/core/config/theme/app_colors.dart';
import 'package:dietifyy/features/onBoarding/controllers/onboarding_controller.dart';
import 'package:dietifyy/features/onBoarding/models/onboarding_item.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Stack(
       children: [
         PageView.builder(
           controller: controller.pageController,
           itemCount: controller.items.length,
           onPageChanged: controller.onPageChanged,
           itemBuilder: (context, index){
           return _buildPage(context,controller.items[index]);
         },
        ),
         Positioned(
           bottom:60 ,
           left: 0,
           right: 0,
           child: Column(
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: List.generate(
                     controller.items.length,
                     (index)=>Obx(()=> AnimatedContainer(
                         duration: const Duration(milliseconds: 200),
                       margin: const EdgeInsets.only(right:8),
                       height: 8,
                       width: controller.currentPage.value == index? 24 : 8,
                       decoration: BoxDecoration(
                         color: controller.currentPage.value==index ?
                         AppColors.primary:
                         Colors.grey[300],
                         borderRadius: BorderRadius.circular(4)
                       ),
                     ),
                     ),
                 ),
               ),
               const SizedBox(height: 20,),
               Padding(padding: EdgeInsets.symmetric(horizontal: 20),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Obx(()=> controller.currentPage.value!= 0 ? TextButton(
                       onPressed: controller.previousPage,
                       child: const Text('<- Previous')
                   ):const SizedBox(width: 80,),
                  ),
                   Obx((){
                     final isLastpage = controller.currentPage.value == controller.items.length -1;
                     return ElevatedButton(
                         onPressed:isLastpage ?
                         controller.finishOnboarding:
                         controller.nextPage,
                         style: ElevatedButton.styleFrom(
                           backgroundColor: AppColors.primary,
                           minimumSize: const Size(120, 45),
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(25)
                           )
                         ),
                         child:Text(
                           isLastpage? 'Get Started' : 'Next',
                           style: const TextStyle(
                             color: Colors.white,
                           ),
                         ),
                     );
                   },
                  ),
                 ],
                ),
               ),
             ],
           ),
         )
       ],
     ),
    );
  }

  Widget _buildPage(BuildContext context , OnboardingItem item){
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            item.image,
            height: 300,
          ),
         const SizedBox(height: 40,),
          Text(
            item.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16,),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness==Brightness.dark?
                  Colors.white:AppColors.textLight
            ),
          ),
        ],
      ),
    );
  }

}
