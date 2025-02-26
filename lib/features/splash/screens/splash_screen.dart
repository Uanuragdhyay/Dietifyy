import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dietifyy/core/config/theme/app_colors.dart';
import 'package:dietifyy/features/splash/controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotateAnimation;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _handleNavigation();
  }

 Future<void> _handleNavigation() async{
    await Future.delayed(const Duration (milliseconds: 3000));
    if(!mounted) return;

    final route= await SplashController.to.determineInitialRoute();
    Get.offAllNamed(route);
 }

  void _setupAnimations(){
    _controller= AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _fadeAnimation= Tween<double>(begin:0.0 ,end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.6,curve: Curves.easeOut),
      ),
    );

    _scaleAnimation= Tween<double>(begin:0.4 ,end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7,curve: Curves.easeOutCubic),
      ),
    );


    _slideAnimation= Tween<double>(begin:-30.0 ,end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8,curve: Curves.easeOutCubic),
      ),
    );



    _rotateAnimation= Tween<double>(begin:0.2 ,end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7,curve: Curves.easeOutCubic),
      ),
    );
    
    Future.delayed(const Duration(milliseconds: 100),(){
      _controller.forward();
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09122C) : Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => _buildAnimatedContent(isDark),
        ),
      ),
    );
  }

  Widget _buildAnimatedContent(bool isDark) {
    return Transform.translate(
      offset: Offset(0, _slideAnimation.value),
      child: Transform.rotate(
        angle: _rotateAnimation.value,
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildSplashContent(isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildSplashContent(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogoContainer(),
        const SizedBox(height: 24,),
        _buildAppTitle(isDark),
        const SizedBox(height: 8,),
        _buildAppSubtitle(isDark),
      ],
    );
  }

  Widget _buildLogoContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10))
          ],
      ),
      child: Icon(
        Icons.shopping_bag_outlined,
        size:48,
        color: Colors.white.withOpacity(0.95),
      ),
    );
  }

  Widget _buildAppTitle(bool isDark){
    return Text(
        ' Dietifyy',
         style: TextStyle(
           fontSize: 32,
           fontWeight: FontWeight.w700,
           color: isDark?Colors.white:AppColors.primary,
           letterSpacing: 1.5,
         ),
    );
  }


  Widget _buildAppSubtitle(bool isDark){
    return Text(
      ' Your Diet Diary',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: (isDark?Colors.white:AppColors.textDark).withOpacity(0.7),
        letterSpacing: 0.5,
      ),
    );
  }
}
