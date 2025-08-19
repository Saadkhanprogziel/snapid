import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/controllers/auth/auth_controller.dart';
import 'package:snapid/controllers/auth/register/register_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/countries.dart';
import 'package:snapid/utlis/country_model.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
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
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      onChanged: (value) {
                                        controller.register.firstName = value;
                                        controller.update();
                                      },
                                      hintText: Strings.firstName,
                                      prefixIcon: Icons.person,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
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
                                        controller.register.lastName = value;
                                        controller.update();
                                      },
                                      hintText: Strings.lastName,
                                      prefixIcon: Icons.person,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      onChanged: (value) {
                                        controller.register.email = value;
                                        controller.update();
                                      },
                                      hintText: Strings.email,
                                      prefixIcon: Icons.email,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
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
                                      value: controller.register.gender,
                                      onChanged: (value) {
                                        controller.register.gender = value!;
                                        controller.update();
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select your gender';
                                        }
                                        return null;
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
                                        hintStyle: const TextStyle(
                                            color: Colors.white70),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 15),
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
                                    Obx(() {
                                      final country =
                                          controller.selectedCountry.value;
                                      return OutlinedButton(
                                        onPressed: () =>
                                            _showCountryPicker(controller),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: AppColors.cardColor,
                                          side: BorderSide(
                                              width: 0,
                                              color: Colors.grey.shade800),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                        ),
                                        child: Row(
                                          children: [
                                            if (country != null)
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    country.flag,
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    country.name,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )
                                            else
                                              Text(
                                                "Select Country",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            Spacer(),
                                            Icon(Icons.arrow_drop_down,
                                                color: Colors.white),
                                          ],
                                        ),
                                      );
                                    }),
                                    const SizedBox(height: 16),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child:
                                              DropdownButtonFormField<String>(
                                            value:
                                                controller.register.countryCode,
                                            onChanged: (value) {
                                              controller.register.countryCode =
                                                  value!;
                                              controller.update();
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
                                                .copyWith(color: Colors.white),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white10,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 15),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white24),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color:
                                                        AppColors.primaryColor),
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
                                            onChanged: (value) {
                                              controller.register.phone = value;
                                            },
                                            hintText: Strings.phoneNumber,
                                            prefixIcon: Icons.phone,
                                            keyboardType: TextInputType.phone,
                                            validator: (value) => value ==
                                                        null ||
                                                    value.isEmpty
                                                ? 'Phone number is required'
                                                : (value.length < 10
                                                    ? 'Phone number must be at least 10 digits'
                                                    : null),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      onChanged: (value) {
                                        controller.register.password = value;
                                        controller.update();
                                      },
                                      hintText: Strings.password,
                                      prefixIcon: Icons.lock,
                                      suffixIcon: controller.isPasswordObscured
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      obscureText:
                                          controller.isPasswordObscured,
                                      onSuffixIconPressed: () {
                                        controller.togglePasswordVisibility();
                                      },
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
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      onChanged: (value) {
                                        controller.register.confirmPassword =
                                            value;
                                        controller.update();
                                      },
                                      hintText: Strings.confirmPassword,
                                      prefixIcon: Icons.lock,
                                      obscureText:
                                          controller.isConfrimPasswordObscured,
                                      suffixIcon:
                                          controller.isConfrimPasswordObscured
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                      onSuffixIconPressed: () {
                                        controller
                                            .toggleConfrimPasswordVisibility();
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please confirm your password';
                                        }
                                        if (value !=
                                            controller.register.password) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Obx(() => Checkbox(
                                              value:
                                                  controller.agreeToTerms.value,
                                              onChanged: (value) {
                                                controller.agreeToTerms.value =
                                                    value ?? false;
                                              },
                                              activeColor:
                                                  AppColors.primaryColor,
                                            )),
                                        Expanded(
                                          child: Text(
                                            Strings.agreeTerms,
                                            style: CustomTextTheme.regular12
                                                .copyWith(
                                                    color:
                                                        AppColors.whiteColor),
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
                                            controller.onRegister();
                                      },
                                      text: Strings.register,
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            Strings.alreadyHaveAccount,
                                            style: CustomTextTheme.regular14
                                                .copyWith(
                                                    color: AppColors.whiteColor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Get.toNamed(PrimaryRoute.login);
                                            },
                                            child: Text(Strings.signIn,
                                                style: CustomTextTheme.regular14
                                                    .copyWith(
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w400)),
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
        });
  }

  void _showCountryPicker(AuthController controller) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 41, 42, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        TextEditingController searchController = TextEditingController();
        RxList<Country> filteredCountries = allCountries.obs;

        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  cursorColor: AppColors.whiteColor,
                  style: TextStyle(color: AppColors.whiteColor),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: AppColors.whiteColor),
                    labelText: 'Search country',
                    labelStyle: TextStyle(color: AppColors.whiteColor),
                    hintStyle: CustomTextTheme.regular14
                        .copyWith(color: AppColors.whiteColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    filteredCountries.value = allCountries
                        .where((c) =>
                            c.name.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                    controller.update();
                  },
                ),
                SizedBox(height: 16),
                Obx(() => SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: filteredCountries.length,
                        itemBuilder: (_, index) {
                          final country = filteredCountries[index];
                          return ListTile(
                              leading: SvgPicture.asset(
                                country.flag,
                                width: 24,
                                height: 24,
                              ),
                              title: Text(
                                country.name,
                                style: CustomTextTheme.regular14.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              onTap: () {
                                controller.selectCountry(country);
                                controller.update();
                              });
                        },
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
