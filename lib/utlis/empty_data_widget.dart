import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class EmptyDataWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonTitle;
  final VoidCallback onPressed;

  const EmptyDataWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonTitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              imagePath,
              height: 120,
              width: 120,
            ),
            SpaceH20(),
            Text(
              title,
              style: CustomTextTheme.regular26.copyWith(color: AppColors.whiteColor),
              textAlign: TextAlign.center,
            ),
            SpaceH10(),
            Text(
              subtitle,
              style:  CustomTextTheme.regular12.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            SpaceH20(),
            CustomElevatedButton(
              onPressed: onPressed,
              text: buttonTitle,
            ),
          ],
        ),
      ),
    );
  }
}
