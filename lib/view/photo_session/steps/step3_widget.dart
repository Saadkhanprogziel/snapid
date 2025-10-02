import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/view/photo_session/cached_image.dart';
import 'package:snapid/view/photo_session/steps/selected_details_widget.dart';

class Step3Widget extends StatelessWidget {
  final PhotoController controller;

  const Step3Widget({super.key, required this.controller});

  Widget _buildImageGrid(List<String> imageUrls) {
    // Handle up to 5 images in a 2-column grid
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.8,
      ),
      itemCount: imageUrls.length > 5 ? 5 : imageUrls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: imageUrls[index].isEmpty
              ? Container(
                  color: Colors.white10,
                  child: Image.asset(Assets.demoResult, fit: BoxFit.cover),
                )
              : CustomCachedImage(imageUrl: imageUrls[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceH40(),
        // Before and After Images Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Before Images Grid
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "BEFORE",
                      style: CustomTextTheme.regular14.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 300,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: _buildImageGrid(
                        controller.photoCreationModelData.value?.originalImages ?? [],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // After Image
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "AFTER",
                      style: CustomTextTheme.regular14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryColor ?? Colors.blue, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: controller.processedWatermarkedUrl.value.isEmpty
                            ? Image.asset(Assets.demoResult, fit: BoxFit.cover)
                            : CustomCachedImage(
                                imageUrl: controller.processedWatermarkedUrl.value),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
          child: Text(
            "Here's what your photo will look like. Watermark will be removed after payment.",
            textAlign: TextAlign.center,
            style: CustomTextTheme.regular18
                .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectedDetailsWidget(controller: controller),
                SpaceH20(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Text(
                          "Don't like this version? You can upload agian or Retake",
                          textAlign: TextAlign.center,
                          style: CustomTextTheme.regular16.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w400)),
                      SpaceH20(),
                      CustomOutlineButton(
                        onPressed: () {},
                        label: "Retake or Upload Again",
                        minHeight: 60,
                      ),
                      SpaceH20(),
                      controller.isLoading.value
                          ? const Center(
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : CustomElevatedButton(
                              onPressed: () {
                                controller.goToNextStep();
                              },
                              text: "Proceed To Download",
                              minHeight: 60,
                            ),
                    ],
                  ),
                ),
                SpaceH20(),
              ],
            )),
      ],
    );
  }
}