import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/photo_creation/photo_creation_model.dart';
import 'package:snapid/repositories/photo_creation_repository/photo_creation_repository.dart';
import 'package:snapid/utlis/country_model.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';

enum DocumentType { passport, visa, drivingLicense, manually }

enum Unit { cm, inch }

class PhotoController extends GetxController {
  PhotoCreationRepository photoCreationRepository = PhotoCreationRepository();
  RxInt currentStep = 1.obs;
  var selectedUnit = Unit.cm.obs;
  var selectedType = DocumentType.visa.obs;
  var selectedCountry = Rxn<Country>();

  final isLoading = false.obs;
  var photoCreationModelData = Rxn<PhotoCreationModel>();
  var processedWatermarkedUrl = ''.obs;
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController= TextEditingController();


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

  Future<void> goToNextStep() async {
    if (currentStep.value < 4) {
      if (currentStep.value == 2 && selectedCountry.value == null) {
        Get.snackbar(
          'Missing Information',
          'Please select a country before proceeding.',
          backgroundColor: AppColors.red,
          colorText: AppColors.whiteColor,
        );
        return;
      }

      if (currentStep.value == 2 && selectedCountry.value != null) {
        // ✅ Validate that photos exist before proceeding
        if (capturedPhotos.isEmpty) {
          Get.snackbar(
            'Missing Photos',
            'Please capture some photos before proceeding.',
            backgroundColor: AppColors.red,
            colorText: AppColors.whiteColor,
          );
          return;
        }
        print("Creating photo session...");
        bool success = await createSession();
        if (!success) return; // stop if error
        print(
            "Reviewing photos... ${photoCreationModelData.value?.processedWatermarkedUrl}");


        currentStep.value++;
        return;
      }

      if (currentStep.value == 3) {
        if (photoCreationModelData.value?.canDownloadImage == true) {

          isLoading.value = true;
          await photoCreationRepository
              .downloadImage(
            id: photoCreationModelData.value!.id,
          )
              .then((response) {
            response.fold((error) {
              Get.snackbar(
                'Error',
                error,
                backgroundColor: AppColors.red,
                colorText: AppColors.whiteColor,
              );
              isLoading.value = false;
            }, (photoCreationModel) {
              isLoading.value = false;
              photoCreationModelData.value = photoCreationModel;
              _storeSessionData(photoCreationModel);
              Get.toNamed(PrimaryRoute.photo_preview);
             
            });
          });
          return; // ⛔ do not increment
        } else {
          // ✅ if image not downloadable, allow moving forward
          currentStep.value++;
          return;
        }
      }

      // ✅ default increment for other steps
      currentStep.value++;
    }
  }

  void goToPreviousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  final selectedPhotos = <ImageProvider>[].obs;
  final capturedPhotos = <File>[].obs;
  final ImagePicker _picker = ImagePicker();
  final isCapturingPhotos = false.obs;

  Future<void> pickImage() async {
    if (selectedPhotos.length >= 5) return;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      selectedPhotos.add(FileImage(file));
      capturedPhotos.add(file); // ✅ Also add to capturedPhotos for consistency
    }
  }

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

          if (photoCount < 5) {
            shouldContinue = await _showContinueDialog(photoCount);
          }
        } else {
          if (photoCount > 0) {
            shouldContinue =
                await _showContinueDialog(photoCount, cancelled: true);
          } else {
            break;
          }
        }
      }

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

  Future<bool> createSession() async {
    try {
      isLoading.value = true;

      // ✅ Validate inputs before making the request
      if (capturedPhotos.isEmpty) {
        Get.snackbar(
          'Error',
          'No photos to upload',
          backgroundColor: AppColors.red,
          colorText: AppColors.whiteColor,
        );
        return false;
      }

      if (selectedCountry.value?.code == null ||
          selectedCountry.value!.code.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select a valid country',
          backgroundColor: AppColors.red,
          colorText: AppColors.whiteColor,
        );
        return false;
      }
        
      final response = await photoCreationRepository.createPhotoSession(
        countryCode: selectedCountry.value!.code,
        documentType: _mapDocumentType(selectedType.value),
        userSessionPhotos: capturedPhotos,
        platform: 'MOBILE_APP',
        customHeight: double.tryParse(heightController.text) ?? 0.0,
        customWidth: double.tryParse(widthController.text) ?? 0.0,);        
        

      return response.fold(
        (error) {
          Get.snackbar(
            'Upload Failed',
            error,
            backgroundColor: AppColors.red,
            colorText: AppColors.whiteColor,
            duration: Duration(seconds: 4),
          );
          return false;
        },
        (photoCreationModel) {
          print("Photo session created: ${photoCreationModel.id}");
          Get.snackbar(
            'Success',
            'Photos uploaded successfully!',
            backgroundColor: AppColors.green,
            colorText: AppColors.whiteColor,
            duration: Duration(seconds: 3),
          );
          photoCreationModelData.value = photoCreationModel;
          processedWatermarkedUrl.value =
              photoCreationModel.processedWatermarkedUrl;
          _storeSessionData(photoCreationModel);
          return true;
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unexpected error occurred: ${e.toString()}',
        backgroundColor: AppColors.red,
        colorText: AppColors.whiteColor,
        duration: Duration(seconds: 4),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Helper to format types correctly
  String _mapDocumentType(DocumentType type) {
    switch (type) {
      case DocumentType.passport:
        return "PASSPORT";
      case DocumentType.visa:
        return "VISA";
      case DocumentType.drivingLicense:
        return "DRIVING_LICENSE";
      case DocumentType.manually:
        return "MANUAL_INPUT";
    }
  }

  void _storeSessionData(PhotoCreationModel model) {
    // Save as JSON string
    appStorage.write('photoSession', model.toJson());
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
                'Proceed with $currentCount photo${currentCount != 1 ? 's' : ''}',
          ),
          SpaceH12(),
          CustomElevatedButton(
            onPressed: () {
              shouldContinue = true;
              Get.back();
            },
            text: 'Take More Photos',
          ),
        ],
      ),
      barrierDismissible: true,
    );

    return shouldContinue;
  }

  void removePhoto(int index) {
    selectedPhotos.removeAt(index);
    if (index < capturedPhotos.length) {
      capturedPhotos.removeAt(index);
    }
  }

  void clearAllPhotos() {
    selectedPhotos.clear();
    capturedPhotos.clear();
  }
}
