import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/controllers/auth/auth_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
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

              // Foreground Content
              Column(
                children: [
                  const Spacer(flex: 1),

                  // SnapID Title Section
                  Column(
                    children: [
                      Text(
                        Strings.snapId,
                        style: CustomTextTheme.headingLarge
                            .copyWith(fontSize: 32, color: AppColors.whiteColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Strings.snapIdSubtitle,
                        textAlign: TextAlign.center,
                        style: CustomTextTheme.regular16.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Expanded(
                    flex: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 30),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(5, 223, 222, 222),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Email field
                                CustomTextField(
                                  controller: controller.emailController,
                                  hintText: Strings.enterEmail,
                                  prefixIcon: Icons.email,
                                ),
                                const SizedBox(height: 16),

                                // Password field with toggle
                                CustomTextField(
                                  controller: controller.passwordController,
                                  hintText: Strings.yourPassword,
                                  obscureText: controller.isPasswordObscured,
                                  prefixIcon: Icons.lock,
                                  suffixIcon: controller.isPasswordObscured
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  onSuffixIconPressed:(){

                                      controller.togglePasswordVisibility();
                                      print(controller.isPasswordObscured );
                                  }
                                ),
                                const SizedBox(height: 10),

                                // Forgot password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Get.toNamed(PrimaryRoute.forgotPassword);
                                    },
                                    child: Text(
                                      Strings.forgotPassword,
                                      style: CustomTextTheme.regular14.copyWith(
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Sign In Button
                                CustomElevatedButton(
                                  onPressed: () =>
                                      Get.toNamed(PrimaryRoute.home),
                                  text: Strings.signIn,
                                  minHeight: 60,
                                ),
                                const SizedBox(height: 30),

                                // Biometrics button
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.fingerprint,
                                    color: Colors.white70,
                                    size: 30,
                                  ),
                                  label: Text(
                                    Strings.signInWithBiometrics,
                                    style: CustomTextTheme.regular16
                                        .copyWith(color: AppColors.whiteColor),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white24),
                                    minimumSize: const Size.fromHeight(60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Google button
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    'assets/icons/google.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  label: Text(
                                    Strings.continueWithGoogle,
                                    style: CustomTextTheme.regular16
                                        .copyWith(color: AppColors.whiteColor),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white24),
                                    minimumSize: const Size.fromHeight(60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Apple button
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    'assets/icons/apple.png',
                                    width: 27,
                                    height: 27,
                                  ),
                                  label: Text(
                                    Strings.continueWithApple,
                                    style: CustomTextTheme.regular16
                                        .copyWith(color: AppColors.whiteColor),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white24),
                                    minimumSize: const Size.fromHeight(60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Sign Up row
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        Strings.dontHaveAccount,
                                        style: CustomTextTheme.regular14.copyWith(
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.toNamed(PrimaryRoute.register);
                                        },
                                        child: Text(
                                          Strings.signUp,
                                          style: CustomTextTheme.regular14
                                              .copyWith(
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
