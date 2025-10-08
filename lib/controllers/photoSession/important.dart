// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:snapid/constant/colors.dart';
// import 'package:snapid/controllers/dashboard/dashboard_controller.dart';
// import 'package:snapid/controllers/photoSession/camera_widget.dart';
// import 'package:snapid/main.dart';
// import 'package:snapid/models/countries/countries.dart';
// import 'package:snapid/models/photo_creation/photo_creation_model.dart';
// import 'package:snapid/repositories/auth/auth_respository.dart';
// import 'package:snapid/repositories/countries/countries_repository.dart';
// import 'package:snapid/repositories/photo_creation_repository/photo_creation_repository.dart';
// import 'package:snapid/routes/routes.dart';
// import 'package:snapid/utlis/custom_elevated_button.dart';
// import 'package:snapid/utlis/custom_outline_button.dart';
// import 'package:snapid/utlis/custom_spaces.dart';
// import 'package:crypto/crypto.dart';

// enum DocumentType { passport, visa, drivingLicense, manually }

// enum Unit { cm, inch }

// class PhotoController extends GetxController {
//   final PhotoCreationRepository photoCreationRepository =
//       PhotoCreationRepository();
//   final AuthRespository authRespository = AuthRespository();
//   final CountriesRepository countriesRepository = CountriesRepository();
//   final ImagePicker _picker = ImagePicker();

//   final TextEditingController searchController = TextEditingController();
//   final TextEditingController widthController = TextEditingController();
//   final TextEditingController heightController = TextEditingController();

//   Timer? _debounceTimer;

//   // Reactive variables
//   final RxInt currentStep = 1.obs;
//   final Rx<Unit> selectedUnit = Unit.cm.obs;
//   final Rx<DocumentType> selectedType = DocumentType.visa.obs;
//   final Rxn<Country> selectedCountry = Rxn<Country>();
//   final RxBool canDownload = false.obs;
//   final RxList<Country> countries = <Country>[].obs;
//   final RxString selectedPackage = "".obs;
//   final RxBool isLoading = false.obs;
//   final RxBool isUserLoading = false.obs;
//   final RxBool countryLoads = false.obs;
//   final Rxn<PhotoCreationModel> photoCreationModelData =
//       Rxn<PhotoCreationModel>();
//   final RxString processedWatermarkedUrl = ''.obs;
//   final RxString sessionId = ''.obs;
//   final RxBool isProcessingLoading = false.obs;
//   final RxList<ImageProvider> selectedPhotos = <ImageProvider>[].obs;
//   final RxList<XFile> capturedPhotos = <XFile>[].obs;
//   final RxString searchQuery = ''.obs;
//   final RxBool isCapturingPhotos = false.obs;
//   final RxString manualSize = "".obs;

//   // Image hash tracking for duplicate detection
//   final Set<String> _imageHashes = <String>{};
//   final token = appStorage.read("token");

//   @override
//   void onInit() {
//     super.onInit();

//     if (kIsWeb) {
//       if (token != null) {
//         getUserDetails();
//       }
//       _handleUrlParameters();
//       _loadSavedImages();
//     }

//     initSearchListener();
//     widthController.addListener(_updateManualSize);
//     heightController.addListener(_updateManualSize);
//   }

//   @override
//   void dispose() {
//     _debounceTimer?.cancel();
//     // searchController.dispose();
//     widthController.dispose();
//     heightController.dispose();
//     super.dispose();
//   }

//   void _updateManualSize() {
//     final width = widthController.text.trim();
//     final height = heightController.text.trim();

//     if (width.isNotEmpty && height.isNotEmpty) {
//       manualSize.value = "$width X $height";
//     } else {
//       manualSize.value = "";
//     }
//   }

//   void initSearchListener() {
//     searchController.addListener(() {
//       _onSearchChanged(searchController.text);
//     });
//   }

//   void _onSearchChanged(String query) {
//     _debounceTimer?.cancel();

//     _debounceTimer = Timer(const Duration(milliseconds: 500), () {
//       if (searchQuery.value != query) {
//         searchQuery.value = query;
//         _performSearch();
//       }
//     });
//   }

//   void _performSearch() {
//     countries.clear();
//     fetchCountries();
//   }

//   void clearSearch() {
//     searchController.clear();
//     searchQuery.value = '';
//     _performSearch();
//   }

