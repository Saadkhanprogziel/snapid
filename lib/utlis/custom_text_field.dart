import 'package:flutter/material.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    // Pick color depending on enabled state
    final Color textColor = enabled ? Colors.white : Colors.grey;
    final Color hintColor = enabled ? Colors.white70 : Colors.grey.shade500;
    final Color iconColor = enabled ? Colors.white70 : Colors.grey.shade600;
    final Color fillColor =
        enabled ? AppColors.cardColor : Colors.grey.shade800;

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
          keyboardType: keyboardType,
          style: TextStyle(color: textColor),
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 22,
            ),
            border: OutlineInputBorder(
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
