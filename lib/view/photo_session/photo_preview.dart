import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/main.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/screenBg.dart';
import 'package:snapid/view/photo_session/cached_image.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:snapid/utlis/image_utlis/download_helper.dart';

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
    var proccessdIMG = appStorage.read("processed_img") ?? "";
    print(proccessdIMG);
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
                          // padding: const EdgeInsets.only(top: 50),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            color: AppColors.cardColor,
                          ),
                          child: _buildMainContent(
                              controller, width, proccessdIMG),
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
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SpaceH40(),
                          Center(
                            child: Container(
                              width: 280,
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Obx(() {
                                final imageUrl = controller
                                        .photoCreationModelData
                                        .value
                                        ?.processedImageUrl ??
                                    proccessdIMG ??
                                    "";
                                if (imageUrl.isEmpty) {
                                  return Center(
                                    child: Container(
                                      width: 350,
                                      height: 250,
                                      child: Image.asset(Assets.demoResult2),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Container(
                                      width: 230,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: CustomCachedImage(
                                        imageUrl: imageUrl,
                                      ),
                                    ),
                                  );
                                }
                              }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildActionButtons(
                                    controller,
                                    MediaQuery.of(context).size.width,
                                    proccessdIMG),
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
                                _buildInfoContainer(controller),
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
      PhotoController controller, double width, String proccessdIMG) {
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
                    width: 350,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(() {
                      final imageUrl = controller.photoCreationModelData.value
                              ?.processedImageUrl ??
                          proccessdIMG ??
                          "";
                      if (imageUrl.isEmpty) {
                        return Center(
                          child: Container(
                            width: 350,
                            height: 200,
                            child: Image.asset(
                              Assets.demoResult2,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Container(
                            width: 230,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomCachedImage(
                              imageUrl: imageUrl,
                            ),
                          ),
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
                      _buildActionButtons(controller, width, proccessdIMG),
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
                      _buildInfoContainer(controller),
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
      PhotoController controller, double width, String proccessdIMG) {
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
                      proccessdIMG ??
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

    final shareButton = CustomOutlineButton(
      onPressed: () async {
        final url =
            controller.photoCreationModelData.value?.processedImageUrl ?? "";
        if (url.isNotEmpty) {
          await shareImage(url);
        }
      },
      label: "Share",
      minHeight: 60,
    );

    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: downloadButton),
          const SizedBox(width: 20),
          Expanded(child: shareButton),
        ],
      );
    } else {
      return Column(
        children: [
          downloadButton,
          const SizedBox(height: 20),
          shareButton,
        ],
      );
    }
  }

  Widget _buildInfoContainer(PhotoController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpaceH10(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Selected Format:",
                style: CustomTextTheme.regular18
                    .copyWith(color: AppColors.whiteColor),
              ),
              GestureDetector(
                onTap: () {
                  controller.setStep(2);
                },
                child: SvgPicture.asset(
                  Assets.edit_icon,
                  width: 20,
                ),
              )
            ],
          ),
          SpaceH20(),
          infoRow(
            "Country:",
            "${controller.selectedCountry.value?.name ?? 'Select Country'}",
            flagPath: controller.selectedCountry.value?.flag ?? '',
          ),
          const Divider(color: Colors.white12),
          infoRow("Document:", controller.selectedType.value.name),
          const Divider(color: Colors.white12),
          infoRow("Size:", "50x50 Cm"),
        ],
      ),
    );
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
        // final formattedDate =
        //     "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
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
      print("Error saving image: $e");
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

  Widget infoRow(String label, String value, {String? flagPath}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: CustomTextTheme.regular14.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            children: [
              if (flagPath != null && flagPath.isNotEmpty) ...[
                SvgPicture.asset(
                  flagPath,
                  width: 30,
                ),
                SpaceW12(),
              ],
              Text(
                value,
                style: CustomTextTheme.regular14.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
