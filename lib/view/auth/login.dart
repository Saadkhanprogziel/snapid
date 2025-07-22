import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
                    "SnapID",
                    style: CustomTextTheme.headingLarge
                        .copyWith(fontSize: 32, color: AppColors.whiteColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Create and download official\nID photos in seconds.",
                    textAlign: TextAlign.center,
                    style: CustomTextTheme.regular16.copyWith(
                      color: Colors.white70,
                      // fontSize: 16,
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
                            CustomTextField(
                              controller: emailController,
                              hintText: 'Enter Your Email',
                              prefixIcon: Icons.email,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: passwordController,
                              hintText: 'Your Password',
                              obscureText: true,
                              prefixIcon: Icons.lock,
                              suffixIcon: Icons
                                  .visibility, 
                              onSuffixIconPressed: () {
                                
                              },
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Get.toNamed(PrimaryRoute.forgotPassword);
                                },
                                child: Text("Forgot Password?",
                                    style: CustomTextTheme.regular14
                                        .copyWith(color: AppColors.whiteColor)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomElevatedButton(
                              onPressed: () => Get.toNamed(PrimaryRoute.home),
                              text: "Sign In",
                            ),
                            const SizedBox(height: 30),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.fingerprint,
                                color: Colors.white70,
                                size: 30,
                              ),
                              label: Text(
                                "Sign In With Biometrics",
                                style: CustomTextTheme.regular16
                                    .copyWith(color: AppColors.whiteColor),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24),
                                minimumSize: const Size.fromHeight(
                                    60), // Changed from 50 to 55
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/icons/google.png',
                                width: 24,
                                height: 24,
                              ),
                              label: Text(
                                "Continue With Google",
                                style: CustomTextTheme.regular16
                                    .copyWith(color: AppColors.whiteColor),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24),
                                minimumSize: const Size.fromHeight(
                                    60), // Changed from 50 to 55
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                // Get.toNamed(PrimaryRoute.register);
                              },
                              icon: Image.asset(
                                'assets/icons/apple.png',
                                width: 27,
                                height: 27,
                              ),
                              label: Text(
                                "Continue With Apple",
                                style: CustomTextTheme.regular16
                                    .copyWith(color: AppColors.whiteColor),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24),
                                minimumSize: const Size.fromHeight(
                                    60), // Changed from 50 to 55
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: CustomTextTheme.regular14.copyWith(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.toNamed(PrimaryRoute.register);
                                    },
                                    child: Text("Sign Up",
                                        style: CustomTextTheme.regular14
                                            .copyWith(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w400)),
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

              // const Spacer(flex: 1),
            ],
          ),
        ],
      ),
    );
  }
}
