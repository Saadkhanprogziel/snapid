import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/controllers/dashboard/dashboard_controller.dart';
import 'package:snapid/keys_urls/local_storage.dart';
import 'package:snapid/models/user/user_model.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/utlis/countries.dart';
import 'package:snapid/utlis/country_model.dart';

class EditProfileController extends GetxController {
  final editProfile = EditProfileModel();
  final AuthRespository authRespository = AuthRespository();
  final DashboardController dashboardController = Get.find<DashboardController>();

  // Text controllers (always initialized to avoid LateInitializationError)
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  // Observables
  RxBool isPasswordObscured = true.obs;
  RxBool isConfrimPasswordObscured = true.obs;
  Rx<Country?> selectedCountryCode = Rx<Country?>(null);
  RxBool isLoading = false.obs;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  UserModel? user;

  @override
  void onInit() {
    super.onInit();

    // Initialize controllers immediately (empty by default)
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();

    // Load user data asynchronously
    loadCurrentUserData();
  }

  Future<void> loadCurrentUserData() async {
    user = await LocalStorage.getUser();

    

    // Populate editProfile safely
    editProfile.firstName = user?.firstName ?? "";
    editProfile.lastName = user?.lastName ?? "";
    editProfile.email = user?.email ?? "";
    editProfile.phone = user?.phoneNo ?? "";

    // Normalize gender casing to match dropdown values
    String rawGender = user?.gender?.toLowerCase() ?? "";
    if (rawGender == "male") {
      editProfile.gender = "Male";
    } else if (rawGender == "female") {
      editProfile.gender = "Female";
    } else if (rawGender == "other") {
      editProfile.gender = "Other";
    } else {
      editProfile.gender = null;
    }

    // Update controllers with loaded data
    firstNameController.text = editProfile.firstName!;
    lastNameController.text = editProfile.lastName!;
    emailController.text = editProfile.email!;
    phoneController.text = editProfile.phone!;

    // Set default country (or from user if available)
    selectedCountryCode.value = allCountries.firstWhere(
      (country) => country.code == 'US',
      orElse: () => allCountries.first,
    );

    update();
  }

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
    update();
  }

  void toggleConfrimPasswordVisibility() {
    isConfrimPasswordObscured.value = !isConfrimPasswordObscured.value;
    update();
  }

  void selectCountryCode(Country country) {
    selectedCountryCode.value = country;
    Get.back(); // Close the bottom sheet
    update();
  }

  Future<void> onSaveProfile() async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await authRespository.updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        gender: editProfile.gender,
      );

      // Close loading dialog
      if (Get.isDialogOpen ?? false) Get.back();

      result.fold(
        (errorMessage) {
          Get.snackbar(
            'Error',
            errorMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (success) {
          dashboardController.refreshUser();
          Get.back(); // navigate back to previous screen
          Get.snackbar(
            'Success',
            'Profile updated successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

class EditProfileModel {
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? phone;
  String? password;
  String? confirmPassword;
}
