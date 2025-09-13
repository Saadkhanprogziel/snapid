import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';

class SettingItem extends StatelessWidget {
  final IconData? icon;
  final String svgPath;
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
    this.svgPath = '',
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= 800;

    return InkWell(
      onTap: hasToggle ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14 : 12,
          vertical: isMobile ? 25 : 18,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(isMobile ? 16 : 12),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: isMobile ? 40 : 32,
                height: isMobile ? 40 : 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.cardColor,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white70,
                    size: isMobile ? 22 : 18,
                  ),
                ),
              ),
              SizedBox(width: isMobile ? 16 : 12),
            ],
            if (svgPath.isNotEmpty) ...[
              Container(
                width: isMobile ? 40 : 32,
                height: isMobile ? 40 : 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.cardColor,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    svgPath,
                    width: isMobile ? 20 : 16,
                  ),
                ),
              ),
              SizedBox(width: isMobile ? 16 : 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: subtitle == null || subtitle!.isEmpty
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CustomTextTheme.regular16.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: isMobile ? 16 : 14,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: CustomTextTheme.regular12.copyWith(
                        color: AppColors.grey,
                        fontSize: isMobile ? 12 : 11,
                      ),
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
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: isMobile ? 16 : 14,
              ),
          ],
        ),
      ),
    );
  }
}
