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

class Step3Widget extends StatelessWidget {
  final PhotoController controller;

  const Step3Widget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceH40(),
        controller.processedWatermarkedUrl.value.isEmpty
            ? Center(
                child: Container(
                  width: 170,
                  height: 200,
                  child: Image.asset(Assets.demoResult),
                ),
              )
            : Center(
                child: Container(
                  width: 170,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomCachedImage(
                      imageUrl: controller.processedWatermarkedUrl.value),
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
                      _infoRow("Country:",
                          "${controller.selectedCountry.value?.name ?? 'Select Country'}",
                          flagPath: controller.selectedCountry.value!.flag),
                      const Divider(color: Colors.white12),
                      _infoRow("Document:", controller.selectedType.value.name),
                      const Divider(color: Colors.white12),
                      _infoRow("Size:", "50x50 Cm"),
                    ],
                  ),
                ),
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