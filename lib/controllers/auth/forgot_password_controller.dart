import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';


class ForgotPasswordController extends GetxController {
 AuthRespository authRepository = AuthRespository();
     TextEditingController emailOrPassController = TextEditingController();




  var email = ''.obs;
  var isLoading = false.obs;

  Future<void> sendResetCode() async {
    if (email.value.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    isLoading.value = true;
    final Either<String, bool> result = await authRepository.forgotPassword(emailOrPassController.text.trim());

    isLoading.value = false;

    result.fold(
      (failure) {
        Get.snackbar('Error', failure, backgroundColor: Colors.red, colorText: Colors.white);
      },
      (success) {
        Get.back();
        Get.snackbar('Success', 'Password reset link sent to your email' 
            ,backgroundColor: Colors.green, colorText: Colors.white );
      },
    );
  }
}
