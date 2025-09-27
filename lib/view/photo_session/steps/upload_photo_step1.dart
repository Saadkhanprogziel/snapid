import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_bullets.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class UploadPhotoStep extends StatelessWidget {
  final PhotoController controller;

  const UploadPhotoStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

     final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isMobile = deviceWidth <= 800;

    // print(controller.currentStep);
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: isMobile ? 70.0 : 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "For best results, choose a well-lit photo showing your full face and both ears.",
            textAlign: TextAlign.center,
            style: CustomTextTheme.regular20
                .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          const SpaceH20(),
          Column(
            children: [
              CustomOutlineButton(
                onPressed: () {
                  controller.capturePhotosSimple();
                },
                label: "Take a Photo",
                icon: Icons.camera_alt_outlined,
                iconColor: AppColors.whiteColor,
                textColor: AppColors.whiteColor,
                minHeight: 60,
              ),
              const SpaceH20(),
              CustomElevatedButton(
                onPressed: () async {
                  await Get.toNamed(PrimaryRoute.selectedPhoto)?.then((_) {
                    if (controller.currentStep.value != 1) {
                      controller.setStep(1);
                    }
                  });
                },
                text: "Upload from Gallery",
                minHeight: 60,
                icon: const Icon(
                  Icons.upload,
                  color: AppColors.whiteColor,
                ),
                iconOnRight: false,
              )
            ],
          ),
          SpaceH20(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 8, right: 8, top: 30, bottom: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(100, 21, 168, 31),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "Good",
                      style: CustomTextTheme.regular18
                          .copyWith(color: AppColors.whiteColor),
                    ),
                    SpaceH10(),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green,
                          width: 3,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://www.w3schools.com/howto/img_avatar2.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SpaceW15(),
              Container(
                padding:
                    EdgeInsets.only(left: 8, right: 8, top: 30, bottom: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(100, 159, 25, 25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "Bad",
                      style: CustomTextTheme.regular16
                          .copyWith(color: AppColors.whiteColor),
                    ),
                    SpaceH10(),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.brown,
                          width: 3,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://www.w3schools.com/howto/img_avatar.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SpaceH20(),
          BulletList(
            items: [
              'This is the first item',
              'Second bullet with SVG icon',
              'Another custom-bullet line',
            ],
            gap: 12,
            lineHeight: 10,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}