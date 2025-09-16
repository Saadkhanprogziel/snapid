import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/controllers/biometric/biometric._controller.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/routes/routes.dart';

class LoginController extends GetxController {
  final AuthRespository authRepository = AuthRespository();
  var isLoading = false;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  var isPasswordObscured = true.obs;
  bool _isDisposed = false; // Flag to track disposal state

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers here
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
    if (!_isDisposed) {
      _handleBiometricFromSplash();
    }
  }

  void _handleBiometricFromSplash() async {
    if (_isDisposed) return;
    
    final arguments = Get.arguments as Map<String, dynamic>?;
    final shouldShowBiometric = arguments?['biometric'] == true;
    
    if (shouldShowBiometric) {
      // Longer delay to ensure BiometricController is fully initialized
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!_isDisposed) {
        await _attemptAutoBiometricLogin();
      }
    }
  }

  Future<void> _attemptAutoBiometricLogin() async {
    if (_isDisposed) return;
    
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
        if (_isDisposed) return;
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }
      
      if (_isDisposed) return;

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

      if (_isDisposed) return;

      if (isAuthenticated) {
        // Handle biometric login success
        await onBiometricLogin();
      }
    } catch (e) {
      if (!_isDisposed) {
        print('Biometric auto-login error: $e');
        Get.snackbar(
          'Error',
          'Biometric authentication error: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
        );
      }
    }
  }

  void togglePasswordVisibility() {
    if (_isDisposed) return;
    isPasswordObscured.value = !isPasswordObscured.value;
    update();
  }

  // Regular email/password login
  void onLogin() {
    if (_isDisposed) return;
    
    final emailOrPhone = emailController.text.trim();
    final password = passwordController.text.trim();

    isLoading = true;
    update();
    
    authRepository
        .login(
          emailOrPhone: emailOrPhone,
          password: password,
        )
        .then((response) {
          if (_isDisposed) return;
          
          response.fold((error) {
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
          });
        });
  }

  // Biometric login - skips credential validation
  Future<void> onBiometricLogin() async {
    if (_isDisposed) return;
    
    isLoading = true;
    update();

    try {
      // For biometric login, we fetch user details directly since they're already authenticated
      await authRepository.getUserDetails().then((response) {
        if (_isDisposed) return;
        
        response.fold(
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
        );
      });
    } catch (e) {
      if (!_isDisposed) {
        isLoading = false;
        Get.snackbar("Error", "Biometric login failed: ${e.toString()}",
            backgroundColor: Colors.red, colorText: Colors.white);
        update();
      }
    }
  }

  // Manual biometric authentication triggered by button
  Future<void> onBiometricButtonPressed() async {
    if (_isDisposed) return;
    
    try {
      final biometricController = Get.find<BiometricController>();
      
      final isEnabled = await biometricController.isBiometricEnabled();

      if (_isDisposed) return;

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

      if (_isDisposed) return;

      if (isAuthenticated) {
        await onBiometricLogin();
      }
    } catch (e) {
      if (!_isDisposed) {
        Get.snackbar(
          'Error',
          'Biometric authentication failed: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void onClose() {
    _isDisposed = true; // Set flag before disposing
    
    // Check if controllers are not null and haven't been disposed yet
    if (emailController.hasListeners == false) {
      emailController.dispose();
    }
    if (passwordController.hasListeners == false) {
      passwordController.dispose();
    }
    
    super.onClose();
  }
}