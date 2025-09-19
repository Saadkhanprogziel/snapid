import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();

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
  Rx<File?> selectedProfileImage = Rx<File?>(null);
  RxString profileImageUrl = ''.obs;

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
    
    // Set profile image URL if available
    profileImageUrl.value = user?.profilePicture ?? '';

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

  /// Image picker methods
  Future<void> showImageSourceActionSheet() async {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 41, 42, 50),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Select Profile Picture',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.white),
                title: const Text('Camera', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Get.back();
                  pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text('Gallery', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Get.back();
                  pickImageFromGallery();
                },
              ),
             
             
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        selectedProfileImage.value = File(image.path);
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image from camera',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        selectedProfileImage.value = File(image.path);
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image from gallery',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeProfileImage() {
    selectedProfileImage.value = null;
    // Don't clear profileImageUrl here if you want to remove from server
    // or set a flag to indicate removal
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
      isLoading.value = true;
      
      // Show loading dialog
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        barrierDismissible: false,
      );

      final result = await authRespository.updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        gender: editProfile.gender,
        profileImage: selectedProfileImage.value,
      );

      // Close loading dialog
      if (Get.isDialogOpen ?? false) Get.back();
      isLoading.value = false;

      result.fold(
        (errorMessage) {
          Get.snackbar(
            'Error',
            errorMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        },
        (success) {
          // Clear selected image after successful upload
          selectedProfileImage.value = null;
          
          // Refresh dashboard user data
          dashboardController.refreshUser();
          
          Get.back(); // navigate back to previous screen
          Get.snackbar(
            'Success',
            'Profile updated successfully!',
            
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        },
      );
    } catch (e) {
      isLoading.value = false;
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
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