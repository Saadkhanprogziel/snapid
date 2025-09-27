import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/view/photo_session/cached_image.dart';

class HistoryCustomCard extends StatelessWidget {
  final String imageUrl;
  final String country;
  final String documentType;
  final String date;
  final String status;
  final Color statusColor;
  final GestureTapDownCallback? onMoreTapDown;

  /// Callback when delete is confirmed
  final VoidCallback? onDelete;

  const HistoryCustomCard({
    super.key,
    required this.imageUrl,
    required this.country,
    required this.date,
    required this.status,
    required this.statusColor,
    this.onMoreTapDown,
    this.onDelete,
    required this.documentType,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Image
                Container(
                  width: 130,
                  height: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomCachedImage(imageUrl: imageUrl),
                  ),
                ),
      
                const SizedBox(width: 12),
      
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            country,
                            style: CustomTextTheme.regular22
                                .copyWith(color: AppColors.whiteColor),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                "Created",
                                style: CustomTextTheme.regular12
                                    .copyWith(color: AppColors.whiteColor),
                              ),
                              const SpaceW10(),
                              Text(
                                date,
                                style: CustomTextTheme.regular12
                                    .copyWith(color: AppColors.whiteColor),
                              ),
                            ],
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
                              color: statusColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: CustomTextTheme.regular14
                                  .copyWith(color: AppColors.whiteColor),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (status != "CREDITED")
                          Text(
                            "Expire Within 7 days",
                            style: CustomTextTheme.regular12
                                .copyWith(color: AppColors.whiteColor),
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
                      saveImageToGallery(imageUrl);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    _buildMenuItem(Icons.file_download_outlined,
                        'Re-Download', 'redownload'),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                      documentType,
                      style: CustomTextTheme.regular12
                          .copyWith(color: AppColors.whiteColor),
                    ),
                  ],
                ),
                // Text(
                //   "3.5 x 4.5 cm",
                //   style: CustomTextTheme.regular12
                //       .copyWith(color: AppColors.whiteColor),
                // ),
              ],
            )
          ],
        ),
      ),
    );
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
    return const PopupMenuDivider(
      height: 1,
    );
  }

  Future<void> saveImageToGallery(String url) async {
    try {
      PermissionStatus status = PermissionStatus.denied;
      
      if (Platform.isAndroid) {
        // For Android, request storage permission
        status = await Permission.storage.request();
        
        // If storage is denied, try manage external storage for newer Android versions
        if (status.isDenied || status.isPermanentlyDenied) {
          status = await Permission.manageExternalStorage.request();
        }
      } else {
        // For iOS, request photos permission
        status = await Permission.photos.request();
      }

      if (status.isGranted || status.isLimited) {
        // Show loading indicator
        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
        
        try {
          final now = DateTime.now();
          final formattedDate =
              "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
          final fileName = "snapid_processed_image_$formattedDate.jpg";

          final tempDir = await getTemporaryDirectory();
          final filePath = "${tempDir.path}/$fileName";
          
          // Download the image
          await Dio().download(url, filePath);

          // Verify file exists
          final file = File(filePath);
          if (!await file.exists()) {
            throw Exception("Downloaded file not found");
          }

          // Save to gallery
          final success = await GallerySaver.saveImage(filePath, albumName: "SnapID");
          
          // Close loading dialog
          Get.back();

          if (success == true) {
            Get.snackbar(
              "Success", 
              "Image re-downloaded successfully!",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 3),
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
          // Close loading dialog if still open
          if (Get.isDialogOpen == true) Get.back();
          
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
          duration: Duration(seconds: 4),
        );
      } else if (status.isPermanentlyDenied) {
        Get.dialog(
          AlertDialog(
            backgroundColor: AppColors.solidCardColor,
            title: Text(
              "Permission Required", 
              style: CustomTextTheme.regular16.copyWith(color: AppColors.whiteColor)
            ),
            content: Text(
              "Storage permission is permanently denied. Please enable it from app settings to save images.", 
              style: CustomTextTheme.regular14.copyWith(color: AppColors.whiteColor)
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Cancel",
                  style: CustomTextTheme.regular16.copyWith(color: AppColors.whiteColor)
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  openAppSettings();
                },
                child: Text(
                  "Settings",
                  style: CustomTextTheme.regular16.copyWith(color: AppColors.red)
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
        title: Text("Delete Item",style: CustomTextTheme.regular16.copyWith(color: AppColors.whiteColor)),
        content:  Text("Are you sure you want to delete this item?", style: CustomTextTheme.regular14.copyWith(color: AppColors.whiteColor),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // cancel
            child:  Text("Cancel",style: CustomTextTheme.regular16.copyWith(color: AppColors.whiteColor)),
          ),
          TextButton(
            onPressed: () {
            Get.back(); // close dialog
              onDelete?.call(); // notify parent
            },
            child:  Text("Delete",style: CustomTextTheme.regular16.copyWith(color: AppColors.red)),
          ),
        ],
      ),
    );
  }
}