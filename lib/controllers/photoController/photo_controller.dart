import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/utlis/country_model.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';

enum DocumentType { passport, visa, drivingLicense, manually }

enum Unit { cm, inch }

class PhotoController extends GetxController {
  RxInt currentStep = 1.obs;
  var selectedUnit = Unit.cm.obs;
  var selectedType = DocumentType.visa.obs;

  var selectedCountry = Rxn<Country>();

  void selectCountry(Country country) {
    selectedCountry.value = country;
    Get.back();
  }

  void changeType(DocumentType type) {
    selectedType.value = type;
  }

  void changeUnit(Unit unit) {
    selectedUnit.value = unit;
  }

  void setStep(int step) {
    currentStep.value = step;
  }

  void goToNextStep() {
    if (currentStep.value < 4) {
      if (currentStep.value == 2 && selectedCountry.value == null) {
        Get.snackbar(
            'Missing Information', 'Please select a country before proceeding.',
            backgroundColor: AppColors.red, colorText: AppColors.whiteColor);
        return;
      }
      currentStep.value++;
    }
  }

  void goToPreviousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  final selectedPhotos = <ImageProvider>[].obs;
  final capturedPhotos =
      <File>[].obs; // Store actual file objects for camera photos
  final ImagePicker _picker = ImagePicker();

  // Loading state for camera operations
  final isCapturingPhotos = false.obs;

  Future<void> pickImage() async {
    if (selectedPhotos.length >= 5) return;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedPhotos.add(FileImage(File(pickedFile.path)));
    }
  }

  void _finishPhotoCapture() {
    if (capturedPhotos.isNotEmpty) {
      // Navigate to photo selection screen
      Get.toNamed(PrimaryRoute.selectedPhoto);

      Get.snackbar(
        'Complete',
        'Successfully captured ${capturedPhotos.length} photos!',
        backgroundColor: AppColors.green ?? Colors.green,
        colorText: AppColors.whiteColor,
      );
    }
  }

  // Alternative simpler approach - capture photos one by one with confirmation
  Future<void> capturePhotosSimple() async {
    try {
      isCapturingPhotos.value = true;
      capturedPhotos.clear();
      selectedPhotos.clear();

      int photoCount = 0;
      bool shouldContinue = true;

      while (photoCount < 5 && shouldContinue) {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          preferredCameraDevice: CameraDevice.front,
        );

        if (pickedFile != null) {
          final file = File(pickedFile.path);
          capturedPhotos.add(file);
          selectedPhotos.add(FileImage(file));
          photoCount++;

          // Show success and ask if user wants to continue
          if (photoCount < 5) {
            shouldContinue = await _showContinueDialog(photoCount);
          }
        } else {
          // User cancelled camera
          if (photoCount > 0) {
            shouldContinue =
                await _showContinueDialog(photoCount, cancelled: true);
          } else {
            break; // Exit if no photos taken
          }
        }
      }

      // Navigate to photo selection if any photos were taken
      if (capturedPhotos.isNotEmpty) {
        Get.toNamed(PrimaryRoute.selectedPhoto);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture photos: $e',
        backgroundColor: AppColors.red,
        colorText: AppColors.whiteColor,
      );
    } finally {
      isCapturingPhotos.value = false;
    }
  }

  Future<bool> _showContinueDialog(int currentCount,
      {bool cancelled = false}) async {
    bool shouldContinue = false;

    await Get.dialog(
      AlertDialog(
        backgroundColor: const Color.fromARGB(255, 51, 49, 49),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                cancelled ? 'Camera Cancelled' : 'Photo Captured',
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ),
            IconButton(
              onPressed: () {
                shouldContinue = false;
                Get.back();
              },
              icon: Icon(
                Icons.close,
                color: AppColors.whiteColor,
                size: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
        titlePadding: EdgeInsets.fromLTRB(24, 20, 16, 0),
        content: Text(
          'You have taken $currentCount photo${currentCount != 1 ? 's' : ''}. ${cancelled ? 'Do you want to try again or' : 'Do you want to'} continue taking more photos?',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        actions: [
          CustomOutlineButton(
              onPressed: () {
                shouldContinue = false;
                Get.back();
              },
              label:
                  'Proceed with $currentCount photo${currentCount != 1 ? 's' : ''}'),
          SpaceH12(),
          CustomElevatedButton(onPressed: (){
            shouldContinue = true;
            Get.back();
          }, text: 'Take More Photos'),
      
        ],
      ),
      barrierDismissible: true, // Allow closing by tapping outside
    );

    return shouldContinue;
  }

  void removePhoto(int index) {
    selectedPhotos.removeAt(index);
    if (index < capturedPhotos.length) {
      capturedPhotos.removeAt(index);
    }
  }

  // Clear all photos
  void clearAllPhotos() {
    selectedPhotos.clear();
    capturedPhotos.clear();
  }
}
