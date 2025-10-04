import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/history/history_controller.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/photo_creation/photo_creation_model.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/image_utlis/download_helper.dart';
import 'package:snapid/view/photo_session/cached_image.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';

class HistoryCustomCard extends StatelessWidget {
  final PhotoCreationModel photoCreationModel;
  final GestureTapDownCallback? onMoreTapDown;
  final HistoryController controller;
  final VoidCallback? onDelete;

  const HistoryCustomCard({
    super.key,
    this.onMoreTapDown,
    this.onDelete,
    required this.controller,
    required this.photoCreationModel,
  });
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 800;

    final imageSize = isMobile ? 130.0 : 100.0;
    final cardPadding = isMobile ? 15.0 : 14.0;
    final titleStyle = isMobile
        ? CustomTextTheme.regular22.copyWith(color: AppColors.whiteColor)
        : CustomTextTheme.regular18.copyWith(color: AppColors.whiteColor);
    final subtitleStyle = isMobile
        ? CustomTextTheme.regular12.copyWith(color: AppColors.whiteColor)
        : CustomTextTheme.regular10.copyWith(color: AppColors.whiteColor);
    final statusTextStyle = isMobile
        ? CustomTextTheme.regular14.copyWith(color: AppColors.whiteColor)
        : CustomTextTheme.regular12.copyWith(color: AppColors.whiteColor);

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: cardPadding, vertical: cardPadding),
        constraints: BoxConstraints(minHeight: isMobile ? 220 : 170),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: imageSize,
                  height: imageSize,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomCachedImage(
                      imageUrl: photoCreationModel.processedImageUrl ??
                          photoCreationModel.processedWatermarkedUrl,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(photoCreationModel.countryName, style: titleStyle),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text("Created", style: subtitleStyle),
                          const SpaceW10(),
                          Text(
                            formatDate(photoCreationModel.createdAt,
                                pattern: 'dd MMM, yyyy'),
                            style: subtitleStyle,
                          ),
                        ],
                      ),
                      const SpaceH20(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: photoCreationModel.status == "CREDITED"
                                  ? Colors.green.withValues(alpha: 0.5)
                                  : Colors.orange.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(photoCreationModel.status,
                                style: statusTextStyle),
                          ),
                          const SizedBox(height: 8),
                          if (photoCreationModel.status != "CREDITED")
                            Text(
                              "Expire Within 7 days",
                              style: subtitleStyle,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  color: const Color.fromARGB(194, 46, 46, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteDialog(context);
                    } else if (value == 'redownload') {
                      if (kIsWeb) {}
                      _handleDownload(controller);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    _buildMenuItem(
                        Icons.file_download_outlined, 'Download', 'redownload'),
                    _buildDivider(),
                    _buildMenuItem(Icons.delete, 'Delete', 'delete'),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(159, 46, 46, 46),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SpaceH20(),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(20, 223, 222, 222),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset(
                    Assets.globeIcon,
                    width: 15,
                  ),
                ),
                const SpaceW10(),
                Text(
                  photoCreationModel.documentType,
                  style: subtitleStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String? dateString, {String pattern = 'yyyy-MM-dd'}) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat(pattern).format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  PopupMenuItem<String> _buildMenuItem(
      IconData icon, String text, String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  PopupMenuDivider _buildDivider() {
    return const PopupMenuDivider(height: 1);
  }

  void _handleDownload(HistoryController controller) async {
    if (photoCreationModel.status != "CREDITED") {
      _navigateToPaymentScreen();
    } else {
      if (kIsWeb) {
        WebDownloadHelper.downloadImage(photoCreationModel.processedImageUrl ??
            photoCreationModel.processedWatermarkedUrl );

        Get.snackbar(
          "Success",
          "Image downloaded successfully",
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
      saveImageToGallery(
        photoCreationModel.processedImageUrl ??
            photoCreationModel.processedWatermarkedUrl,
      );
    }
  }

  void _navigateToPaymentScreen() async {
    final PhotoController photoController = Get.find<PhotoController>();
    await photoController.getUserDetails();

    photoController.processedWatermarkedUrl.value =
        photoCreationModel.processedWatermarkedUrl;
    photoController.photoCreationModelData.value = photoCreationModel;
    photoController.sessionId.value = photoCreationModel.id;
    storeSessionData(photoCreationModel);
    appStorage.write("session_id", photoController.sessionId.value);
    photoController.setStep(4);

   
  }

  void storeSessionData(PhotoCreationModel model) {
    appStorage.write('photoSession', model.toJson());
  }

  Future<void> saveImageToGallery(String url) async {
    try {
      PermissionStatus status = PermissionStatus.denied;

      if (Platform.isAndroid) {
        status = await Permission.storage.request();
        if (status.isDenied || status.isPermanentlyDenied) {
          status = await Permission.manageExternalStorage.request();
        }
      } else {
        status = await Permission.photos.request();
      }

      if (status.isGranted || status.isLimited) {
        Get.snackbar(
          "Downloading",
          "Please wait while the image is being downloaded...",
          duration: Duration(seconds: 2),
          colorText: Colors.white,
        );

        try {
          final now = DateTime.now();
          final formattedDate =
              "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
          final fileName = "snapid_processed_image_$formattedDate.jpg";

          final tempDir = await getTemporaryDirectory();
          final filePath = "${tempDir.path}/$fileName";

          await Dio().download(url, filePath);

          final file = File(filePath);
          if (!await file.exists()) {
            throw Exception("Downloaded file not found");
          }

          final success =
              await GallerySaver.saveImage(filePath, albumName: "SnapID");

          if (success == true) {
            Get.snackbar(
              "Success",
              "Image Downloaded successfully!",
              colorText: Colors.white,
              backgroundColor: const Color.fromARGB(97, 76, 175, 79),
              duration: const Duration(seconds: 3),
            );
          } else {
            Get.snackbar(
              "Failed",
              "Could not save image to gallery",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } catch (e) {
          Get.snackbar(
            "Error",
            "Failed to save image: ${e.toString()}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (status.isDenied) {
        Get.snackbar(
          "Permission Denied",
          "Storage permission is required to save images",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      } else if (status.isPermanentlyDenied) {
        Get.dialog(
          AlertDialog(
            backgroundColor: AppColors.solidCardColor,
            title: Text(
              "Permission Required",
              style: CustomTextTheme.regular16
                  .copyWith(color: AppColors.whiteColor),
            ),
            content: Text(
              "Storage permission is permanently denied. Please enable it from app settings to save images.",
              style: CustomTextTheme.regular14
                  .copyWith(color: AppColors.whiteColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Cancel",
                  style: CustomTextTheme.regular16
                      .copyWith(color: AppColors.whiteColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  openAppSettings();
                },
                child: Text(
                  "Settings",
                  style:
                      CustomTextTheme.regular16.copyWith(color: AppColors.red),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error in saveImageToGallery: $e");
      Get.snackbar(
        "Error",
        "An unexpected error occurred: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.solidCardColor,
        title: Text(
          "Delete Item",
          style:
              CustomTextTheme.regular16.copyWith(color: AppColors.whiteColor),
        ),
        content: Text(
          "Are you sure you want to delete this item?",
          style:
              CustomTextTheme.regular14.copyWith(color: AppColors.whiteColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: CustomTextTheme.regular16
                  .copyWith(color: AppColors.whiteColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onDelete?.call();
            },
            child: Text(
              "Delete",
              style: CustomTextTheme.regular16.copyWith(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }
}
