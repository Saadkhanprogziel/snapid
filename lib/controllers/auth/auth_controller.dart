import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/models/register/register.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/utlis/country_model.dart';

class AuthController extends GetxController
 {
     final register = RegisterModel();
     AuthRespository authRepository = AuthRespository();
  final isLoading = false.obs;
    var agreeToTerms = false.obs;

  

  var selectedCountry = Rxn<Country>();
  final List<String> countryCodes = ['+1', '+44', '+91', '+61', '+81'];
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  

  void selectCountry(Country country) {
    selectedCountry.value = country;
    Get.back();
  }




  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPasswordObscured = true; // 👈 normal bool
  bool isConfrimPasswordObscured = true; // 👈 normal bool

  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    update(); // 👈 tells GetBuilder to rebuild
  }
  void toggleConfrimPasswordVisibility() {
    isConfrimPasswordObscured = !isConfrimPasswordObscured;
    update(); 
  }

  void onRegister(){
    authRepository.register(user: register);

  }
  
}