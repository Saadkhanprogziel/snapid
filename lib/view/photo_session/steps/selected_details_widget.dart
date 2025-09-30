import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/models/photo_creation/photo_creation_model.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class SelectedDetailsWidget extends StatelessWidget {
  final PhotoController controller;
  final PhotoCreationModel? imageData;
  final bool? isPreview; 

  const SelectedDetailsWidget({super.key, required this.controller, this.imageData, this.isPreview = false});

  @override
  Widget build(BuildContext context) {
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
                style: CustomTextTheme.regular18.copyWith(color: AppColors.whiteColor),
              ),
             
            ],
          ),
          SpaceH20(),
          Obx(() {
            return _infoRow(
              "Country:",
              controller.selectedCountry.value?.name ?? imageData?.countryName ?? "Select Country",
              flagPath: controller.selectedCountry.value?.flag  ?? imageData?.countryFlag,
            );
          }),
          const Divider(color: Colors.white12),
          Obx(() {
            return _infoRow(
                "Document:",
                formatDocumentName(controller.selectedType.value.name));
          }),
          const Divider(color: Colors.white12),
          
          if(isPreview == true)
          _infoRow(
                "Size:",
                "${imageData?.size}"
          ),
           if(isPreview == false)
          Obx(() {
            return _infoRow(
                "Size:",
                selectedSize(controller.selectedType.value.name, controller));
          }),
        ],
      ),
    );
  }

  String selectedSize(String type, PhotoController controller) {
    switch (type) {
      case "visa":
        return controller.selectedCountry.value?.visaSize ?? "";
      case "drivingLicense":
        return controller.selectedCountry.value?.drivingLicense ?? "";
      case "passport":
        return controller.selectedCountry.value?.passportSize ?? "";
      case "manually":
        return "${controller.manualSize}";
      default:
        return "";
    }
  }

  String formatDocumentName(String name) {
    switch (name) {
      case "visa":
        return "Visa";
      case "drivingLicense":
        return "Driving License";
      case "passport":
        return "Passport";
      case "manually":
        return "Manually";
      default:
        return name;
    }
  }

  Widget _infoRow(String label, String value, {String? flagPath}) {
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
                Container(
                  width: 30,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: flagPath,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
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
