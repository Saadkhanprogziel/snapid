import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/utlis/country_model.dart';

class RegisterController extends GetxController {
  
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var selectedGender = 'Male'.obs;
  var selectedCountryCode = '+1'.obs;
  var agreeToTerms = false.obs;


  
  var selectedCountry = Rxn<Country>();

  void selectCountry(Country country) {
    selectedCountry.value = country;
    Get.back(); // close bottom sheet
  }


  final List<String> countryCodes = ['+1', '+44', '+91', '+61', '+81'];
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