//   Future<void> fetchCountries({bool isRefresh = false}) async {
//     try {
//       countryLoads.value = true;

//       final result = await countriesRepository.getCountries(
//           page: 1, pageSize: 20, searchQuery: searchQuery.value);

//       result.fold(
//         (error) {
//           Get.snackbar("Error", error,
//               backgroundColor: Colors.redAccent, colorText: Colors.white);
//         },
//         (success) {
//           countries.value = success.countries;
//         },
//       );
//     } catch (e) {
//       Get.snackbar("Error", "Failed to fetch countries: ${e.toString()}",
//           backgroundColor: Colors.redAccent, colorText: Colors.white);
//     } finally {
//       countryLoads.value = false;
//     }
//   }

//   /// Generate hash for image content to detect duplicates
//   Future<String> _generateImageHash(XFile imageFile) async {
//     try {
//       final bytes = await imageFile.readAsBytes();
//       final digest = sha256.convert(bytes);
//       return digest.toString();
//     } catch (e) {
//       debugPrint('Error generating image hash: $e');
//       // Fallback to timestamp-based identifier
//       return '${imageFile.name}_${DateTime.now().millisecondsSinceEpoch}';
//     }
//   }

//   /// Check if image is duplicate
//   Future<bool> _isDuplicateImage(XFile imageFile) async {
//     final hash = await _generateImageHash(imageFile);
//     return _imageHashes.contains(hash);
//   }

//   /// Add image hash to tracking set
//   Future<void> _addImageHash(XFile imageFile) async {
//     final hash = await _generateImageHash(imageFile);
//     _imageHashes.add(hash);
//   }

//   /// Remove image hash when photo is deleted
//   Future<void> _removeImageHash(XFile imageFile) async {
//     try {
//       final hash = await _generateImageHash(imageFile);
//       _imageHashes.remove(hash);
//     } catch (e) {
//       debugPrint('Error removing image hash: $e');
//     }
//   }

//   /// Handle URL parameters and set step accordingly
//   void _handleUrlParameters() {
//     if (!kIsWeb) return;

//     try {
//       String? stepParam = Get.parameters['step'];

//       if (stepParam != null) {
//         int? step = int.tryParse(stepParam);
//         if (step != null && step >= 1 && step <= 4) {
//           currentStep.value = step;
//           debugPrint('Set current step to $step from URL parameter');

//           if (step > 1) {
//             _loadSessionDataFromStorage();
//           }
//         } else {
//           debugPrint(
//               '⚠️ Invalid step parameter: $stepParam, defaulting to step 1');
//           currentStep.value = 1;
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ Error handling URL parameters: $e');
//       currentStep.value = 1;
//     }
//   }

//   void _loadSessionDataFromStorage() {
//     if (!kIsWeb) return;

//     try {
//       Map<String, dynamic>? sessionData = appStorage.read('photoSession');

//       if (sessionData != null) {
//         photoCreationModelData.value = PhotoCreationModel.fromJson(sessionData);
//         processedWatermarkedUrl.value =
//             photoCreationModelData.value?.processedWatermarkedUrl ?? '';
//         sessionId.value = photoCreationModelData.value?.id ?? '';

//         String? countryCode = appStorage.read('selectedCountryCode');
//         if (countryCode != null) {
//           debugPrint('Loaded country code: $countryCode');
//         }

//         debugPrint('✅ Loaded session data from storage');
//       }
//     } catch (e) {
//       debugPrint('❌ Error loading session data: $e');
//     }
//   }

//   void navigateToStep(int step) {
//     if (step < 1 || step > 4) return;

//     currentStep.value = step;

//     if (kIsWeb) {
//       Get.toNamed(
//         PrimaryRoute.photo_creation,
//         parameters: {"step": "$step"},
//       );
//     } else {
//       Get.toNamed(PrimaryRoute.photo_creation);
//     }
//   }

//   Future<void> _saveImagesToStorage() async {
//     if (!kIsWeb || capturedPhotos.isEmpty) return;

//     try {
//       List<String> imageDataList = [];

//       for (XFile photo in capturedPhotos) {
//         Uint8List bytes = await photo.readAsBytes();
//         String base64String = base64Encode(bytes);
//         imageDataList.add(base64String);
//       }

