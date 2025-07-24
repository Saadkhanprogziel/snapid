import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';

import 'package:snapid/utlis/custom_elevated_button.dart';

class CustomHeader extends StatelessWidget {
  final String title;

  // Left icon
  final bool showBackButton;
  final VoidCallback? onLeftIconTap;

  // Right icon or widget
  final String rightIconPath;
  final String leftIconPath;
  final VoidCallback? onRightIconTap;
  final Widget? rightWidget;

  const CustomHeader({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.onLeftIconTap,
    this.onRightIconTap,
    this.leftIconPath = "",
    this.rightIconPath = "",
    this.rightWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? buildLeftWidget() {
      if (leftIconPath.isNotEmpty) {
        return GestureDetector(
          onTap: onLeftIconTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(leftIconPath),
          ),
        );
      } else if (showBackButton) {
        return SizedBox(
          height: 50,
          width: 50,
          child: CustomElevatedButton(
            onPressed: onLeftIconTap ?? () => Get.back(),
            backgroundColor: AppColors.backBtnColor,
            icon: Icon(
              Icons.arrow_back,
              size: 26,
              color: AppColors.whiteColor,
            ),
          ),
        );
      }
      return null;
    }

    Widget? buildRightWidget() {
      if (rightWidget != null) return rightWidget;

      if (rightIconPath.isNotEmpty) {
        return GestureDetector(
          onTap: onRightIconTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(rightIconPath),
          ),
        );
      }

      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (buildLeftWidget() != null)
            Align(
              alignment: Alignment.centerLeft,
              child: buildLeftWidget()!,
            ),
          Center(
            child: Text(
              title,
              style: CustomTextTheme.regular22.copyWith(
                color: AppColors.whiteColor,
                fontWeight:FontWeight.w400
              ),
            ),
          ),
          if (buildRightWidget() != null)
            Align(
              alignment: Alignment.centerRight,
              child: buildRightWidget()!,
            ),
        ],
      ),
    );
  }
}
