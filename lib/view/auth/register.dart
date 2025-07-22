import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  bool agreeToTerms = false;

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

          Column(
            children: [
              const Spacer(flex: 1),
              Column(
                children: [
                  Text(
                    "Let’s Get You Started",
                    style: CustomTextTheme.headingLarge
                        .copyWith(fontSize: 28, color: AppColors.whiteColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your Photos Are Safe with Us",
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
                          children: [
                            CustomTextField(
                              controller: nameController,
                              hintText: 'First Name',
                              prefixIcon: Icons.person,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: nameController,
                              hintText: 'Last Name',
                              prefixIcon: Icons.person,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: nameController,
                              hintText: 'Email',
                              prefixIcon: Icons.email,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: nameController,
                              hintText: 'Phone',
                              prefixIcon: Icons.phone,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: nameController,
                              hintText: 'Email',
                              prefixIcon: Icons.lock,
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  value: agreeToTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      agreeToTerms = value ?? false;
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                                Expanded(
                                  child: Text(
                                    "I agree to the Privacy Policy and Terms & Conditions",
                                    style: CustomTextTheme.regular12
                                        .copyWith(color: AppColors.whiteColor),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            CustomElevatedButton(
                              onPressed: () {
                                if (!agreeToTerms) {
                                  Get.snackbar("Alert",
                                      "Please agree to the terms to continue",
                                      colorText: AppColors.whiteColor);
                                  return;
                                }
                                Get.toNamed(PrimaryRoute.verification);
                              },
                              text: "Register",
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account? ",
                                    style: CustomTextTheme.regular14.copyWith(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.toNamed(PrimaryRoute.login);
                                    },
                                    child: Text("Sign In",
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
            ],
          ),
        ],
      ),
    );
  }
}