//       await appStorage.write('saved_images', imageDataList);
//       await appStorage.write(
//           'images_timestamp', DateTime.now().millisecondsSinceEpoch);

//       debugPrint('✅ Saved ${imageDataList.length} images to localStorage');
//     } catch (e) {
//       debugPrint('❌ Error saving images to localStorage: $e');

//       Get.snackbar(
//         'Storage Warning',
//         'Could not save images locally. They will be lost if you refresh the page.',
//         backgroundColor: AppColors.orange,
//         colorText: AppColors.whiteColor,
//         duration: const Duration(seconds: 3),
//       );
//     }
//   }

//   Future<void> _loadSavedImages() async {
//     if (!kIsWeb) return;

//     try {
//       List<dynamic>? savedImages = appStorage.read('saved_images');
//       int? timestamp = appStorage.read('images_timestamp');

//       if (savedImages != null && timestamp != null) {
//         // Check if images are less than 1 hour old
//         int timeDiff = DateTime.now().millisecondsSinceEpoch - timestamp;

//         if (timeDiff > 3600000) {
//           await _clearStoredImages();
//           return;
//         }

//         selectedPhotos.clear();
//         capturedPhotos.clear();
//         _imageHashes.clear();

//         for (var item in savedImages) {
//           if (item is! String) continue;

//           try {
//             Uint8List bytes = base64Decode(item);

//             XFile webFile = XFile.fromData(
//               bytes,
//               name: 'saved_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
//               mimeType: 'image/jpeg',
//             );

//             capturedPhotos.add(webFile);
//             selectedPhotos.add(MemoryImage(bytes));
//             await _addImageHash(webFile);
//           } catch (e) {
//             debugPrint('Error loading individual image: $e');
//             continue;
//           }
//         }

//         debugPrint(
//             '✅ Loaded ${capturedPhotos.length} images from localStorage');
//       }
//     } catch (e) {
//       debugPrint('❌ Error loading saved images: $e');
//       await _clearStoredImages();
//     }
//   }

//   Future<void> _clearStoredImages() async {
//     if (!kIsWeb) return;

//     try {
//       await appStorage.remove('saved_images');
//       await appStorage.remove('images_timestamp');
//       debugPrint('🗑️ Cleared stored images from localStorage');
//     } catch (e) {
//       debugPrint('Error clearing stored images: $e');
//     }
//   }

//   Future<void> onContinuePressed() async {
//     if (selectedPhotos.isEmpty) {
//       Get.snackbar("No Photos", "Please select at least one photo.",
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return;
//     }

//     if (selectedPhotos.length < 3) {
//       Get.snackbar("Insufficient Photos",
//           "Please select at least three photos for better results.",
//           backgroundColor: Colors.orange, colorText: Colors.white);
//       return;
//     }

//     if (kIsWeb) {
//       await _saveImagesToStorage();
//     }

//     navigateToStep(2);
//   }

//   void initializeFromNavigation({bool fromHistory = false}) {
//     if (!fromHistory) {
//       currentStep.value = 1;
//       clearAllPhotos();
//       selectedCountry.value = null;
//       photoCreationModelData.value = null;
//       processedWatermarkedUrl.value = '';
//       sessionId.value = '';

//       if (kIsWeb) {
//         _clearStoredImages();
//       }
//     }

//     if (kIsWeb) {
//       _handleUrlParameters();
//     }
//   }

//   Future<void> getUserDetails() async {
//     try {
//       isUserLoading.value = true;
//       final response = await authRespository.getUserDetails();

//       response.fold(
//         (error) {
//           Get.snackbar("Error", error);
//           isUserLoading.value = false;
//         },
//         (success) {
//           if (success.credits != 0) {
//             canDownload.value = true;
//             isUserLoading.value = false;

//             try {
//               final dashboardController = Get.find<DashboardController>();
//               dashboardController.refreshUser();
//             } catch (e) {
//               debugPrint('DashboardController not found: $e');
//             }
//           }
//         },
//       );
//     } catch (e) {
//       debugPrint('Error getting user details: $e');
//     } finally {
//       isUserLoading.value = false;
//     }
//   }

//   void selectCountry(Country country) {
//     selectedCountry.value = country;

//     if (kIsWeb) {
//       appStorage.write('selectedCountryCode', country.code);
//       appStorage.write('selectedCountryName', country.name);
//     }

