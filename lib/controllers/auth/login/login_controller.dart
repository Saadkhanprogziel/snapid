import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/controllers/biometric/biometric._controller.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/routes/routes.dart';

class LoginController extends GetxController {
  final AuthRespository authRepository = AuthRespository();
  var isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordObscured = true;

  @override
  void onInit() {
    super.onInit();
    // Use onReady instead of onInit for better timing
  }

  @override
  void onReady() {
    super.onReady();
    _handleBiometricFromSplash();
  }

  void _handleBiometricFromSplash() async {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final shouldShowBiometric = arguments?['biometric'] == true;
    
    if (shouldShowBiometric) {
      // Longer delay to ensure BiometricController is fully initialized
      await Future.delayed(const Duration(milliseconds: 1500));
      await _attemptAutoBiometricLogin();
    }
  }

  Future<void> _attemptAutoBiometricLogin() async {
    try {
      // Check if BiometricController is registered first
      if (!Get.isRegistered<BiometricController>()) {
        print('BiometricController not registered yet');
        return;
      }

      final biometricController = Get.find<BiometricController>();
      
      // Wait for biometric availability to be checked
      int attempts = 0;
      while (!biometricController.isBiometricAvailable.value && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }
      

      if (!biometricController.isBiometricAvailable.value) {
        Get.snackbar(
          'Not Available',
          'Biometric authentication is not available on this device.',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
        );
        return;
      }

      final isAuthenticated = await biometricController.authenticateUser();

      if (isAuthenticated) {
        // Handle biometric login success
        await onBiometricLogin();
      } else {
        // Get.snackbar(
        //   'Authentication Failed',
        //   'Biometric authentication was cancelled. Please use email/password.',
        //   snackPosition: SnackPosition.TOP,
        //   colorText: Colors.white,
        // );
      }
    } catch (e) {
      print('Biometric auto-login error: $e');
      Get.snackbar(
        'Error',
        'Biometric authentication error: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
      );
    }
  }

  void _showBiometricDisabledDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Biometric Authentication'),
        content: const Text(
          'Biometric authentication is disabled. Would you like to enable it in settings or continue with email/password?'
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
            },
            child: const Text('Use Email/Password'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.toNamed('/biometric-settings');
            },
            child: const Text('Enable Biometric'),
          ),
        ],
      ),
    );
  }

  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    update();
  }

  // Regular email/password login
  void onLogin() {
    final emailOrPhone = emailController.text.trim();
    final password = passwordController.text.trim();

    isLoading = true;
    update();
    
    authRepository
        .login(
          emailOrPhone: emailOrPhone,
          password: password,
        )
        .then((response) => response.fold((error) {
          print(error);
          isLoading = false;
          Get.snackbar("Error", error,
              backgroundColor: Colors.red, colorText: Colors.white);
          update();
        }, (success) {
          isLoading = false;
          update();
          Get.snackbar("Success", "Login successful",
              colorText: Colors.white);

          Get.offAllNamed(PrimaryRoute.home, arguments: {'index': 0});
        }));
  }

  // Biometric login - skips credential validation
  Future<void> onBiometricLogin() async {
    isLoading = true;
    update();

    try {
      // For biometric login, we fetch user details directly since they're already authenticated
      await authRepository.getUserDetails().then((response) => response.fold(
        (error) {
          isLoading = false;
          Get.snackbar("Error", error,
              backgroundColor: Colors.red, colorText: Colors.white);
          update();
        },
        (success) {
          isLoading = false;
          update();
          Get.snackbar("Success", "login successful",
              colorText: Colors.white);

          Get.offAllNamed(PrimaryRoute.home, arguments: {'index': 0});
        },
      ));
    } catch (e) {
      isLoading = false;
      Get.snackbar("Error", "Biometric login failed: ${e.toString()}",
          backgroundColor: Colors.red, colorText: Colors.white);
      update();
    }
  }

  // Manual biometric authentication triggered by button
  Future<void> onBiometricButtonPressed() async {
    try {
      final biometricController = Get.find<BiometricController>();
      
      final isEnabled = await biometricController.isBiometricEnabled();

      if (!isEnabled) {
        Get.snackbar(
          'Biometric Disabled',
          'Please enable biometric authentication in settings first.',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
        );
        Get.toNamed('/biometric-settings');
        return;
      }

      if (!biometricController.isBiometricAvailable.value) {
        Get.snackbar(
          'Not Available',
          'Biometric authentication is not available on this device.',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
        );
        return;
      }

      final isAuthenticated = await biometricController.authenticateUser();

      if (isAuthenticated) {
        await onBiometricLogin();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Biometric authentication failed: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}