import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/dashboard/dashboard_controller.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/countries/countries.dart';
import 'package:snapid/models/photo_creation/photo_creation_model.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/repositories/countries/countries_repository.dart';
import 'package:snapid/repositories/photo_creation_repository/photo_creation_repository.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:crypto/crypto.dart'; // Add this dependency to pubspec.yaml

enum DocumentType { passport, visa, drivingLicense, manually }

enum Unit { cm, inch }

class PhotoController extends GetxController {
  PhotoCreationRepository photoCreationRepository = PhotoCreationRepository();
  AuthRespository authRespository = AuthRespository();
  TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;

  final CountriesRepository countriesRepository = CountriesRepository();

  RxInt currentStep = 1.obs;
  var selectedUnit = Unit.cm.obs;
  var selectedType = DocumentType.visa.obs;
  var selectedCountry = Rxn<Country>();
  final canDownload = false.obs;
  var countries = <Country>[].obs;

  var selectedPackage = "".obs;

  final isLoading = false.obs;
  final countryLoads = false.obs;
  var photoCreationModelData = Rxn<PhotoCreationModel>();
  var processedWatermarkedUrl = ''.obs;
  var sessionId = ''.obs;

  final isProcessingLoading = false.obs;
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  /// Updated: Use XFile for cross-platform
  final selectedPhotos = <ImageProvider>[].obs;
  final capturedPhotos = <XFile>[].obs;
  var searchQuery = ''.obs;

  // NEW: Set to store image hashes for duplicate detection
  final _imageHashes = <String>{};

  final ImagePicker _picker = ImagePicker();
  final isCapturingPhotos = false.obs;
  var manualSize = "".obs;


