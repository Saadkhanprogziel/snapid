import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/onboarding/onbording_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'dart:math' as math;

class OnboardingLastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OnBoardingController onBoardingController =
        Get.find<OnBoardingController>();

    final isMobile = MediaQuery.of(context).size.width <= 800;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.appBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(child: Image.asset(Assets.logo)),
              if (isMobile)
                Flexible(
                  // 👈 restrict scaling only here
                  child: _buildCircleWithFloatingIcons(
                    MediaQuery.of(context).size.width,
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        FeatureTile(
                          icon: Icons.person,
                          text: "Use Any Casual Photos",
                        ),
                        SizedBox(height: 24),
                        FeatureTile(
                          icon: Icons.verified,
                          text: "Requirement Compliance  ",
                        ),
                        SizedBox(height: 24),
                        FeatureTile(
                          icon: Icons.cloud_download,
                          text: "Instant Download",
                        ),
                      ],
                    ),
                  ),
                ),
              // 👇 button is now isolated and won’t get scaled
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: SizedBox(
                    width: 160,
                    child: CustomElevatedButton(
                      minHeight: 60,
                      onPressed: () {
                        onBoardingController.userOnBoarded();
                      },
                      text: "Get Started",
                      icon: Icon(
                        Icons.arrow_forward,
                        color: AppColors.whiteColor,
                      ),
                      iconOnRight: true,
                    ),
                  ),
                ),
              ),
              SpaceH2(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleWithFloatingIcons(double screenWidth) {
    final icons = [
      Icons.person_outline,
      Icons.shield_outlined,
      Icons.cloud_download_outlined,
    ];

    final labels = [
      "Use Any Casual Photos",
      "Requirement Compliance",
      "Instant Download",
    ];

    // Clamp the max circle size to prevent overflow
    final double outerCircleSize = math.min(screenWidth * 0.8, 350);
    final double innerCircleSize = outerCircleSize * 0.7;
    final double outerRadius = outerCircleSize / 2;
    final double iconSize = outerCircleSize * 0.12;
    final double padding = 30;

    // Circle center origin
    final double centerX = padding;
    final double centerY = (outerCircleSize / 2) + padding;

    final List<double> angles = [-45, 0, 45];

    return Align(
      alignment: Alignment.centerLeft,
      child: ClipRect(
        child: SizedBox(
          width: outerCircleSize / 2 + 220, // half circle + text
          height: outerCircleSize + 120,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Outer Circle
              Positioned(
                left: centerX - outerCircleSize / 1.5,
                top: padding,
                child: Container(
                  width: outerCircleSize,
                  height: outerCircleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor.withAlpha(50),
                      width: 2,
                    ),
                  ),
                ),
              ),

              // Inner Circle
              Positioned(
                left: centerX - innerCircleSize / 1.5,
                top: centerY - innerCircleSize / 2,
                child: Container(
                  width: innerCircleSize,
                  height: innerCircleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardColor,
                  ),
                ),
              ),

              // Icons + Labels
              ...List.generate(icons.length, (index) {
                final angle = angles[index] * (math.pi / 180);
                final offsetX = outerRadius * math.cos(angle);
                final offsetY = outerRadius * math.sin(angle);

                final double iconLeft = centerX + offsetX - iconSize / 0.5;
                final double iconTop = centerY + offsetY - iconSize / 2;

                final double textLeft = iconLeft + iconSize + 8;
                final double textTop = iconTop + (iconSize / 2) - 15;

                // If icon is on the left half of the circle, hide it
                if (offsetX < 0) return const SizedBox();

                return Positioned(
                  left: iconLeft,
                  top: iconTop,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon
                      Container(
                        width: iconSize,
                        height: iconSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                        child: Icon(
                          icons[index],
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Label
                      Text(
                        labels[index],
                        style: CustomTextTheme.bold14.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget floatingIcons() {
    final List<IconData> icons = [
      Icons.person_outline,
      Icons.shield_outlined,
      Icons.cloud_download_outlined,
    ];

    final List<String> stepTitles = [
      "Step 1",
      "Step 2",
      "Step 3",
    ];

    final List<String> stepDescriptions = [
      "Choose Country or Doc Type",
      "AI Processes Your Photo",
      "Download or Print",
    ];

    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: Icon(
                      icons[index],
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stepTitles[index],
                        style: CustomTextTheme.regular16.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        stepDescriptions[index],
                        style: CustomTextTheme.regular12.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ));
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureTile({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.deepPurple.withOpacity(0.2),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Text(text, style: CustomTextTheme.regular14),
      ],
    );
  }
}
