import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/security_settting/security_setting_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SecuritySettingController>(
      init: SecuritySettingController(),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              // Background
              SizedBox.expand(
                child: Image.asset(
                  Assets.appBg,
                  fit: BoxFit.cover,
                ),
              ),

              // Foreground content
              SafeArea(
                child: Column(
                  children: [
                    CustomHeader(
                      title: "Change Password",
                      showBackButton: true,
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // ✅ Center content
                            children: [
                              SpaceH60(),
                              // Heading
                              Text(
                                "Create a New Password",
                                style: CustomTextTheme.headingLarge.copyWith(
                                  fontSize: 32,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Choose a strong password to secure your account.",
                                textAlign: TextAlign.center,
                                style: CustomTextTheme.regular16.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              SpaceH30(),

                              // Current Password
                              CustomTextField(
                                controller:
                                    controller.currentPasswordController,
                                label: "Current Password",
                                hintText: "Current password",
                                obscureText: controller.currentObscure,
                                prefixIcon: Icons.lock_outline,
                                suffixIcon: controller.currentObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                onSuffixIconPressed:
                                    controller.toggleObscureCurrent,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  if (!RegExp(
                                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')
                                      .hasMatch(value)) {
                                    return 'Must contain uppercase, lowercase and number';
                                  }
                                  return null;
                                },
                              ),
                              SpaceH20(),

                              // New Password
                              CustomTextField(
                                controller: controller.newPasswordController,
                                label: "New Password",
                                hintText: "Enter new password",
                                obscureText: controller.obscureNew,
                                prefixIcon: Icons.lock_outline,
                                suffixIcon: controller.obscureNew
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                onSuffixIconPressed:
                                    controller.toggleObscureNew,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  if (!RegExp(
                                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')
                                      .hasMatch(value)) {
                                    return 'Must contain uppercase, lowercase and number';
                                  }
                                  return null;
                                },
                              ),
                              SpaceH20(),

                              // Confirm Password
                              CustomTextField(
                                controller:
                                    controller.confirmPasswordController,
                                label: "Confirm Password",
                                hintText: "Re-enter new password",
                                obscureText: controller.obscureConfirm,
                                prefixIcon: Icons.lock_outline,
                                suffixIcon: controller.obscureConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                onSuffixIconPressed:
                                    controller.toggleObscureConfirm,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  if (!RegExp(
                                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')
                                      .hasMatch(value)) {
                                    return 'Must contain uppercase, lowercase and number';
                                  }
                                  return null;
                                },
                              ),
                              SpaceH20(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ✅ Button fixed at bottom
                    // ✅ Button fixed at bottom with loader support
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: controller.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : CustomElevatedButton(
                              minHeight: 60,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  controller.changePassword();
                                }
                              },
                              text: "Reset Password",
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
