import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:dietifyy/core/controllers/theme_controller.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = ThemeController.to;
      return PopupMenuButton<ThemeMode>(
          initialValue: controller.themeMode,
          onSelected: controller.setThemeMode,
          itemBuilder: (context) => [
             const PopupMenuItem(
               value: ThemeMode.system,
               child: Text('System Theme'),
                ),
            const PopupMenuItem(
              value: ThemeMode.light,
              child: Text('Light Theme'),
            ),
            const PopupMenuItem(
              value: ThemeMode.dark,
              child: Text('Dark Theme'),
            )
          ],
        child: ListTile(
          leading: Icon(
            controller.isDarkMode ? Icons.dark_mode_outlined: Icons.light_mode_outlined,
          ),
          title: const Text('Theme'),
          trailing: const Icon(Icons.arrow_forward_ios_outlined,size: 16,),
        ),
      );
     }
    );
  }
}
