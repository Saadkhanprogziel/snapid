import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/models/register/register.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/country_model.dart';
import 'package:snapid/utlis/countries.dart'; // Import your countries list

class RegisterController extends GetxController {
  final register = RegisterModel();
  AuthRespository authRepository = AuthRespository();
  var isLoading = false.obs;
  var agreeToTerms = false.obs;

  // Removed selectedCountry since country is now set automatically via country code
  var selectedCountryCode = Rxn<Country>(); // This will set both country code and country
  
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  bool isPasswordObscured = true;
  bool isConfrimPasswordObscured = true;

  @override
  void onInit() {
    super.onInit();
    // Set default country code (you can customize this)
    if (allCountries.isNotEmpty) {
      selectedCountryCode.value = allCountries.first;
      register.countryCode = allCountries.first.dialCode;
      register.country = allCountries.first.name; // Auto-set country
    }
  }

  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    update();
  }

  void toggleConfrimPasswordVisibility() {
    isConfrimPasswordObscured = !isConfrimPasswordObscured;
    update();
  }

  void onRegister() {
    isLoading.value = true;
    authRepository.register(user: register).then(
          (response) => response.fold(
            (error) {
              Get.snackbar("Error", error, colorText: Colors.redAccent);
              isLoading.value = false;
            },
            (success) {
              isLoading.value = false;
              Get.snackbar("Success", "Registration successful", colorText: Colors.white);
              Get.toNamed(
                PrimaryRoute.verification,
                arguments: {
                  "email": register.email,
                  "phone": "${register.countryCode}${register.phone}",
                },
              );
            },
          ),
        );
  }

  // Updated method: selecting country code now automatically sets both country code and country
  void selectCountryCode(Country country) {
    selectedCountryCode.value = country;
    register.countryCode = country.dialCode;
    register.country = country.name; // Automatically set the country name
    Get.back();
  }

  // Removed selectCountry method since it's no longer needed
}