//     Get.back();
//   }

//   void changeType(DocumentType type) {
//     selectedType.value = type;

//     if (kIsWeb) {
//       appStorage.write('selectedDocumentType', type.toString());
//     }
//   }

//   void changeUnit(Unit unit) {
//     selectedUnit.value = unit;
//   }

//   void setStep(int step) {
//     if (step < 1 || step > 4) return;

//     currentStep.value = step;

//     if (kIsWeb) {
//       navigateToStep(step);
//     }
//   }

//   Future<void> goToNextStep() async {
//     final token = appStorage.read("token")?.toString() ?? "";

//     if (currentStep.value >= 4) return;

//     // Step 2 validation
//     if (currentStep.value == 2) {
//       if (selectedCountry.value == null) {
//         Get.snackbar(
//           'Missing Information',
//           'Please select a country before proceeding.',
//           backgroundColor: AppColors.red,
//           colorText: AppColors.whiteColor,
//         );
//         return;
//       }

//       if (capturedPhotos.isEmpty) {
//         Get.snackbar(
//           'Missing Photos',
//           'Please capture some photos before proceeding.',
//           backgroundColor: AppColors.red,
//           colorText: AppColors.whiteColor,
//         );
//         return;
//       }

//       debugPrint("Creating photo session...");

//       if (token.isNotEmpty) {
//         bool success = await createSession();
//         if (!success) return;
//       } else {
//         final guestId = appStorage.read("guest_id");

//         if (guestId == null) {
//           final guestResponse = await authRespository.createGuestUser();

//           bool guestCreated = false;
//           guestResponse.fold((error) {
//             Get.snackbar(
//               'Error',
//               'Could not create guest user: $error',
//               backgroundColor: AppColors.red,
//               colorText: AppColors.whiteColor,
//             );
//           }, (success) {
//             guestCreated = true;
//           });

//           if (!guestCreated) return;
//         }

//         bool success = await createSession();
//         if (!success) return;
//       }

//       navigateToStep(3);
//       return;
//     }

//     // Step 3 handling
//     if (currentStep.value == 3) {
//       if (photoCreationModelData.value?.canDownloadImage == true) {
//         final id = photoCreationModelData.value?.id;
//         if (id != null && id.isNotEmpty) {
//           await downloadImageById(id);
//         }
//         return;
//       } else {
//         navigateToStep(4);
//         return;
//       }
//     }

//     navigateToStep(currentStep.value + 1);
//   }

//   void goToPreviousStep() {
//     if (currentStep.value > 1) {
//       navigateToStep(currentStep.value - 1);
//     }
//   }

//   Future<void> downloadImageById(String id) async {
//     if (id.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Invalid image ID',
//         backgroundColor: AppColors.red,
//         colorText: AppColors.whiteColor,
//       );
//       return;
//     }

//     try {
//       isLoading.value = true;

//       final response = await photoCreationRepository.downloadImage(id: id);
//       final token = appStorage.read("token");

//       response.fold((error) {
//         Get.snackbar(
//           'Error',
//           error,
//           backgroundColor: AppColors.red,
//           colorText: AppColors.whiteColor,
//         );
//       }, (photoCreationModel) {
//         photoCreationModelData.value = photoCreationModel;
//         appStorage.write("processed_img", photoCreationModel);
//         _storeSessionData(photoCreationModel);

//         if (token != null) {
//           getUserDetails();
//         }

//         Get.toNamed(PrimaryRoute.photo_preview);
//       });
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to download image: ${e.toString()}',
//         backgroundColor: AppColors.red,
//         colorText: AppColors.whiteColor,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> pickImages({bool allowMultiple = false}) async {
//     if (selectedPhotos.length >= 5) {
//       Get.snackbar(
//         'Limit Reached',
//         'You can only select up to 5 photos.',
//         backgroundColor: AppColors.orange,
//         colorText: AppColors.whiteColor,
//       );
//       return;
//     }

//     try {
//       if (allowMultiple) {
//         final List<XFile>? pickedFiles = await _picker.pickMultiImage();

//         if (pickedFiles != null && pickedFiles.isNotEmpty) {
//           int duplicatesSkipped = 0;
//           int limitReached = 0;

