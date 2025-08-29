import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    // // ✅ reset only if not coming from history
    // if (!fromHistory) {
    //   controller.currentStep.value = 1;
    // }

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
            onCancel: () {
              Get.back();
            },
            onPressed: () {
          
              Get.offAllNamed(PrimaryRoute.home);
            },
            solidBtnLabel: "Exit Anyway",
            isActionPopUp: true,
            solidBtnBg: AppColors.red,
          ));
        } else {
          if (fromHistory) {
            Get.back();
          } else
            controller.goToPreviousStep();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            buildBackground(),
            Column(
              children: [
                _buildHeader(controller, fromHistory),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Obx(() {
                          return _buildBodyData(controller);
                        }),
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
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ],
            ),
            // Add the processing loading screen overlay
            Obx(() => ProcessingLoadingScreen(
                  isVisible: controller.isProcessingLoading.value,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PhotoController controller, fromHistory) {
    return Column(
      children: [
        Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SpaceH20(),
                Obx(() => Row(
                      mainAxisAlignment: controller.currentStep.value > 1
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        if (controller.currentStep.value > 1)
                          GestureDetector(
                            onTap: () => controller.goToPreviousStep(),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          )
                        else
                          SizedBox.shrink(),
                        GestureDetector(
                          onTap: () {
                            if (fromHistory) {
                              Get.back();
                            } else
                              Get.dialog(CustomDialogPop(
                                svgPath: Assets.closeIcon,
                                title: "Exit Photo Creation?",
                                message:
                                    "You haven't completed all steps. Are you sure you want to exit? Your progress may be lost.",
                                onCancel: () {
                                  Get.back();
                                },
                                onPressed: () {
                                  // Get.delete<DashboardController>();
                                  // Get.delete<PhotoController>();
                                  Get.offAllNamed(PrimaryRoute.home);
                                },
                                solidBtnLabel: "Exit Aniway",
                                isActionPopUp: true,
                                solidBtnBg: AppColors.red,
                              ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        )
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
                const SpaceH60(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLineStepIndicator(controller),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white24.withAlpha(10),
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
        return Container();
    }
  }
}
