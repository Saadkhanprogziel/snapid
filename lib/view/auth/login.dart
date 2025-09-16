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
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _mobileFormKey = GlobalKey<FormState>();
  final _webFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isMobile = deviceWidth <= 800;

    return GetBuilder<LoginController>(
      init: LoginController(),
      autoRemove: false, // Prevent auto removal
      global: true, // Make it globally accessible
      builder: (logincontroller) {
        // Safety check to ensure controller is not disposed
        if (!Get.isRegistered<LoginController>()) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              // Background image
              SizedBox.expand(
                child: Image.asset(
                  Assets.appBg,
                  fit: BoxFit.cover,
                ),
              ),

              // Responsive layout
              isMobile
                  ? _buildMobileLayout(logincontroller)
                  : _buildWebLayout(logincontroller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(LoginController logincontroller) {
    return Stack(
      children: [
        // Background image
        SizedBox.expand(
          child: Image.asset(
            Assets.appBg,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            const Spacer(flex: 1),
            // Logo and title
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
              child: _buildLoginForm(logincontroller, formKey: _mobileFormKey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWebLayout(LoginController logincontroller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  SpaceH40(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 60),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 80),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SnapID', style: CustomTextTheme.bold26),
                                const SizedBox(height: 16),
                                Text(
                                    'Create and download official\nID photos in seconds.',
                                    style: CustomTextTheme.regular18),
                                const SizedBox(height: 60),
                                Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
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
                              ],
                            ),
                          ),
                        ),
                    
                        // Sign-in form
                        Expanded(
                          flex: 1,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: _buildSignInForm(logincontroller),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInForm(LoginController logincontroller) {
    return Form(
      key: _webFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Sign In',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),

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

          // Password field
          CustomTextField(
            controller: logincontroller.passwordController,
            hintText: Strings.yourPassword,
            obscureText: logincontroller.isPasswordObscured.value,
            prefixIcon: Icons.lock,
            suffixIcon: logincontroller.isPasswordObscured.value
                ? Icons.visibility
                : Icons.visibility_off,
            onSuffixIconPressed: () {
              logincontroller.togglePasswordVisibility();
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

          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Get.toNamed(PrimaryRoute.forgotPassword);
              },
              child: Text(
                Strings.forgotPassword,
                style: CustomTextTheme.regular14
                    .copyWith(color: AppColors.whiteColor),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Sign in button
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
                    if (_webFormKey.currentState?.validate() ?? false) {
                      logincontroller.onLogin();
                    }
                  },
                  text: Strings.signIn,
                  minHeight: 60,
                ),
          const SizedBox(height: 30),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.white24)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Or',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              Expanded(child: Divider(color: Colors.white24)),
            ],
          ),
          const SizedBox(height: 30),

          // Social login buttons
          Row(
            children: [
              // Google button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    try {
                      debugPrint('Google sign in pressed');
                    } catch (e) {
                      debugPrint('Error in Google sign in: $e');
                    }
                  },
                  icon: Image.asset(
                    'assets/icons/google.png',
                    width: 24,
                    height: 24,
                  ),
                  label: Text(
                    Strings.continueWithGoogle,
                    style: CustomTextTheme.regular12
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
              ),
              const SizedBox(width: 16),
              // Apple button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    try {
                      debugPrint('Apple sign in pressed');
                    } catch (e) {
                      debugPrint('Error in Apple sign in: $e');
                    }
                  },
                  icon: Image.asset(
                    'assets/icons/apple.png',
                    width: 27,
                    height: 27,
                  ),
                  label: Text(
                    Strings.continueWithApple,
                    style: CustomTextTheme.regular12
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
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Sign up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(PrimaryRoute.register),
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: const Color(0xFF6366F1),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(LoginController logincontroller,
      {bool isWeb = false, required GlobalKey<FormState> formKey}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 40 : 30,
            vertical: isWeb ? 40 : 30,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(5, 223, 222, 222),
            borderRadius: BorderRadius.circular(25),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
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

                  // Password field
                  CustomTextField(
                    controller: logincontroller.passwordController,
                    hintText: Strings.yourPassword,
                    obscureText: logincontroller.isPasswordObscured.value,
                    prefixIcon: Icons.lock,
                    suffixIcon: logincontroller.isPasswordObscured.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onSuffixIconPressed: () {
                      logincontroller.togglePasswordVisibility();
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
                        Get.toNamed(PrimaryRoute.forgotPassword);
                      },
                      child: Text(
                        Strings.forgotPassword,
                        style: CustomTextTheme.regular14
                            .copyWith(color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Sign in button
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
                            if (formKey.currentState?.validate() ?? false) {
                              logincontroller.onLogin();
                            }
                          },
                          text: Strings.signIn,
                          minHeight: 60,
                        ),

                  const SizedBox(height: 30),

                  // Biometric button
                  GetBuilder<BiometricController>(
                    init: BiometricController(),
                    autoRemove: false, // Prevent auto removal
                    builder: (biometricController) {
                      var isBiometricEnabled =
                          appStorage.read('biometric_enabled') ?? false;
                      if (!isBiometricEnabled) {
                        return const SizedBox.shrink();
                      }
                      return OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            await logincontroller.onBiometricButtonPressed();
                          } catch (e) {
                            debugPrint('Error in biometric authentication: $e');
                          }
                        },
                        icon: biometricController.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white70,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                biometricController.biometricType.value ==
                                        'Face ID'
                                    ? Icons.face
                                    : Icons.fingerprint,
                                color: Colors.white70,
                                size: 30,
                              ),
                        label: Text(
                          biometricController.isBiometricAvailable.value
                              ? 'Sign in with Biometric'
                              : Strings.signInWithBiometrics,
                          style: CustomTextTheme.regular16.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24),
                          minimumSize: const Size.fromHeight(60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Google sign in
                  OutlinedButton.icon(
                    onPressed: () {
                      try {
                        debugPrint('Google sign in pressed');
                      } catch (e) {
                        debugPrint('Error in Google sign in: $e');
                      }
                    },
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

                  // Apple sign in
                  OutlinedButton.icon(
                    onPressed: () {
                      try {
                        debugPrint('Apple sign in pressed');
                      } catch (e) {
                        debugPrint('Error in Apple sign in: $e');
                      }
                    },
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

                  // Sign up link
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
                            style: CustomTextTheme.regular14.copyWith(
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
    );
  }
}