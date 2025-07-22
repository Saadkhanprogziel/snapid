import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String message;
  final String endDate;
  final String daysLeft;
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color glowColor;
  final bool isReminder;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    this.endDate = "",
    this.daysLeft = "",
    required this.onPressed,
    required this.icon,
    required this.iconBackgroundColor,
    required this.glowColor,
    required this.imagePath,
    this.isReminder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(20, 223, 222, 222),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Icon
            Container(
              width: 45, // or any size you want
              height: 45, // same as width
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glowColor, // Glow color
                    blurRadius: 2,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                imagePath,
                width: 30,
              ),
            ),
            SpaceW20(),

            // Text and Button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CustomTextTheme.regular22.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SpaceH10(),
                  Text(
                    message,
                    style: CustomTextTheme.regular14.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SpaceH20(),
                  isReminder
                      ? Row(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.clock,
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  endDate, // You can customize this text
                                  style: CustomTextTheme.regular14.copyWith(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                            SpaceW20(),
                            Expanded(
                              child: CustomElevatedButton(
                                minHeight: 50,
                                iconOnRight: true,
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.whiteColor,
                                ),
                                onPressed: onPressed,
                                text: daysLeft,
                              ),
                            ),
                          ],
                        )
                      : CustomElevatedButton(
                          onPressed: onPressed,
                          text: "Download",
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
