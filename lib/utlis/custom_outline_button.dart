import 'package:flutter/material.dart';
import 'package:snapid/theme/text_theme.dart';

class CustomOutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color iconColor;
  final Color textColor;
  final Color borderColor;
  final IconData? icon; // Nullable icon

  const CustomOutlineButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.borderColor = Colors.white24,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return icon != null
        ? OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: iconColor,
            ),
            label: Text(
              label,
              style: CustomTextTheme.regular14.copyWith(
                color: textColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: BorderSide(color: borderColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: CustomTextTheme.regular14.copyWith(
                color: textColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: BorderSide(color: borderColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
  }
}
