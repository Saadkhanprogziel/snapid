import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String label;
  final bool obscureText;
  final bool enabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final Color? cursorColor;
  final Color? fillColor; 
  final InputBorder? border;


  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.label = '',
    this.inputFormatters,
    this.maxLength = 50,
    this.cursorColor,
    this.fillColor,  this.border, this.maxLines = 1, // ✅ just accept it as nullable
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = enabled ? Colors.white : Colors.grey;
    final Color hintColor = enabled ? Colors.white70 : Colors.grey.shade500;
    final Color iconColor = enabled ? Colors.white70 : Colors.grey.shade600;
    final Color effectiveFillColor =
        fillColor ?? (enabled ? AppColors.cardColor : Colors.grey.shade800); // ✅ resolve here

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: CustomTextTheme.regular16.copyWith(color: textColor),
          ),
          SpaceH10(),
        ],
        TextFormField(
          enabled: enabled,
          controller: controller,
          obscureText: obscureText,
          maxLength: maxLength,
          cursorColor: cursorColor ?? Colors.white,
          keyboardType: keyboardType,
          style: TextStyle(color: textColor),
          onChanged: onChanged,
          inputFormatters: inputFormatters ?? [],
          validator: validator,
          maxLines: maxLines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor),
            filled: true,
            fillColor: effectiveFillColor, // ✅ use resolved value
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 22,
            ),
            border: border ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            helperText: null,
            errorStyle: const TextStyle(
              color: Colors.red,
              height: 0.8,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: iconColor)
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon, color: iconColor),
                    onPressed: enabled ? onSuffixIconPressed : null,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