  @override
  void onInit() {
    super.onInit();
    // NEW: Handle URL parameters on web
    if (kIsWeb) {
      _handleUrlParameters();
      _loadSavedImages();
    }
    initSearchListener();
  widthController.addListener(_updateManualSize);
  heightController.addListener(_updateManualSize);
}

void _updateManualSize() {
  manualSize.value = "${widthController.text} X ${heightController.text}";
}
  void initSearchListener() {
    searchController.addListener(() {
      _onSearchChanged(searchController.text);
    });
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    // Start new timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (searchQuery.value != query) {
        searchQuery.value = query;
        _performSearch();
      }
    });
  }

  void _performSearch() {
    countries.clear();
    fetchCountries();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _performSearch();
  }

  Future<void> fetchCountries({bool isRefresh = false}) async {
  

    try {
      countryLoads.value = true;
      final result = await countriesRepository.getCountries(
          page: 1, pageSize: 5, searchQuery: searchQuery.value);

      result.fold(
        (error) {
          Get.snackbar("Error", error,
              backgroundColor: Colors.redAccent, colorText: Colors.white);
        },
        (success) {
          countries.value =success.countries;
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch countries",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      countryLoads.value = false;
    }
  }

  /// NEW: Generate hash for image content to detect duplicates
  Future<String> _generateImageHash(XFile imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      print('Error generating image hash: $e');
      // Fallback to file path or name if hashing fails
      return imageFile.path.isNotEmpty ? imageFile.path : imageFile.name;
    }
  }

  /// NEW: Check if image is duplicate
  Future<bool> _isDuplicateImage(XFile imageFile) async {
    final hash = await _generateImageHash(imageFile);
    return _imageHashes.contains(hash);
  }

  /// NEW: Add image hash to tracking set
  Future<void> _addImageHash(XFile imageFile) async {
    final hash = await _generateImageHash(imageFile);
    _imageHashes.add(hash);
  }

  /// NEW: Handle URL parameters and set step accordingly
  void _handleUrlParameters() {
    if (!kIsWeb) return;

    try {
      // Get step parameter from URL
      String? stepParam = Get.parameters['step'];

      if (stepParam != null) {
        int? step = int.tryParse(stepParam);
        if (step != null && step >= 1 && step <= 4) {
          currentStep.value = step;
          print('Set current step to $step from URL parameter');

          // Load session data if we're on step 2 or higher
          if (step > 1) {
            _loadSessionDataFromStorage();
          }
        } else {
          print('⚠️ Invalid step parameter: $stepParam, defaulting to step 1');
          currentStep.value = 1;
        }
      }
    } catch (e) {
      print('❌ Error handling URL parameters: $e');
      currentStep.value = 1;
    }
  }

  void _loadSessionDataFromStorage() {
    try {
      Map<String, dynamic>? sessionData = appStorage.read('photoSession');
      if (sessionData != null) {
        photoCreationModelData.value = PhotoCreationModel.fromJson(sessionData);
        processedWatermarkedUrl.value =
            photoCreationModelData.value?.processedWatermarkedUrl ?? '';
        sessionId.value = photoCreationModelData.value?.id ?? '';

        String? countryCode = appStorage.read('selectedCountryCode');
        if (countryCode != null) {
          print('Loaded country code: $countryCode');
        }

        print('Loaded session data from storage');
      }
    } catch (e) {
      print('❌ Error loading session data: $e');
    }
  }

  void navigateToStep(int step) {
    if (step < 1 || step > 4) return;

    currentStep.value = step;

    if (kIsWeb) {
      Get.toNamed(
        PrimaryRoute.photo_creation,
        parameters: {"step": "$step"},
      );
    } else {
      Get.toNamed(
        PrimaryRoute.photo_creation,
      );
    }
  }

  Future<void> _saveImagesToStorage() async {
    if (!kIsWeb || capturedPhotos.isEmpty) return;

    try {
      List<String> imageDataList = [];

      for (XFile photo in capturedPhotos) {
        Uint8List bytes = await photo.readAsBytes();
        String base64String = base64Encode(bytes);
        imageDataList.add(base64String);
      }

      // Save to appStorage
      await appStorage.write('saved_images', imageDataList);
      await appStorage.write(
          'images_timestamp', DateTime.now().millisecondsSinceEpoch);

      print('Saved ${imageDataList.length} images to localStorage');
    } catch (e) {
      print('Error saving images to localStorage: $e');
      Get.snackbar(
        'Storage Warning',
        'Could not save images locally. They will be lost if you refresh the page.',
        backgroundColor: AppColors.orange,
        colorText: AppColors.whiteColor,
        duration: Duration(seconds: 3),
      );
    }
  }

  Future<void> _loadSavedImages() async {
    if (!kIsWeb) return;

    try {
      List<dynamic>? savedImages = appStorage.read('saved_images');
      int? timestamp = appStorage.read('images_timestamp');

      if (savedImages != null && timestamp != null) {
        // Check if images are less than 1 hour old (optional expiry)
        int hoursSinceStored =
            DateTime.now().millisecondsSinceEpoch - timestamp;
        if (hoursSinceStored > 3600000) {
          // 1 hour in milliseconds
          await _clearStoredImages();
          return;
        }

        selectedPhotos.clear();
        capturedPhotos.clear();
        _imageHashes.clear(); // Clear hash tracking

        for (String base64String in savedImages) {
          Uint8List bytes = base64Decode(base64String);

          // Create XFile from bytes (web-compatible)
          XFile webFile = XFile.fromData(
            bytes,
            name: 'saved_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
            mimeType: 'image/jpeg',
          );

          capturedPhotos.add(webFile);
          selectedPhotos.add(MemoryImage(bytes));

          // Add hash for loaded images
          await _addImageHash(webFile);
        }

        print('Loaded ${savedImages.length} images from localStorage');
      }
    } catch (e) {
      print('❌ Error loading saved images: $e');
      await _clearStoredImages();
    }
  }

  Future<void> _clearStoredImages() async {
    if (!kIsWeb) return;

    await appStorage.remove('saved_images');
    await appStorage.remove('images_timestamp');
    print('🗑️ Cleared stored images from localStorage');
  }

  Future<void> onContinuePressed() async {
    if (selectedPhotos.isEmpty) {
      Get.snackbar("No Photos", "Please select at least one photo.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (selectedPhotos.length < 3) {
      Get.snackbar("Insufficient Photos",
          "Please select at least three photos for better results.",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // Save images to localStorage on web
    if (kIsWeb) {
      await _saveImagesToStorage();
    }

    navigateToStep(2);
  }

  void initializeFromNavigation({bool fromHistory = false}) {
    if (!fromHistory) {
      currentStep.value = 1;
      clearAllPhotos();
      selectedCountry.value = null;
      photoCreationModelData.value = null;
      processedWatermarkedUrl.value = '';
      sessionId.value = '';

      // Clear stored images when starting fresh
      if (kIsWeb) {
        _clearStoredImages();
      }
    }

    // Handle URL parameters even when initializing
    if (kIsWeb) {
      _handleUrlParameters();
    }
  }

  Future<void> getUserDetails() async {
    await authRespository.getUserDetails().then((response) => response.fold(
          (error) {
            Get.snackbar("Error", error);
            update();
          },
          (success) {
            if (success.credits != 0) {
              canDownload.value = true;
              DashboardController dashboardController =
                  Get.find<DashboardController>();
              dashboardController.refreshUser();
            }
          },
        ));
  }

  void selectCountry(Country country) {
    selectedCountry.value = country;

    // Save country selection to storage for web
    if (kIsWeb) {
      appStorage.write('selectedCountryCode', country.code);
      appStorage.write('selectedCountryName', country.name);
    }

    Get.back();
  }

  void changeType(DocumentType type) {
    selectedType.value = type;

    // Save document type to storage for web
    if (kIsWeb) {
      appStorage.write('selectedDocumentType', type.toString());
    }
  }

  void changeUnit(Unit unit) {
    selectedUnit.value = unit;
  }

  void setStep(int step) {
    currentStep.value = step;

    // Update URL on web
    if (kIsWeb) {
      navigateToStep(step);
    }
  }

  Future<void> goToNextStep() async {
    final token = appStorage.read("token")?.toString() ?? "";

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

        if (token.isNotEmpty) {
          bool success = await createSession();
          if (!success) return;
        } else {
          final guestId = appStorage.read("guest_id");
          print(guestId);
          if (guestId == null) {
            await authRespository.createGuestUser().then((response) {
              response.fold((error) {
                Get.snackbar(
                  'Error',
                  'Could not create guest user: $error',
                  backgroundColor: AppColors.red,
                  colorText: AppColors.whiteColor,
                );
                return;
              }, (success) {});
            });
          }

          bool success = await createSession();
          if (!success) return;
        }
        print(
            "Reviewing photos... ${photoCreationModelData.value?.processedWatermarkedUrl}");

        navigateToStep(3);
        return;
      }

      if (currentStep.value == 3) {
        if (photoCreationModelData.value?.canDownloadImage == true) {
          await downloadImageById(photoCreationModelData.value!.id);
          return; // stop here
        } else {
          navigateToStep(4);
          return;
        }
      }

      navigateToStep(currentStep.value + 1);
    }
  }

  void goToPreviousStep() {
    if (currentStep.value > 1) {
      navigateToStep(currentStep.value - 1);
    }
  }

  Future<void> downloadImageById(String id) async {
    isLoading.value = true;

    await photoCreationRepository.downloadImage(id: id).then((response) {
      final token = appStorage.read("token");

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
        appStorage.write("processed_img", photoCreationModel.processedImageUrl);
        _storeSessionData(photoCreationModel);

        if (token != null) {
          getUserDetails();
        }
        Get.toNamed(PrimaryRoute.photo_preview);
      });
    });
  }

  Future<void> pickImages({bool allowMultiple = false}) async {
    if (selectedPhotos.length >= 5) return;

    if (allowMultiple) {
      // Pick multiple images
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        int duplicatesSkipped = 0;

        for (final file in pickedFiles) {
          if (capturedPhotos.length >= 5) break; // cap at 5

          // Check for duplicate before adding
          if (await _isDuplicateImage(file)) {
            duplicatesSkipped++;
            continue;
          }

          capturedPhotos.add(file);
          await _addImageHash(file); // Track the hash

          if (kIsWeb) {
            Uint8List bytes = await file.readAsBytes();
            selectedPhotos.add(MemoryImage(bytes));
          } else {
            selectedPhotos.add(Image.file(File(file.path)).image);
          }
        }

        // Show message if duplicates were found
        if (duplicatesSkipped > 0) {
          Get.snackbar(
            'Duplicate Images Skipped',
            '$duplicatesSkipped duplicate image${duplicatesSkipped > 1 ? 's were' : ' was'} skipped.',
            backgroundColor: AppColors.orange,
            colorText: AppColors.whiteColor,
            duration: Duration(seconds: 3),
          );
        }
      }
    } else {
      // Pick a single image
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Check for duplicate before adding
        if (await _isDuplicateImage(pickedFile)) {
          Get.snackbar(
            'Duplicate Image',
            'This image has already been selected.',
            backgroundColor: AppColors.orange,
            colorText: AppColors.whiteColor,
            duration: Duration(seconds: 2),
          );
          return;
        }

        capturedPhotos.add(pickedFile);
        await _addImageHash(pickedFile); // Track the hash

        if (kIsWeb) {
          Uint8List bytes = await pickedFile.readAsBytes();
          selectedPhotos.add(MemoryImage(bytes));
        } else {
          selectedPhotos.add(Image.file(File(pickedFile.path)).image);
        }
      }
    }
  }

  Future<void> capturePhotosSimple() async {
    try {
      isCapturingPhotos.value = true;
      capturedPhotos.clear();
      selectedPhotos.clear();
      _imageHashes.clear(); // Clear hash tracking when starting fresh

      int photoCount = 0;
      bool shouldContinue = true;

      while (photoCount < 5 && shouldContinue) {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
        );

        if (pickedFile != null) {
          // Check for duplicate (though unlikely with camera captures)
          if (await _isDuplicateImage(pickedFile)) {
            Get.snackbar(
              'Duplicate Photo',
              'This photo appears to be identical to a previous one. Please take a different photo.',
              backgroundColor: AppColors.orange,
              colorText: AppColors.whiteColor,
              duration: Duration(seconds: 3),
            );
            continue; // Don't increment photoCount, try again
          }

          capturedPhotos.add(pickedFile);
          await _addImageHash(pickedFile); // Track the hash

          if (kIsWeb) {
            Uint8List bytes = await pickedFile.readAsBytes();
            selectedPhotos.add(MemoryImage(bytes));
          } else {
            selectedPhotos.add(Image.file(
              File(pickedFile.path),
            ).image);
          }

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
      isProcessingLoading.value = true;
      isLoading.value = false;

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
        platform: 'WEB_APP',
        customHeight: double.tryParse(heightController.text) ?? 0.0,
        customWidth: double.tryParse(widthController.text) ?? 0.0,
      );

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
          photoCreationModelData.value = photoCreationModel;
          processedWatermarkedUrl.value =
              photoCreationModel.processedWatermarkedUrl;
          _storeSessionData(photoCreationModel);

          if (kIsWeb) {
            _clearStoredImages();
          }

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
      isProcessingLoading.value = false;
      isLoading.value = false;
    }
  }

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
    if (index < capturedPhotos.length) {
      // Remove hash tracking when photo is removed
      _removeImageHash(capturedPhotos[index]);
      capturedPhotos.removeAt(index);
    }

    selectedPhotos.removeAt(index);
  }

  /// NEW: Remove image hash when photo is deleted
  Future<void> _removeImageHash(XFile imageFile) async {
    try {
      final hash = await _generateImageHash(imageFile);
      _imageHashes.remove(hash);
    } catch (e) {
      print('Error removing image hash: $e');
    }
  }

  void clearAllPhotos() {
    selectedPhotos.clear();
    capturedPhotos.clear();
    _imageHashes.clear(); // Clear hash tracking
  }
}
