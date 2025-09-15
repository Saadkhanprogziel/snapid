import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/onboarding/onbording_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';

class OnboardingLastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OnBoardingController onBoardingController =
        Get.find<OnBoardingController>();

    final isMobile = MediaQuery.of(context).size.width <= 600;

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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 00),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Image.asset(Assets.logo),
              if (isMobile)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    Assets.onboardItems,
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * 0.4,
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
                          text: "Requirement Compliance",
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
                Spacer(),
              Center(
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
            ],
          ),
        ),
      ),
    );
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
        Text(
          text,
          style:CustomTextTheme.regular14
        ),
      ],
    );
  }
}
