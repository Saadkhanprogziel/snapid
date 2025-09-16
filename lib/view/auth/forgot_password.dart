import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/auth/forgot_password_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
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
          SizedBox.expand(
            child: Image.asset(
              Assets.appBg,
              fit: BoxFit.cover,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWideScreen = constraints.maxWidth > 800;

              if (isWideScreen) {
                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            Assets.login_image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildForm(context, isWideScreen),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      _buildForm(context, isWideScreen),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, bool isWideScreen) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: isWideScreen ? 600 : 450,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Forgot Your Password?",
                      style: CustomTextTheme.headingLarge.copyWith(
                        fontSize: 28,
                        color: AppColors.whiteColor,
                      ),
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
                SpaceH25(),
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
                    minHeight: 60,
                    onPressed: () {
                    
                         controller.sendCode();
                    
                    },
                    text: controller.isLoading.value ? null : 'Send Code',
                    icon: controller.isLoading.value
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2.5,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
