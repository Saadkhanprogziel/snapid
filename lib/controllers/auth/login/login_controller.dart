import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/routes/routes.dart'; // ✅ fixed spelling

class LoginController extends GetxController {
  final AuthRespository authRepository = AuthRespository();
  var isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordObscured = true; // ✅ make it reactive

  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    update(); // tells GetBuilder to rebuild
  }

  void onLogin() {
    final emailOrPhone = emailController.text.trim();
    final password = passwordController.text.trim();

    if (emailOrPhone.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter email/phone and password");
      return;
    }

    isLoading = true;
    update();
    authRepository
        .login(
          emailOrPhone: emailOrPhone,
          password: password,
        )
        .then((response) => response.fold((error) {
              isLoading = false;
              Get.snackbar("Error", error);
              update();
            }, (success) {
              isLoading = false;
              update();
              Get.snackbar("Success", "Login successful",
                  backgroundColor: Colors.green, colorText: Colors.white);

              Get.offAllNamed(PrimaryRoute.home, arguments: {'index': 0});
            }));
  }
}
