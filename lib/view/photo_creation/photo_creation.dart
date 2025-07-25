import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoController/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_bullets.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class PhotoCreationScreen extends StatelessWidget {
  const PhotoCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PhotoController controller = Get.find<PhotoController>();

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Column(
            children: [
              _buildHeader(controller),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.appBg),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeader(PhotoController controller) {
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
                const SpaceH60(),
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

  Widget _step1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 20),
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
                onPressed: () {},
                label: "Take a Photo",
                icon: Icons.camera_alt_outlined,
                iconColor: AppColors.whiteColor,
                textColor: AppColors.whiteColor,
                minHeight: 60,
              ),
              const SpaceH20(),
              CustomElevatedButton(
                onPressed: () async {
                  await Get.toNamed(PrimaryRoute.selectedPhoto);
                  // controller.setStep(2); // Update step on return
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 12, right: 12, top: 30, bottom: 10),
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
              Container(
                padding:
                    EdgeInsets.only(left: 12, right: 12, top: 30, bottom: 10),
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

  Widget _step2(controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
          child: Text(
            "We'll automatically apply the correct dimensions, background color, and photo rules.",
            textAlign: TextAlign.center,
            style: CustomTextTheme.regular20
                .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        const SpaceH20(),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: CSCPickerPlus(
                    layout: Layout.vertical,
                    showStates: false,
                    showCities: false,
                    dropdownDecoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledDropdownDecoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    selectedItemStyle: TextStyle(color: AppColors.whiteColor),
                    dropdownHeadingStyle: TextStyle(
                      // Style for the dropdown heading
                      color: AppColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    dropdownDialogRadius: 12.0,
                    searchBarRadius: 12.0,
                    onCountryChanged: (value) {
                      print("Selected country: $value");
                    },
                  ),
                ),
                SpaceH15(),
                Obx(() => Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        buildRadio(
                            controller, DocumentType.passport, "Passport"),
                        buildRadio(controller, DocumentType.visa, "Visa"),
                        buildRadio(controller, DocumentType.drivingLicense,
                            "Driving License"),
                        buildRadio(
                            controller, DocumentType.manually, "Manually"),
                      ],
                    )),
                SpaceH40(),
                Obx(() {
                  if (controller.selectedType == DocumentType.manually) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: 'Width',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              "X",
                              style: CustomTextTheme.regular20
                                  .copyWith(color: AppColors.whiteColor),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: CustomTextField(
                                hintText: 'Height',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SpaceH20(),
                        Wrap(spacing: 16, runSpacing: 8, children: [
                          buildUnitRadio(controller, Unit.cm, "cm"),
                          buildUnitRadio(controller, Unit.inch, "inch"),
                        ]),
                      ],
                    );
                  } else
                    return SizedBox();
                }),
                SpaceH40(),
                CustomElevatedButton(
                  minHeight: 60,
                  onPressed: () {
                    controller.setStep(3);
                  },
                  text: "Next",
                )
              ],
            )),
      ],
    );
  }

  Widget _step3(controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceH40(),
        Center(
          child: Container(
            width: 200,
            height: 240,
            child: Image.asset(Assets.demoResult),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
          child: Text(
            "Here’s what your photo will look like. Watermark will be removed after payment.",
            textAlign: TextAlign.center,
            style: CustomTextTheme.regular20
                .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                      SpaceH20(), 
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
                              print("Tap tap");
                            },
                            child: SvgPicture.asset(Assets.edit_icon,width: 20,),
                          )
                        ],
                      ),
                      SpaceH30(), 
                      infoRow("Country:", "🇺🇸 United States"),
                      const Divider(color: Colors.white12),
                      infoRow("Document:", "Passport"),
                      const Divider(color: Colors.white12),
                      infoRow("Size:", "50x50 Cm"),
                    ],
                  ),
                ),
                SpaceH40(),
                CustomElevatedButton(
                  minHeight: 60,
                  onPressed: () {},
                  text: "Next",
                )
              ],
            )),
      ],
    );
  }

  Widget buildRadio(
    PhotoController controller,
    DocumentType type,
    String label,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<DocumentType>(
          value: type,
          groupValue: controller.selectedType.value,
          activeColor: AppColors.primaryColor,
          onChanged: (value) {
            if (value != null) {
              controller.changeType(value);
            }
          },
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget buildUnitRadio(
    PhotoController controller,
    Unit type,
    String label,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<Unit>(
          value: type,
          groupValue: controller.selectedUnit.value,
          activeColor: AppColors.primaryColor,
          onChanged: (value) {
            if (value != null) {
              controller.changeUnit(value);
            }
          },
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                CustomTextTheme.regular16.copyWith(color: AppColors.whiteColor),
          ),
          Text(
            value,
            style:
                CustomTextTheme.regular16.copyWith(color: AppColors.whiteColor),
          )
        ],
      ),
    );
  }

  Widget _buildBodyData(PhotoController controller) {
    switch (controller.currentStep.value) {
      case 1:
        return _step1();
      case 2:
        return _step2(controller);
      case 3:
        return _step3(controller);

      default:
        return Container();
    }
  }
}
