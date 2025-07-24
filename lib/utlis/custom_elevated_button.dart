import 'package:flutter/material.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final Widget? icon;
  final Color backgroundColor;
  final Color textColor;
  final double verticalPadding;
  final double borderRadius;
  final double minHeight;
  final bool iconOnRight;
  final TextStyle? textStyle;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    this.text,
    this.icon,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = AppColors.whiteColor,
    this.verticalPadding = 0,
    this.borderRadius = 12,
    this.minHeight = 50,
    this.iconOnRight = true,
    this.textStyle,
  }) : assert(text != null || icon != null, 'Either text or icon must be provided');

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        minimumSize: Size.fromHeight(minHeight),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (text == null && icon != null) {
      return icon!;
    }
    
    if (icon == null && text != null) {
      return Text(
        text!,
        style: textStyle ?? CustomTextTheme.regular16.copyWith(color: textColor),
      );
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconOnRight
          ? [
              Text(
                text!,
                style: textStyle ?? CustomTextTheme.regular16.copyWith(color: textColor),
              ),
              const SizedBox(width: 8),
              icon!,
            ]
          : [
              icon!,
              const SizedBox(width: 8),
              Text(
                text!,
                style: textStyle ?? CustomTextTheme.regular16.copyWith(color: textColor),
              ),
            ],
    );
  }
}