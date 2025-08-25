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
  AuthRespository authRespository = AuthRespository();
  DashboardController dashboardController = Get.find<DashboardController>();  

  // Text controllers
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  RxBool isPasswordObscured = true.obs;
  RxBool isConfrimPasswordObscured = true.obs;
  Rx<Country?> selectedCountryCode = Rx<Country?>(null);
  RxBool isLoading = false.obs;


  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  UserModel? user;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUserData();
  }

  Future<void> loadCurrentUserData() async {
    // Get user from local storage
    user = await LocalStorage.getUser();

    // Debug
    print("Loaded user: ${user?.firstName}, gender: ${user?.gender}");

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
      editProfile.gender = null; // fallback if gender not set or doesn't match
    }

    // Init controllers
    firstNameController = TextEditingController(text: editProfile.firstName);
    lastNameController = TextEditingController(text: editProfile.lastName);
    emailController = TextEditingController(text: editProfile.email);
    phoneController = TextEditingController(text: editProfile.phone);

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

 void onSaveProfile() async {
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
      gender: editProfile.gender, // if you are storing gender
    );

    // Close loading dialog
    if (Get.isDialogOpen ?? false) Get.back();

    result.fold(
      (errorMessage) {
        // Left = error
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (success) {
        // Right = success
        dashboardController.refreshUser(); // Refresh user data in dashboard
        Get.back(); // navigate back to previous screen
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Get.back(); // navigate back to previous screen
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
