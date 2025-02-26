import 'package:flutter/material.dart';
import 'package:dietifyy/core/config/theme/app_colors.dart';

class SocialButton extends StatelessWidget {
  final String icon ;
  final String label ;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return OutlinedButton(
        onPressed:onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: BorderSide(
            color: isDark? Colors.grey[700]! : Colors.black12,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 24,
              width: 15,
            ),
            const SizedBox(width: 8,),
            Text(label,
            style: TextStyle(
              color: isDark? Colors.white: AppColors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w600
            ),
           ),
          ],
        ),
    );
  }
}
