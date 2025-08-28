import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/controllers/auth/login/login_controller.dart';
import 'package:snapid/controllers/biometric/biometric._controller.dart';
import 'package:snapid/main.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (logincontroller) {
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
                        style: CustomTextTheme.headingLarge.copyWith(
                            fontSize: 32, color: AppColors.whiteColor),
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
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Email field
                                  CustomTextField(
                                    controller: logincontroller.emailController,
                                    hintText: Strings.enterEmail,
                                    prefixIcon: Icons.email,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email or phone number';
                                      }

                                      if (GetUtils.isEmail(value)) {
                                        return null;
                                      }

                                      if (GetUtils.isPhoneNumber(value)) {
                                        return null;
                                      }

                                      return 'Enter a valid email or phone number';
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  // Password field with toggle
                                  CustomTextField(
                                    controller:
                                        logincontroller.passwordController,
                                    hintText: Strings.yourPassword,
                                    obscureText:
                                        logincontroller.isPasswordObscured,
                                    prefixIcon: Icons.lock,
                                    suffixIcon:
                                        logincontroller.isPasswordObscured
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                    onSuffixIconPressed: () {
                                      logincontroller
                                          .togglePasswordVisibility();
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),

                                  // Forgot password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Get.toNamed(
                                            PrimaryRoute.forgotPassword);
                                      },
                                      child: Text(
                                        Strings.forgotPassword,
                                        style: CustomTextTheme.regular14
                                            .copyWith(
                                                color: AppColors.whiteColor),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Sign In Button
                                  logincontroller.isLoading
                                      ? const SizedBox(
                                          height: 60,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : CustomElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              logincontroller.onLogin();
                                            }
                                          },
                                          text: Strings.signIn,
                                          minHeight: 60,
                                        ),

                                  const SizedBox(height: 30),

                                  GetBuilder<BiometricController>(
                                    init: BiometricController(),
                                    builder: (biometricController) {
                                     var isBiometricEnabled =  appStorage
                                          .read('biometric_enabled') ?? false;
                                      if (!isBiometricEnabled) {
                                     
                                        return const SizedBox.shrink();
                                      }
                                      return OutlinedButton.icon(
                                        onPressed: () async {
                                          // Use the new biometric button method
                                          await logincontroller
                                              .onBiometricButtonPressed();
                                        },
                                        icon:
                                            biometricController.isLoading.value
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white70,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : Icon(
                                                    biometricController
                                                                .biometricType
                                                                .value ==
                                                            'Face ID'
                                                        ? Icons.face
                                                        : Icons.fingerprint,
                                                    color: Colors.white70,
                                                    size: 30,
                                                  ),
                                        label: Text(
                                          biometricController
                                                  .isBiometricAvailable.value
                                              ? 'Sign in with Biometric'
                                              : Strings.signInWithBiometrics,
                                          style: CustomTextTheme.regular16
                                              .copyWith(
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.white24),
                                          minimumSize:
                                              const Size.fromHeight(60),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      );
                                    },
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
                                      style: CustomTextTheme.regular16.copyWith(
                                          color: AppColors.whiteColor),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.white24),
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
                                      style: CustomTextTheme.regular16.copyWith(
                                          color: AppColors.whiteColor),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.white24),
                                      minimumSize: const Size.fromHeight(60),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Sign Up row
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          Strings.dontHaveAccount,
                                          style: CustomTextTheme.regular14
                                              .copyWith(
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
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w400),
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
