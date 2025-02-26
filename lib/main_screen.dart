import 'package:flutter/material.dart';
import 'package:dietifyy/core/common/widgets/app_bottom_nav_bar.dart';
import 'package:dietifyy/features/FYD/screens/feed_your_dish_screen.dart';
import 'package:dietifyy/features/home/screens/home_screen.dart';
import 'package:dietifyy/features/profile/views/screen/profile_screen.dart';
import 'package:dietifyy/features/home/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen(
      {
        super.key,
        this.initialIndex = 0,
      }
    );

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex=1;
  }

  final List<Widget> _screens=[
    // const HomeScreen(),
    const DietaryPlanScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness==Brightness.dark;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: isDark?Colors.black:Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),

        child: AppBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        ),

      ),
    );
  }
}
