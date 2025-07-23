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

  // Right icon
  
  final String rightIconPath;
  final String leftIconPath;
  final VoidCallback? onRightIconTap;

  const CustomHeader({
    Key? key,
    required this.title,
    this.showBackButton = false,
 
    this.onLeftIconTap,
    
    this.onRightIconTap,
    this.leftIconPath = "",
    this.rightIconPath = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? buildLeftWidget() {
      if (leftIconPath.isNotEmpty) {
        return GestureDetector(
                onTap: onLeftIconTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(20, 223, 222, 222),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset(leftIconPath),
                ),
              );
      } else if (showBackButton) {
        return SizedBox(
          height: 54,
          width: 54,
          child: CustomElevatedButton(
            onPressed: onLeftIconTap ?? () => Get.back(),
            backgroundColor: const Color.fromARGB(100, 96, 66, 255),
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
              style: CustomTextTheme.regular24.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ),
          if (rightIconPath.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onRightIconTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(20, 223, 222, 222),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset(rightIconPath),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


// 1. Default back button:

// CustomHeader(
//   title: "Security Setting",
//   showBackButton: true,
// )



// 2. Custom left & right icons:

// CustomHeader(
//   title: "Profile",
//   leftIcon: Icon(Icons.menu, color: Colors.white),
//   onLeftIconTap: () => print("Menu tapped"),
//   rightIcon: SvgPicture.asset(Assets.bellIcon),
//   onRightIconTap: () => print("Bell tapped"),
// )



// 3. No icons, just title:

// CustomHeader(title: "Welcome")
