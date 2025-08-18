import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/controllers/auth/auth_controller.dart';
import 'package:snapid/controllers/auth/register/register_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(RegisterController());

    final authController = Get.put(AuthController());

    return GetBuilder(
        init: authController,
        builder: (controller) {
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
                          style: CustomTextTheme.headingLarge.copyWith(
                              fontSize: 28, color: AppColors.whiteColor),
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
                                child: Obx(() => Column(
                                      children: [
                                        CustomTextField(
                                          onChanged: (value) {
                                            controller.register.value
                                                .firstName = value;
                                          },
                                          hintText: Strings.firstName,
                                          prefixIcon: Icons.person,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'First name is required';
                                            }
                                            if (value.length < 2) {
                                              return 'First name must be at least 2 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          onChanged: (value) {
                                            controller.register.value.lastName =
                                                value;
                                          },
                                          hintText: Strings.lastName,
                                          prefixIcon: Icons.person,
                                          // validator: (value) {
                                          //   if (value == null || value.isEmpty) {
                                          //     return 'Last name is required';
                                          //   }
                                          //   if (value.length < 2) {
                                          //     return 'Last name must be at least 2 characters';
                                          //   }
                                          //   return null;
                                          // },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          onChanged: (value) {
                                            controller.register.value.email =
                                                value;
                                          },
                                          hintText: Strings.email,
                                          prefixIcon: Icons.email,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Email is required';
                                            }
                                            if (!RegExp(
                                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                .hasMatch(value)) {
                                              return 'Please enter a valid email';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        DropdownButtonFormField<String>(
                                          value:
                                              controller.register.value.gender,
                                          onChanged: (value) {
                                            controller.register.value.gender =
                                                value!;
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select your gender';
                                            }
                                            return null;
                                          },
                                          icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.white),
                                          dropdownColor: const Color.fromARGB(
                                              216, 39, 43, 52),
                                          style: CustomTextTheme.regular14
                                              .copyWith(color: Colors.white),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white10,
                                            hintText: Strings.selectGender,
                                            hintStyle: const TextStyle(
                                                color: Colors.white70),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 15),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 80,
                                              child: DropdownButtonFormField<
                                                  String>(
                                                value: controller
                                                    .register.value.countryCode,
                                                onChanged: (value) {
                                                  controller.register.value
                                                      .countryCode = value!;
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Required';
                                                  }
                                                  return null;
                                                },
                                                icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.white),
                                                dropdownColor: Colors.black87,
                                                style: CustomTextTheme.regular14
                                                    .copyWith(
                                                        color: Colors.white),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white10,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 15),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white24),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppColors
                                                                .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                items: controller.countryCodes
                                                    .map((code) =>
                                                        DropdownMenuItem(
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
                                                onChanged: (value) {
                                                  controller.register.value
                                                      .phone = value;
                                                },
                                                hintText: Strings.phoneNumber,
                                                prefixIcon: Icons.phone,
                                                
                                                keyboardType:
                                                    TextInputType.phone,
                                                validator: (value) => value ==
                                                            null ||
                                                        value.isEmpty
                                                    ? 'Phone number is required'
                                                    : (value.length < 10
                                                        ? 'Phone number must be at least 10 digits'
                                                        : ''),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          onChanged: (value) {
                                            controller.register.value.password =
                                                value;
                                          },
                                          hintText: Strings.password,
                                          prefixIcon: Icons.lock,
                                          suffixIcon:
                                              controller.isPasswordObscured
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                          obscureText:
                                              controller.isPasswordObscured,
                                          onSuffixIconPressed: () {
                                            controller
                                                .togglePasswordVisibility();
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          onChanged: (value) {
                                            controller.register.value
                                                .confirmPassword = value;
                                          },
                                          hintText: Strings.confirmPassword,
                                          prefixIcon: Icons.lock,
                                          obscureText: controller
                                              .isConfrimPasswordObscured,
                                          suffixIcon: controller
                                                  .isConfrimPasswordObscured
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          onSuffixIconPressed: () {
                                            controller
                                                .toggleConfrimPasswordVisibility();
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please confirm your password';
                                            }
                                            if (value !=
                                                controller
                                                    .register.value.password) {
                                              return 'Passwords do not match';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Obx(() => Checkbox(
                                                  value: controller
                                                      .agreeToTerms.value,
                                                  onChanged: (value) {
                                                    controller.agreeToTerms
                                                        .value = value ?? false;
                                                  },
                                                  activeColor:
                                                      AppColors.primaryColor,
                                                )),
                                            Expanded(
                                              child: Text(
                                                Strings.agreeTerms,
                                                style: CustomTextTheme.regular12
                                                    .copyWith(
                                                        color: AppColors
                                                            .whiteColor),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        CustomElevatedButton(
                                          minHeight: 60,
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {}
                                          },
                                          text: Strings.register,
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Strings.alreadyHaveAccount,
                                                style: CustomTextTheme.regular14
                                                    .copyWith(
                                                        color: AppColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.toNamed(
                                                      PrimaryRoute.login);
                                                },
                                                child: Text(Strings.signIn,
                                                    style: CustomTextTheme
                                                        .regular14
                                                        .copyWith(
                                                            color: AppColors
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
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
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