//           for (final file in pickedFiles) {
//             if (capturedPhotos.length >= 5) {
//               limitReached = pickedFiles.length - capturedPhotos.length;
//               break;
//             }

//             if (await _isDuplicateImage(file)) {
//               duplicatesSkipped++;
//               continue;
//             }

//             capturedPhotos.add(file);
//             await _addImageHash(file);

//             if (kIsWeb) {
//               Uint8List bytes = await file.readAsBytes();
//               selectedPhotos.add(MemoryImage(bytes));
//             } else {
//               selectedPhotos.add(FileImage(File(file.path)));
//             }
//           }

//           if (duplicatesSkipped > 0) {
//             Get.snackbar(
//               'Duplicate Images Skipped',
//               '$duplicatesSkipped duplicate image${duplicatesSkipped > 1 ? 's were' : ' was'} skipped.',
//               backgroundColor: AppColors.orange,
//               colorText: AppColors.whiteColor,
//               duration: const Duration(seconds: 3),
//             );
//           }

//           if (limitReached > 0) {
//             Get.snackbar(
//               'Photo Limit Reached',
//               '$limitReached photo${limitReached > 1 ? 's were' : ' was'} not added (limit: 5 photos).',
//               backgroundColor: AppColors.orange,
//               colorText: AppColors.whiteColor,
//               duration: const Duration(seconds: 3),
//             );
//           }
//         }
//       } else {
//         final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//         if (pickedFile != null) {
//           if (await _isDuplicateImage(pickedFile)) {
//             Get.snackbar(
//               'Duplicate Image',
//               'This image has already been selected.',
//               backgroundColor: AppColors.orange,
//               colorText: AppColors.whiteColor,
//               duration: const Duration(seconds: 2),
//             );
//             return;
//           }

//           capturedPhotos.add(pickedFile);
//           await _addImageHash(pickedFile);

//           if (kIsWeb) {
//             Uint8List bytes = await pickedFile.readAsBytes();
//             selectedPhotos.add(MemoryImage(bytes));
//           } else {
//             selectedPhotos.add(FileImage(File(pickedFile.path)));
//           }
//         }
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick images: ${e.toString()}',
//         backgroundColor: AppColors.red,
//         colorText: AppColors.whiteColor,
//       );
//     }
//   }

//   Future<void> capturePhotosSimple() async {
//     selectedPhotos.clear();
//     capturedPhotos.clear();
//     _imageHashes.clear();
//     try {
//       isCapturingPhotos.value = true;

//       await Get.to(
//         () => CameraWidget(
//           photos: capturedPhotos,
//           maxPhotos: 5,
//           onPhotoTaken: (XFile photo) async {
//             if (await _isDuplicateImage(photo)) {
//               Get.snackbar(
//                 'Duplicate Photo',
//                 'This photo appears identical to a previous one.',
//                 backgroundColor: AppColors.orange,
//                 colorText: AppColors.whiteColor,
//               );
//               return;
              
//             }

//             capturedPhotos.add(photo);

//             // Add hash (was missing!)
//             await _addImageHash(photo);

//             if (kIsWeb) {
//               Uint8List bytes = await photo.readAsBytes();
//               selectedPhotos.add(MemoryImage(bytes));
//             } else {
//               selectedPhotos.add(FileImage(File(photo.path)));
//             }

//             if (capturedPhotos.length >= 5) {
//               // Get.back();
//               // Save images before navigating
//               if (kIsWeb) {
//                 await _saveImagesToStorage();
//               }
//               Get.toNamed(PrimaryRoute.selectedPhoto);
//             }
//           },
//         ),
//       );

//       // After camera closes, save and navigate if we have photos
//       if (capturedPhotos.isNotEmpty) {
//         if (kIsWeb) {
//           await _saveImagesToStorage();
//         }
//         Get.toNamed(PrimaryRoute.selectedPhoto);
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to open camera: ${e.toString()}',
//         backgroundColor: AppColors.red,
//         colorText: AppColors.whiteColor,
//       );
//     } finally {
//       isCapturingPhotos.value = false;
//     }
//   }

//   Future<bool> createSession() async {
//     try {
//       isProcessingLoading.value = true;

//       if (capturedPhotos.isEmpty) {
//         Get.snackbar(
//           'Error',
//           'No photos to upload',
//           backgroundColor: AppColors.red,
//           colorText: AppColors.whiteColor,
//         );
//         return false;
//       }

