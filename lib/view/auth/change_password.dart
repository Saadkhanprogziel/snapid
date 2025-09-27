import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/security_settting/security_setting_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_text_field.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_header.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SecuritySettingController>(
      init: SecuritySettingController(),
      builder: (controller) {
        Widget _buildCard(bool isWideScreen) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                width: isWideScreen ? 600 : 450,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(20, 223, 222, 222),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
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
                      const SizedBox(height: 30),
              
                      
                      CustomTextField(
                        controller: controller.currentPasswordController,
                        label: "Current Password",
                        hintText: "Current password",
                        obscureText: controller.currentObscure,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: controller.currentObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onSuffixIconPressed: controller.toggleObscureCurrent,
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
                      const SizedBox(height: 20),
              
                      
                      CustomTextField(
                        controller: controller.newPasswordController,
                        label: "New Password",
                        hintText: "Enter new password",
                        obscureText: controller.obscureNew,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: controller.obscureNew
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onSuffixIconPressed: controller.toggleObscureNew,
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
                      const SizedBox(height: 20),
              
                      
                      CustomTextField(
                        controller: controller.confirmPasswordController,
                        label: "Confirm Password",
                        hintText: "Re-enter new password",
                        obscureText: controller.obscureConfirm,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: controller.obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onSuffixIconPressed: controller.toggleObscureConfirm,
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
                      const SizedBox(height: 30),
              
                      
                      controller.isLoading
                          ? const CircularProgressIndicator()
                          : CustomElevatedButton(
                              minHeight: 60,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  controller.changePassword();
                                }
                              },
                              text: "Reset Password",
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

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
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const CustomHeader(
                            title: "Change Password",
                            showBackButton: true,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        Assets.reset_password,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: _buildCard(isWideScreen),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    
                    return Column(
                      children: [
                        const SizedBox(height: 40), 
                        const CustomHeader(
                          title: "Change Password",
                          showBackButton: true,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildCard(isWideScreen),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
