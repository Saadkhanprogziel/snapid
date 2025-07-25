import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum DocumentType { passport, visa, drivingLicense, manually }
enum Unit { cm,inch}
class PhotoController extends GetxController {
   RxInt currentStep = 1.obs;

var selectedUnit = Unit.cm.obs;
var selectedType = DocumentType.visa.obs;

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
      currentStep.value++;
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
