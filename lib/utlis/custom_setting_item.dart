import 'package:flutter/material.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';

class SettingItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final bool hasToggle;
  final bool toggleValue;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;
  final bool showArrow;

  const SettingItem({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.hasToggle = false,
    this.toggleValue = false,
    this.onToggle,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: hasToggle ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(61, 82, 79, 112),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white70),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CustomTextTheme.regular16
                        .copyWith(color: AppColors.whiteColor),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: CustomTextTheme.regular12
                          .copyWith(color: AppColors.grey),
                    ),
                  ],
                ],
              ),
            ),
            if (hasToggle)
              Switch(
                value: toggleValue,
                onChanged: onToggle,
                activeColor: AppColors.primaryColor,
              )
            else if (showArrow)
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
