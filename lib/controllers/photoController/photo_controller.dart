import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/utlis/country_model.dart';

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
  
      Get.snackbar('Missing Information', 'Please select a country before proceeding.',backgroundColor: AppColors.red,colorText: AppColors.whiteColor);
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
  final ImagePicker _picker = ImagePicker();


  Future<void> pickImage() async {
    if (selectedPhotos.length >= 5) return;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedPhotos.add(FileImage(File(pickedFile.path)));
    }
  }

  void removePhoto(int index) {
    selectedPhotos.removeAt(index);
  }
}
