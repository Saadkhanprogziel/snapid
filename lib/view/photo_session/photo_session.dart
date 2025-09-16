import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/controllers/photoSession/process_loading_screen.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_dialog_pop.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/screenBg.dart';
import 'package:snapid/view/photo_session/steps/upload_photo_step1.dart';
import 'package:snapid/view/photo_session/steps/step2_widget.dart';
import 'package:snapid/view/photo_session/steps/step3_widget.dart';
import 'package:snapid/view/photo_session/steps/step4_widget.dart';

class PhotoSessionScreen extends StatelessWidget {
  const PhotoSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (Get.arguments is Map)
        ? Map<String, dynamic>.from(Get.arguments)
        : <String, dynamic>{};

    final bool fromHistory = args['fromHistory'] ?? false;
    final PhotoController controller = Get.put(PhotoController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (controller.currentStep.value == 1) {
          Get.dialog(CustomDialogPop(
            svgPath: Assets.closeIcon,
            title: "Exit Photo Creation?",
            message:
                "You haven't completed all steps. Are you sure you want to exit? Your progress may be lost.",
            onCancel: () => Get.back(),
            onPressed: () => Get.offAllNamed(PrimaryRoute.home),
            solidBtnLabel: "Exit Anyway",
            isActionPopUp: true,
            solidBtnBg: AppColors.red,
          ));
        } else {
          if (fromHistory) {
            Get.back();
          } else {
            controller.goToPreviousStep();
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            buildBackground(),
            LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;

                if (width >= 800) {
                  return Row(
                    children: [
                      
                      Expanded(
                        flex: 1, // smaller portion (40%)
                        child: _buildCircleWithFloatingIcons(controller, width),
                      ),

                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 600),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 40),
                                padding: EdgeInsets.only(top: 50),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              color: AppColors.cardColor,
                            ),
                            child: _buildMainContent(controller),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      header(controller, fromHistory),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Obx(() => _buildBodyData(controller)),
                            ],
                          ),
                        ),
                      ),
                      Obx(() {
                        if (controller.currentStep.value == 2) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: controller.isLoading.value
                                ? const Center(
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : CustomElevatedButton(
                                    minHeight: 60,
                                    onPressed: () {
                                      controller.goToNextStep();
                                    },
                                    text: "Next",
                                  ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

Widget _buildCircleWithFloatingIcons(PhotoController controller, double screenWidth) {
  return Obx(() {
    final icons = [
      Icons.person_outline,
      Icons.shield_outlined,
      Icons.cloud_download_outlined,
    ];

    final labels = [
      "Step 1",
      "Step 2",
      "Step 3",
    ];

    final descriptions = [
      "Upload your photo",
      "AI processes your photo",
      "Download or print",
    ];

    final double outerCircleSize = screenWidth * 0.25; // scales with screen size
    final double innerCircleSize = outerCircleSize * 0.75;
    final double outerRadius = outerCircleSize / 2;
    final double iconSize = outerCircleSize * 0.15; // scales too
    final double padding = 30;

    final double centerX = (outerCircleSize / 2) + padding;
    final double centerY = (outerCircleSize / 2) + padding;

    final List<double> angles = [
      -45,
      0,
      45,
    ];

    return SizedBox(
      width: outerCircleSize + 170,
      height: outerCircleSize + 100, // little taller to fit descriptions
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Outer Circle
          Positioned(
            left: padding,
            top: padding,
            child: Container(
              width: outerCircleSize,
              height: outerCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryColor.withAlpha(50),
                  width: 2,
                ),
              ),
            ),
          ),

          // Inner Circle
          Positioned(
            left: centerX - innerCircleSize / 2,
            top: centerY - innerCircleSize / 2,
            child: Container(
              width: innerCircleSize,
              height: innerCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardColor,
              ),
            ),
          ),

          // Center text
          Positioned(
            left: centerX - 20,
            top: centerY - 20,
            child: Text(
              "${controller.currentStep.value}/4",
              style: CustomTextTheme.regular26.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ),

          // Icons + Labels + Descriptions on the arc
          ...List.generate(icons.length, (index) {
            final angle = angles[index] * (math.pi / 180);
            final offsetX = outerRadius * math.cos(angle);
            final offsetY = outerRadius * math.sin(angle);

            final bool isActive = (index + 1) <= controller.currentStep.value;

            // Icon position
            final double iconLeft = centerX + offsetX - iconSize / 2;
            final double iconTop = centerY + offsetY - iconSize / 2;

            // Text position (right of icon)
            final double textLeft = iconLeft + iconSize + 8;
            final double textTop = iconTop + (iconSize / 2) - 25;

            return Stack(
              children: [
                // Icon
                Positioned(
                  left: iconLeft,
                  top: iconTop,
                  child: Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColors.primaryColor
                          : Colors.grey[800],
                    ),
                    child: Icon(
                      icons[index],
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),

                // Label
                Positioned(
                  left: textLeft,
                  top: textTop,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        labels[index],
                        style: CustomTextTheme.regular18.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        descriptions[index],
                        style: CustomTextTheme.regular14.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  });
}


  Widget floatingIcons(PhotoController controller) {
    final List<IconData> icons = [
      Icons.person_outline,
      Icons.shield_outlined,
      Icons.cloud_download_outlined,
    ];

    final List<String> stepTitles = [
      "Step 1",
      "Step 2",
      "Step 3",
    ];

    final List<String> stepDescriptions = [
      "Choose Country or Doc Type",
      "AI Processes Your Photo",
      "Download or Print",
    ];

    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(3, (index) {
            final bool isActive = (index + 1) <= controller.currentStep.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Circle Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isActive ? AppColors.primaryColor : Colors.grey[800],
                    ),
                    child: Icon(
                      icons[index],
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Texts
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stepTitles[index],
                        style: CustomTextTheme.regular16.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        stepDescriptions[index],
                        style: CustomTextTheme.regular12.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ));
  }

  Widget _buildMainContent(PhotoController controller) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Obx(() => _buildBodyData(controller)),
              ],
            ),
          ),
        ),
        Obx(() {
          if (controller.currentStep.value == 2) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: controller.isLoading.value
                  ? const Center(
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : CustomElevatedButton(
                      minHeight: 60,
                      onPressed: () {
                        controller.goToNextStep();
                      },
                      text: "Next",
                    ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget header(PhotoController controller, fromHistory) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(Assets.headerbg),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Row(
                  mainAxisAlignment: controller.currentStep.value > 1
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if (controller.currentStep.value > 1)
                      GestureDetector(
                        onTap: () => controller.goToPreviousStep(),
                        child: const Icon(Icons.arrow_back,
                            color: AppColors.whiteColor),
                      ),
                    GestureDetector(
                      onTap: () {
                        if (fromHistory) {
                          Get.back();
                        } else {
                          Get.dialog(CustomDialogPop(
                            svgPath: Assets.closeIcon,
                            title: "Exit Photo Creation?",
                            message:
                                "You haven't completed all steps. Are you sure you want to exit? Your progress may be lost.",
                            onCancel: () => Get.back(),
                            onPressed: () => Get.offAllNamed(PrimaryRoute.home),
                            solidBtnLabel: "Exit Anyway",
                            isActionPopUp: true,
                            solidBtnBg: AppColors.red,
                          ));
                        }
                      },
                      child:
                          const Icon(Icons.close, color: AppColors.whiteColor),
                    ),
                  ],
                )),
            const SpaceH30(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepText(controller),
                _buildStepIndicator(controller),
              ],
            ),
            const SpaceH40(),
            _buildLineStepIndicator(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildStepText(PhotoController controller) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Step ${controller.currentStep.value}",
              style: CustomTextTheme.regular26
                  .copyWith(color: AppColors.whiteColor),
            ),
            Text(
              _getStepDescription(controller.currentStep.value),
              style: CustomTextTheme.regular16
                  .copyWith(color: AppColors.whiteColor),
            ),
          ],
        ));
  }

  String _getStepDescription(int step) {
    switch (step) {
      case 1:
        return "Upload or Take a photo";
      case 2:
        return "Choose Country or Doc Type";
      case 3:
        return "Preview Your Photo";
      case 4:
        return "Pay & Download Your Photo";
      default:
        return "";
    }
  }

  Widget _buildStepIndicator(PhotoController controller) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white24.withAlpha(30),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            "${controller.currentStep.value}/4",
            style:
                CustomTextTheme.regular22.copyWith(color: AppColors.whiteColor),
          ),
        ));
  }

  Widget _buildLineStepIndicator(PhotoController controller) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final isCompleted = index < controller.currentStep.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.white : Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ));
  }

  Widget _buildBodyData(PhotoController controller) {
    switch (controller.currentStep.value) {
      case 1:
        return UploadPhotoStep(controller: controller);
      case 2:
        return Step2Widget(controller: controller);
      case 3:
        return Step3Widget(controller: controller);
      case 4:
        return Step4Widget(controller: controller);
      default:
        return const SizedBox.shrink();
    }
  }
}
