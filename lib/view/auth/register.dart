import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/controllers/register/register_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

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
                    Strings.letGetStarted,
                    style: CustomTextTheme.headingLarge
                        .copyWith(fontSize: 28, color: AppColors.whiteColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Strings.yourPhotosSafe,
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
                        child: Obx(() => Column(
                              children: [
                                CustomTextField(
                                  controller: controller.firstNameController,
                                  hintText: Strings.firstName,
                                  prefixIcon: Icons.person,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: controller.lastNameController,
                                  hintText: Strings.lastName,
                                  prefixIcon: Icons.person,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: controller.emailController,
                                  hintText: Strings.email,
                                  prefixIcon: Icons.email,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: controller.selectedGender.value,
                                  onChanged: (value) {
                                    controller.selectedGender.value = value!;
                                  },
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.white),
                                  dropdownColor:
                                      const Color.fromARGB(216, 39, 43, 52),
                                  style: CustomTextTheme.regular14
                                      .copyWith(color: Colors.white),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white10,
                                    hintText: Strings.selectGender,
                                    hintStyle:
                                        const TextStyle(color: Colors.white70),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: controller.genderOptions
                                      .map((gender) => DropdownMenuItem(
                                            value: gender,
                                            child: Text(gender),
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: DropdownButtonFormField<String>(
                                        value: controller
                                            .selectedCountryCode.value,
                                        onChanged: (value) {
                                          controller.selectedCountryCode.value =
                                              value!;
                                        },
                                        icon: const Icon(Icons.arrow_drop_down,
                                            color: Colors.white),
                                        dropdownColor: Colors.black87,
                                        style: CustomTextTheme.regular14
                                            .copyWith(color: Colors.white),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white10,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 15),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white24),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        items: controller.countryCodes
                                            .map((code) => DropdownMenuItem(
                                                  value: code,
                                                  child: Text(code),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 5,
                                      child: CustomTextField(
                                        controller: controller.phoneController,
                                        hintText: Strings.phoneNumber,
                                        prefixIcon: Icons.phone,
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: controller.passwordController,
                                  hintText: Strings.password,
                                  prefixIcon: Icons.lock,
                                  obscureText: true,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller:
                                      controller.confirmPasswordController,
                                  hintText: Strings.confirmPassword,
                                  prefixIcon: Icons.lock,
                                  obscureText: true,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: controller.agreeToTerms.value,
                                      onChanged: (value) {
                                        controller.agreeToTerms.value =
                                            value ?? false;
                                      },
                                      activeColor: AppColors.primaryColor,
                                    ),
                                    Expanded(
                                      child: Text(
                                        Strings.agreeTerms,
                                        style: CustomTextTheme.regular12
                                            .copyWith(
                                                color: AppColors.whiteColor),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                CustomElevatedButton(
                                  minHeight: 60,
                                  onPressed: () {
                                    if (!controller.agreeToTerms.value) {
                                      Get.snackbar(Strings.alert,
                                          Strings.agreeToTermsMessage,
                                          colorText: AppColors.whiteColor);
                                      return;
                                    }
                                    Get.toNamed(PrimaryRoute.verification);
                                  },
                                  text: Strings.register,
                                ),
                                const SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        Strings.alreadyHaveAccount,
                                        style: CustomTextTheme.regular14
                                            .copyWith(
                                                color: AppColors.whiteColor,
                                                fontWeight: FontWeight.w400),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.toNamed(PrimaryRoute.login);
                                        },
                                        child: Text(Strings.signIn,
                                            style: CustomTextTheme.regular14
                                                .copyWith(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
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
