import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoController/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/screenBg.dart';
import 'package:snapid/view/photo_creation/cached_image.dart';

class PhotoPreview extends StatelessWidget {
  const PhotoPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final PhotoController controller = Get.find<PhotoController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // Back navigation already happened — do nothing

        Get.toNamed(PrimaryRoute.home);
      },
      child: Scaffold(
        body: Stack(
          children: [
            buildBackground(),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SpaceH40(),
                    Center(
                      child: Container(
                        width: 230,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomCachedImage(
                          imageUrl: controller.photoCreationModelData.value!
                                  .processedImageUrl ??
                              "",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomElevatedButton(
                            onPressed: () async {
                              final url = controller.photoCreationModelData
                                      .value!.processedImageUrl ??
                                  "";
                              if (url.isNotEmpty) {
                                await saveImageToGallery(url);
                              }
                            },
                            text: "Download Photo",
                            minHeight: 60,
                          ),
                          SpaceH20(),
                          CustomOutlineButton(
                            onPressed: () async {
                              final url = controller.photoCreationModelData
                                      .value!.processedImageUrl ??
                                  "";
                              if (url.isNotEmpty) {
                                await shareImage(url);
                              }
                            },
                            label: "Share",
                            minHeight: 60,
                          ),
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
                          Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Format:",
                                      style: CustomTextTheme.regular18.copyWith(
                                          color: AppColors.whiteColor),
                                    ),
                                  ],
                                ),
                                SpaceH20(),
                                infoRow(
                                  "Country:",
                                  "${controller.selectedCountry.value?.name ?? 'Select Country'}",
                                  flagPath:
                                      controller.selectedCountry.value!.flag,
                                ),
                                const Divider(color: Colors.white12),
                                infoRow("Document:",
                                    controller.selectedType.value.name),
                                const Divider(color: Colors.white12),
                                infoRow("Size:", "50x50 Cm"),
                              ],
                            ),
                          ),
                          SpaceH20(),
                          CustomElevatedButton(
                            onPressed: () {
                              Get.offAllNamed(PrimaryRoute.home);
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
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveImageToGallery(String url) async {
    try {
      final status = await Permission.photos.request();

      if (status.isGranted) {
        // ✅ Create custom filename with date
        final now = DateTime.now();
        final formattedDate =
            "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
        final fileName = "snapid_processed_image_$formattedDate.jpg";

        // ✅ Download to temp dir first
        final tempDir = await getTemporaryDirectory();
        final filePath = "${tempDir.path}/$fileName";
        await Dio().download(url, filePath);

        // ✅ Save with custom name
        final success =
            await GallerySaver.saveImage(filePath, albumName: "SnapID");

        if (success ?? false) {
          Get.snackbar("Success", "Image saved as $fileName",
              backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.snackbar("Failed", "Could not save image",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Permission Denied",
            "Please allow photo/gallery access to save images",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Error saving image: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> shareImage(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/shared_image.jpg';

      // Download image using Dio
      await Dio().download(url, filePath);

      final file = File(filePath);

      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)],
            text: "Check out this image!");
      } else {
        Get.snackbar("Error", "Image file not found after download",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Error sharing image: $e",
          snackPosition: SnackPosition.BOTTOM);
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
