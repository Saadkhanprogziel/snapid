import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
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
    return GetBuilder<RegisterController>(
      init: RegisterController(),
      builder: (controller) {
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

              LayoutBuilder(
                builder: (context, constraints) {
                  bool isWideScreen = constraints.maxWidth > 800; // breakpoint

                  if (isWideScreen) {
                    // ✅ Web/Desktop Layout
                    return Row(
                      children: [
                        // Left section: image + text
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(

                                    children: [
                                      Text('Let`s Get You Started', style: CustomTextTheme.bold26),
                                      const SizedBox(height: 16),
                                      Text(
                                          'Your Photos Are Safe With Us',
                                          style: CustomTextTheme.regular18),
                                    ],
                                  ),
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
                                          Assets.sign_up,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Right section: Registration Form
                        Expanded(
                          flex: 1,
                          child: _buildRegisterForm(context, controller,isWideScreen),
                        ),
                      ],
                    );
                  } else {
                    // ✅ Mobile Layout
                    return Column(
                      children: [
                        const Spacer(flex: 1),
                        Column(
                          children: [
                            Text(
                              Strings.letGetStarted,
                              style: CustomTextTheme.headingLarge.copyWith(
                                fontSize: 28,
                                color: AppColors.whiteColor,
                              ),
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
                          child: _buildRegisterForm(context, controller,isWideScreen),
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

  Widget _buildRegisterForm(
      BuildContext context, RegisterController controller,bool isWideScreen) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: isWideScreen ? 600 :500, // keeps it clean on wide screens
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            decoration: BoxDecoration(
              color: isWideScreen ? Colors.transparent: Color.fromARGB(20, 223, 222, 222),
              borderRadius: BorderRadius.circular(25),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// First name
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

                    /// Last name
                    CustomTextField(
                      onChanged: (value) {
                        controller.register.lastName = value;
                        controller.update();
                      },
                      hintText: Strings.lastName,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 16),

                    /// Email
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
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    /// Gender
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      dropdownColor: const Color.fromARGB(216, 39, 43, 52),
                      style: CustomTextTheme.regular14
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        hintText: Strings.selectGender,
                        hintStyle: const TextStyle(color: Colors.white70),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 22),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: controller.genderOptions
                          .map(
                            (gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    /// Phone number with country code
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: FormField<Country?>(
                            validator: (value) {
                              if (controller.selectedCountryCode.value ==
                                  null) {
                                return 'Required';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            builder: (formFieldState) {
                              final countryCode =
                                  controller.selectedCountryCode.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 65,
                                    child: OutlinedButton(
                                      onPressed: () =>
                                          _showCountryCodePicker(controller),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white10,
                                        side: BorderSide(
                                          color: formFieldState.hasError
                                              ? Colors.red
                                              : Colors.transparent,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 8,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (countryCode != null) ...[
                                            SvgPicture.asset(
                                              countryCode.flag,
                                              width: 16,
                                              height: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              countryCode.dialCode,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ] else
                                            const Text(
                                              "+00",
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (formFieldState.hasError)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, top: 6),
                                      child: Text(
                                        formFieldState.errorText!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
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
                            validator: (value) => value == null || value.isEmpty
                                ? 'Phone number is required'
                                : (value.length < 10
                                    ? 'Phone number must be at least 10 digits'
                                    : null),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Password
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
                      obscureText: controller.isPasswordObscured,
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
                        if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')
                            .hasMatch(value)) {
                          return 'Must contain uppercase, lowercase and number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    /// Confirm Password
                    CustomTextField(
                      onChanged: (value) {
                        controller.register.confirmPassword = value;
                        controller.update();
                      },
                      hintText: Strings.confirmPassword,
                      prefixIcon: Icons.lock,
                      obscureText: controller.isConfrimPasswordObscured,
                      suffixIcon: controller.isConfrimPasswordObscured
                          ? Icons.visibility
                          : Icons.visibility_off,
                      onSuffixIconPressed: () {
                        controller.toggleConfrimPasswordVisibility();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != controller.register.password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    /// Terms Checkbox
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.agreeToTerms.value,
                            onChanged: (value) {
                              controller.agreeToTerms.value = value ?? false;
                            },
                            activeColor: AppColors.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Strings.agreeTerms,
                            style: CustomTextTheme.regular12.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    /// Register Button
                    Obx(() {
                      return controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : CustomElevatedButton(
                              minHeight: 60,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  controller.onRegister();
                                }
                              },
                              text: Strings.register,
                            );
                    }),

                    const SizedBox(height: 10),

                    /// Already have account
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Strings.alreadyHaveAccount,
                            style: CustomTextTheme.regular14.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(PrimaryRoute.login);
                            },
                            child: Text(
                              Strings.signIn,
                              style: CustomTextTheme.regular14.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w400,
                              ),
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
    );
  }

  // ✅ Country code picker
  void _showCountryCodePicker(RegisterController controller) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 41, 42, 50),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        TextEditingController searchController = TextEditingController();
        RxList<Country> filteredCountries = allCountries.obs;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Country',
                  style: CustomTextTheme.regular16.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: searchController,
                  cursorColor: AppColors.whiteColor,
                  style: TextStyle(color: AppColors.whiteColor),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: AppColors.whiteColor),
                    labelText: 'Search country or dial code',
                    labelStyle: TextStyle(color: AppColors.whiteColor),
                    hintStyle: CustomTextTheme.regular14
                        .copyWith(color: AppColors.whiteColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    filteredCountries.value = allCountries
                        .where((c) =>
                            c.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            c.dialCode.contains(value))
                        .toList();
                    controller.update();
                  },
                ),
                const SizedBox(height: 16),
                Obx(
                  () => SizedBox(
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
                            '${country.name} (${country.dialCode})',
                            style: CustomTextTheme.regular14.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                          onTap: () {
                            controller.selectCountryCode(country);
                            controller.update();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
