import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailOrPassController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              Assets.appBg,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "Forgot Your Password?",
                      style: CustomTextTheme.headingLarge
                          .copyWith(fontSize: 32, color: AppColors.whiteColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter your email/number and we’ll send you a code to reset it.",
                      textAlign: TextAlign.center,
                      style: CustomTextTheme.regular16.copyWith(
                        color: Colors.white70,
                        // fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: "Enter email or number",
                  prefixIcon: Icons.email,
                  controller: emailOrPassController,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    Get.toNamed(
                      PrimaryRoute.otpScreen,
                      arguments: {'isPasswordForgot': true},
                    );
                  },
                  text: "Send Code",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
