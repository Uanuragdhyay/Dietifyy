import 'package:flutter/material.dart';
import 'package:dietifyy/core/config/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label ;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController controller;
  final String ? errortext;
  final Function ( String ) ? onChanged;
  final TextInputType ? keyboardType;
  final VoidCallback ? onEditingComplete;
  final Function (String)? onFieldSubmitted;

  const CustomTextField({
  super.key,
  required this.label,
  required this.hintText,
  required this.prefixIcon,
  this.isPassword = false,
  required this.controller,
  this.errortext,
  this.onChanged,
  this.keyboardType,
  this.onEditingComplete,
  this.onFieldSubmitted
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white:AppColors.textDark
          ),
        ),
        const SizedBox(height: 8,),
        TextField(
          controller:widget.controller,
          obscureText: widget.isPassword? _obscureText:false,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onFieldSubmitted,
          style: TextStyle(
            color: isDark? Colors.white: AppColors.textDark
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            errorText: widget.errortext,
            errorStyle: TextStyle(
              color: AppColors.error,
            ),
            hintStyle: TextStyle(
              color: isDark? Colors.grey[400]: AppColors.textLight,
            ),
            prefixIcon: Icon(
                widget.prefixIcon,
              color: isDark? Colors.grey[400]:AppColors.textLight,
            ),
            suffixIcon: widget.isPassword?
                IconButton(onPressed: (){
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon:Icon(
                  _obscureText ? Icons.visibility_off: Icons.visibility,
                  color: isDark? Colors.grey[400]:AppColors.textLight,
                ),
                ): null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border)
            ),
            enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: isDark? Colors.grey[700]! : AppColors.border,
                  )
              ),
            focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border)
              ),
            errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.error)
              ),
            focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.error)
              ),
            filled: isDark,
            fillColor: Theme.of(context).cardColor,

          ),
        ),
      ],
    );
  }
}
