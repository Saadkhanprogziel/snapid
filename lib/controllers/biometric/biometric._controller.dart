import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:flutter/services.dart';

import 'package:snapid/main.dart';

class BiometricController extends GetxController {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  
  // Observable variables
  var faceId = false.obs;
  var isLoading = false.obs;
  var biometricType = 'None'.obs;
  var isBiometricAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeBiometric();
  }

  Future<void> _initializeBiometric() async {
    await _checkBiometricAvailability();
    await _loadBiometricSetting();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final bool isAvailable = await _localAuthentication.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuthentication.isDeviceSupported();
      isBiometricAvailable.value = isAvailable && isDeviceSupported;

      if (isBiometricAvailable.value) {
        final biometrics = await _localAuthentication.getAvailableBiometrics();
        print("Biometrics available: $biometrics");

        if (biometrics.contains(BiometricType.face)) {
          biometricType.value = 'Face ID';
        } else if (biometrics.contains(BiometricType.fingerprint)) {
          biometricType.value = 'Fingerprint';
        } else if (biometrics.contains(BiometricType.iris)) {
          biometricType.value = 'Iris';
        } else if (biometrics.contains(BiometricType.strong)) {
          biometricType.value = GetPlatform.isAndroid
              ? 'Fingerprint / Face'
              : 'Face ID / Touch ID';
        } else if (biometrics.contains(BiometricType.weak)) {
          biometricType.value = 'Weak Biometric';
        } else {
          biometricType.value = 'Biometric';
        }
      }
    } catch (e) {
      print('Error checking biometric availability: $e');
      isBiometricAvailable.value = false;
    }
  }

  Future<void> _loadBiometricSetting() async {
    try {
      faceId.value = appStorage.read('biometric_enabled') ?? false;
    } catch (e) {
      print('Error loading biometric setting: $e');
    }
  }

  Future<void> setBiometric(bool value) async {
    if (value && isBiometricAvailable.value) {
      // Test authentication before enabling
      final isAuthenticated = await authenticateUser();

      if (isAuthenticated) {
        await _saveBiometricSetting(true);
        faceId.value = true;
        Get.snackbar(
          'Success',
          '${biometricType.value} authentication enabled successfully!',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        print('Please enroll and try again with ${biometricType.value}.');
        Get.snackbar(
          'Authentication Failed',
          'Please enroll and try again with ${biometricType.value}.',
          snackPosition: SnackPosition.TOP,
        );
      }
    } else if (!value) {
      await _saveBiometricSetting(false);
      faceId.value = false;
      Get.snackbar(
        'Disabled',
        '${biometricType.value} authentication has been disabled.',
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        'Not Available',
        'Biometric authentication is not available on this device.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> _saveBiometricSetting(bool value) async {
    try {
      appStorage.write('biometric_enabled', value);
    } catch (e) {
      print('Error saving biometric setting: $e');
    }
  }

  Future<bool> authenticateUser() async {
    if (!isBiometricAvailable.value) {
      return false;
    }

    try {
      final enrolled = await _localAuthentication.canCheckBiometrics;
      if (!enrolled) {
        Get.snackbar(
          'Not Enrolled',
          'Please set up ${biometricType.value} in device settings first.',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }

      isLoading.value = true;
      final bool isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate with your ${biometricType.value}',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric Authentication',
            cancelButton: 'Cancel',
            goToSettingsButton: 'Go to Settings',
            goToSettingsDescription:
                'Please set up biometrics in your device settings',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true, 
          stickyAuth: true,
        ),
      );
      print("Authentication result: $isAuthenticated");
      return isAuthenticated;
    } on PlatformException catch (e) {
      print('Authentication error: code=${e.code}, message=${e.message}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> isBiometricEnabled() async {
    try {
      return appStorage.read('biometric_enabled') ?? false;
    } catch (e) {
      return false;
    }
  }
}
