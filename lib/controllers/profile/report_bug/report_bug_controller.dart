import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapid/keys_urls/urls.dart';
import 'package:snapid/network/network_repository.dart';
import 'dart:io';

class ReportBugController extends GetxController {
  var isLoading = false.obs;
  final NetworkRepository networkRepository = NetworkRepository();

  var selectedCategory = ''.obs;
  final TextEditingController descriptionController = TextEditingController();

  // Observable for selected image
  var selectedImage = Rx<File?>(null);

  final List<String> categories = [
    'Bug Report',
    'Feature Request',
    'Performance Issue',
    'UI/UX Issue',
    'Account Problem',
    'Payment Issue',
    'Other'
  ];

  /// Pick image from gallery
  Future<void> addPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);

       
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void removePhoto() {
    selectedImage.value = null;
  }

  Future<void> sendReport() async {
    if (selectedCategory.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select a category",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please provide a description",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    isLoading.value = true;

    try {
      final fields = <String, dynamic>{
        'issueCategory': selectedCategory.value,
        'bugDescription': descriptionController.text.trim(),
      };

      final formData = await networkRepository.createFormData(
        fields: fields,
        multipleFiles: {
          'bugImages': selectedImage.value != null ? [selectedImage.value!] : []
        },
      );

      final response = await networkRepository.postMultipart(
        url: "$apiUrl/report/create-bug",
        formData: formData,
      );

      print("success: ${response.success}");
      print("message: ${response.message}");
      print("data: ${response.data}");

      if (response.success == true) {
     
        Get.back(); // Go back to previous screen
        Get.snackbar(
          "Success",
          "Report submitted successfully",
          snackPosition: SnackPosition.BOTTOM,
         
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // ✅ Added proper error handling
      print("Error sending report: $e");
      Get.snackbar(
        "Error",
        "Failed to submit report: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
