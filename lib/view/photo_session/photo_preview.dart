import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/keys_urls/local_storage.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/photo_creation/photo_creation_model.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/screenBg.dart';
import 'package:snapid/view/photo_session/cached_image.dart';
import 'package:snapid/utlis/image_utlis/download_helper.dart';
import 'package:snapid/view/photo_session/steps/selected_details_widget.dart';

class PhotoPreview extends StatefulWidget {
  const PhotoPreview({super.key});

  @override
  State<PhotoPreview> createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final PhotoController controller = Get.find<PhotoController>();
    var processedIMG = appStorage.read("photoSession");
    var imageData = PhotoCreationModel.fromJson(processedIMG);

    final token = appStorage.read("token");

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        Get.toNamed(PrimaryRoute.home);
      },
      child: Scaffold(
        body: Stack(
          children: [
            buildBackground(),
            LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;

                if (width >= 800) {
                  // Desktop layout
                  return Stack(
                    children: [
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            color: AppColors.cardColor,
                          ),
                          child:
                              _buildMainContent(controller, width, imageData),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 70,
                        child: GestureDetector(
                          onTap: () {
                            if (token == null || token == "") {
                              Get.offAllNamed(PrimaryRoute.login);
                            } else {
                              Get.offAllNamed(PrimaryRoute.home);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.whiteColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Mobile layout
                  // Mobile layout
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SpaceH20(),
                          Center(
                            child: Container(
                              // width: 400,
                              height: 280, // slightly taller
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Obx(() {
                                final imageUrl = controller
                                        .photoCreationModelData
                                        .value
                                        ?.processedImageUrl ??
                                    imageData.processedImageUrl ??
                                    "";

                                if (imageUrl.isEmpty) {
                                  return Center(
                                    child: Image.asset(
                                      Assets.demoResult2,
                                      width: 280,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Left: Big image
                                      Container(
                                        width: 200,
                                        height: 240,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: CustomCachedImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // Right: 4 images in 2x2 grid
                                      Container(
                                        width: 200, // larger than before
                                        height: 240,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 15),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            childAspectRatio:
                                                0.8, // taller thumbnails
                                          ),
                                          itemCount: 4,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: Colors.black26,
                                                    width: 2),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                    8), // same radius as the border
                                                child: CustomCachedImage(
                                                  imageUrl: imageUrl,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildActionButtons(
                                    controller,
                                    MediaQuery.of(context).size.width,
                                    imageData),
                                SpaceH20(),
                                Text(
                                  "You can download this Image",
                                  textAlign: TextAlign.center,
                                  style: CustomTextTheme.regular16.copyWith(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SpaceH20(),
                                SelectedDetailsWidget(
                                  isPreview: true,
                                  controller: controller,
                                  imageData: imageData,
                                ),
                                SpaceH20(),
                                CustomElevatedButton(
                                  onPressed: () {
                                    if (token == null || token == "") {
                                      Get.offAllNamed(PrimaryRoute.login);
                                    } else {
                                      Get.offAllNamed(PrimaryRoute.home);
                                    }
                                  },
                                  text: "Go to Dashboard",
                                  minHeight: 60,
                                ),
                                SpaceH20(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(
      PhotoController controller, double width, PhotoCreationModel imageData) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SpaceH20(),
                Center(
                  child: Container(
                    width: 500,
                    height: 300, // total height for both sides
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(() {
                      final imageUrl = controller.photoCreationModelData.value
                              ?.processedImageUrl ??
                          imageData.processedImageUrl ??
                          "";

                      if (imageUrl.isEmpty) {
                        return Center(
                          child: SizedBox(
                            width: 350,
                            height: 200,
                            child: Image.asset(
                              Assets.demoResult2,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left: Big image
                            Container(
                              width: 240,
                              height: 290,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: CustomCachedImage(
                                imageUrl: imageUrl,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Right: 4 images in 2x2 grid
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 230,
                              height: 290,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 0.79,
                                  // < 1 makes cells taller, so the grid fills height
                                ),
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.black26, width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          8), // same radius as the border
                                      child: CustomCachedImage(
                                        imageUrl: imageUrl,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButtons(controller, width, imageData),
                      SpaceH20(),
                      Text(
                        "You can download this Image",
                        textAlign: TextAlign.center,
                        style: CustomTextTheme.regular16.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SpaceH20(),
                      SelectedDetailsWidget(
                        isPreview: true,
                        controller: controller,
                        imageData: imageData,
                      ),
                      SpaceH20(),
                      CustomElevatedButton(
                        onPressed: () {
                          Get.offNamed(PrimaryRoute.home);
                        },
                        text: "Go to Dashboard",
                        minHeight: 60,
                      ),
                      SpaceH20(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      PhotoController controller, double width, PhotoCreationModel imageData) {
    final isWide = width >= 800;

    final downloadButton = _isSaving
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          )
        : CustomElevatedButton(
            onPressed: () {
              if (_isSaving) return;
              final url =
                  controller.photoCreationModelData.value?.processedImageUrl ??
                      imageData.processedImageUrl ??
                      "";
              if (url.isNotEmpty) {
                setState(() => _isSaving = true);
                saveImageToGallery(url).whenComplete(() {
                  setState(() => _isSaving = false);
                });
              }
            },
            text: "Download Photo",
            minHeight: 60,
          );

    // Only show Share button when running on Web
    final shareButton = !kIsWeb
        ? CustomOutlineButton(
            onPressed: () async {
              final url =
                  controller.photoCreationModelData.value?.processedImageUrl ??
                      "";
              if (url.isNotEmpty) {
                await shareImage(url);
              }
            },
            label: "Share",
            minHeight: 60,
          )
        : const SizedBox.shrink();

    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: downloadButton),
          if (kIsWeb) const SizedBox(width: 20),
          if (!kIsWeb) Expanded(child: shareButton),
        ],
      );
    } else {
      return Column(
        children: [
          downloadButton,
          if (kIsWeb) const SizedBox(height: 20),
          if (!kIsWeb) shareButton,
        ],
      );
    }
  }

  Future<void> saveImageToGallery(String url) async {
    try {
      if (kIsWeb) {
        WebDownloadHelper.downloadImage(url);

        Get.snackbar(
          "Success",
          "Image downloaded successfully",
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      PermissionStatus status;

      if (Platform.isAndroid) {
        status = await Permission.photos.request();

        if (status.isDenied) {
          status = await Permission.storage.request();
        }

        if (status.isDenied) {
          status = await Permission.manageExternalStorage.request();
        }
      } else {
        status = await Permission.photos.request();
      }

      if (status.isGranted || status.isLimited) {
        final now = DateTime.now();
        final fileName = "snapid_image_${now.millisecondsSinceEpoch}.jpg";

        final tempDir = await getTemporaryDirectory();
        final filePath = "${tempDir.path}/$fileName";

        await Dio().download(url, filePath);

        final success =
            await GallerySaver.saveImage(filePath, albumName: "SnapID");

        if (success ?? false) {
          Get.snackbar(
            "Success",
            "Image saved as $fileName",
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          Get.snackbar(
            "Failed",
            "Could not save image",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      } else if (status.isDenied) {
        Get.snackbar(
          "Permission Denied",
          "Please allow storage access to save images",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else if (status.isPermanentlyDenied) {
        Get.snackbar(
          "Permission Permanently Denied",
          "Please enable storage permission from app settings",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          mainButton: TextButton(
            onPressed: () => openAppSettings(),
            child:
                const Text("Settings", style: TextStyle(color: Colors.white)),
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error saving image: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> shareImage(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/shared_image.jpg';

      await Dio().download(url, filePath);

      final file = File(filePath);

      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)],
            text: "Check out this image!");
      } else {
        Get.snackbar("Error", "Image file not found after download",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar("Error", "Error sharing image: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
  }
}