//       if (selectedCountry.value == null ||
//           selectedCountry.value!.code.isEmpty) {
//         Get.snackbar(
//           'Error',
//           'Please select a valid country',
//           backgroundColor: AppColors.red,
//           colorText: AppColors.whiteColor,
//         );
//         return false;
//       }

//       final response = await photoCreationRepository.createPhotoSession(
//         countryCode: selectedCountry.value!.code,
//         documentType: _mapDocumentType(selectedType.value),
//         userSessionPhotos: capturedPhotos,
//         platform: 'WEB_APP',
//         customHeight: double.tryParse(heightController.text) ?? 0.0,
//         customWidth: double.tryParse(widthController.text) ?? 0.0,
//       );
//       print("manzar check this ${capturedPhotos[1].path}");

//       return response.fold(
//         (error) {
//           print("object");
//           Get.snackbar(
//             'Upload Failed',
//             error,
//             backgroundColor: AppColors.red,
//             colorText: AppColors.whiteColor,
//             duration: const Duration(seconds: 4),
//           );
//           return false;
//         },
//         (photoCreationModel) {
//           photoCreationModelData.value = photoCreationModel;
//           processedWatermarkedUrl.value =
//               photoCreationModel.processedWatermarkedUrl;
//           _storeSessionData(photoCreationModel);

//           if (kIsWeb) {
//             _clearStoredImages();
//           }

//           return true;
//         },
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Unexpected error occurred: ${e.toString()}',
//         backgroundColor: AppColors.red,
//         colorText: AppColors.whiteColor,
//         duration: const Duration(seconds: 4),
//       );
//       return false;
//     } finally {
//       isProcessingLoading.value = false;
//     }
//   }

//   String _mapDocumentType(DocumentType type) {
//     switch (type) {
//       case DocumentType.passport:
//         return "PASSPORT";
//       case DocumentType.visa:
//         return "VISA";
//       case DocumentType.drivingLicense:
//         return "DRIVING_LICENSE";
//       case DocumentType.manually:
//         return "MANUAL_INPUT";
//     }
//   }

//   void _storeSessionData(PhotoCreationModel model) {
//     if (kIsWeb) {
//       try {
//         appStorage.write('photoSession', model.toJson());
//       } catch (e) {
//         debugPrint('Error storing session data: $e');
//       }
//     }
//   }

//   Future<bool> _showContinueDialog(int currentCount,
//       {bool cancelled = false}) async {
//     bool shouldContinue = false;

//     await Get.dialog(
//       AlertDialog(
//         backgroundColor: const Color.fromARGB(255, 51, 49, 49),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 cancelled ? 'Camera Cancelled' : 'Photo Captured',
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//             IconButton(
//               onPressed: () {
//                 shouldContinue = false;
//                 Get.back();
//               },
//               icon: const Icon(
//                 Icons.close,
//                 color: Colors.white,
//                 size: 24,
//               ),
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//             ),
//           ],
//         ),
//         titlePadding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
//         content: Text(
//           'You have taken $currentCount photo${currentCount != 1 ? 's' : ''}. '
//           '${cancelled ? 'Do you want to try again or' : 'Do you want to'} '
//           'continue taking more photos?',
//           style: const TextStyle(color: Colors.white),
//         ),
//         actions: [
//           CustomOutlineButton(
//             onPressed: () {
//               shouldContinue = false;
//               Get.back();
//             },
//             label:
//                 'Proceed with $currentCount photo${currentCount != 1 ? 's' : ''}',
//           ),
//           const SpaceH12(),
//           CustomElevatedButton(
//             onPressed: () {
//               shouldContinue = true;
//               Get.back();
//             },
//             text: 'Take More Photos',
//           ),
//         ],
//       ),
//       barrierDismissible: true,
//     );

//     return shouldContinue;
//   }

//   void removePhoto(int index) {
//     if (index < 0 || index >= selectedPhotos.length) return;

//     if (index < capturedPhotos.length) {
//       _removeImageHash(capturedPhotos[index]);
//       capturedPhotos.removeAt(index);
//     }

//     selectedPhotos.removeAt(index);
//   }

//   void clearAllPhotos() {
//     selectedPhotos.clear();
//     capturedPhotos.clear();
//     _imageHashes.clear();
//   }
// }
