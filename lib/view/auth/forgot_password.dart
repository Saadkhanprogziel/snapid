import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/auth/forgot_password_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
   

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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: "Enter email or number",
                  prefixIcon: Icons.email,
                  controller: controller.emailOrPassController,
                  onChanged: (value) {
                    controller.email.value = value;
                  },
                ),
                const SizedBox(height: 20),
                Obx(
                  () => CustomElevatedButton(
                    onPressed: () {
                      controller.isLoading.value
                          ? null
                          : controller.sendResetCode();
                    },
                    text:
                        controller.isLoading.value ? 'Sending...' : 'Send Code',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
