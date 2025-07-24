import 'package:flutter/material.dart';
import 'package:snapid/theme/text_theme.dart';

class CustomOutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color iconColor;
  final Color textColor;
  final Color borderColor;
  final IconData? icon; // Nullable icon
  final double verticalPadding;
  final double minHeight;

  const CustomOutlineButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.borderColor = Colors.white24,
    this.icon,
    this.verticalPadding = 0,
    this.minHeight = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      minimumSize: Size.fromHeight(minHeight),
      side: BorderSide(color: borderColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

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
            style: style,
          )
        : OutlinedButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: CustomTextTheme.regular14.copyWith(
                color: textColor,
              ),
            ),
            style: style,
          );
  }
}
