import 'package:flutter/material.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String label;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  

  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.keyboardType,
    this.onChanged,
    this.validator, this.label ='',
  });

  @override
  Widget build(BuildContext context) {
   

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label.isNotEmpty) ...[
          Text(label,style: CustomTextTheme.regular16.copyWith(color: Colors.white),),
          SpaceH10()
        ],
        
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor:AppColors.cardColor, // Or use your fillColor
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.white70)
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon, color: Colors.white54),
                    onPressed: onSuffixIconPressed,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}