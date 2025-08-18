import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
// import 'package:snapid/controllers/dashboard/dashboard_controller.dart';
import 'package:snapid/controllers/photoController/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/countries.dart';
import 'package:snapid/utlis/country_model.dart';
import 'package:snapid/utlis/custom_bullets.dart';
import 'package:snapid/utlis/custom_dialog_pop.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_text_field.dart';
import 'package:snapid/utlis/screenBg.dart';
import 'package:snapid/utlis/subscription_card.dart';

class PhotoCreationScreen extends StatelessWidget {
  const PhotoCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PhotoController controller = Get.put(PhotoController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // Back navigation already happened — do nothing

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
            solidBtnLabel: "Exit Aniway",
            isActionPopUp: true,
            solidBtnBg: AppColors.red,
          ));
        } else {
          controller.goToPreviousStep();
        }
        ;
      },
      child: Scaffold(
        body: Stack(
          children: [
            buildBackground(),
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
                Obx(() {
                  return controller.currentStep.value == 2
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: CustomElevatedButton(
                            minHeight: 60,
                            onPressed: () {
                              controller.goToNextStep();
                            },
                            text: "Next",
                          ),
                        )
                      : const SizedBox.shrink();
                }),
              ],
            ),
          ],
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
                                color: Colors
                                    .transparent, // Optional: Add background color if needed
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

  Widget _step1(PhotoController controller) {
    print(controller.currentStep);
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

  Widget _step2(PhotoController controller) {
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Country",
                  style: CustomTextTheme.regular18
                      .copyWith(color: AppColors.whiteColor),
                ),
                SpaceH15(),
                Obx(() {
                  final country = controller.selectedCountry.value;
                  return OutlinedButton(
                    onPressed: () => _showCountryPicker(controller),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    ),
                    child: Row(
                      children: [
                        if (country != null)
                          Row(
                            children: [
                              SvgPicture.asset(
                                country.flag,
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                country.name,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        else
                          Text(
                            "Select Country",
                            style: TextStyle(color: Colors.white),
                          ),
                        Spacer(),
                        Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                  );
                }),
                SpaceH25(),
                Text(
                  "Select Document Type",
                  style: CustomTextTheme.regular18
                      .copyWith(color: AppColors.whiteColor),
                ),
                SpaceH10(),
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
                  if (controller.selectedType.value == DocumentType.manually) {
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
              ],
            )),
      ],
    );
  }

  Widget _step3(PhotoController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceH40(),
        Center(
          child: Container(
            width: 170,
            height: 200,
            child: Image.asset(Assets.demoResult),
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
            padding: const EdgeInsets.symmetric(horizontal: 30, ),
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
                      infoRow("Country:",
                          "${controller.selectedCountry.value?.name ?? 'Select Country'}",
                          flagPath: controller.selectedCountry.value!.flag),
                      const Divider(color: Colors.white12),
                      infoRow("Document:", controller.selectedType.value.name),
                      const Divider(color: Colors.white12),
                      infoRow("Size:", "50x50 Cm"),
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
                      CustomElevatedButton(
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

  Widget _step4(PhotoController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceH10(),
        Center(
          child: Container(
            width: 350,
            height: 250,
            child: Image.asset(Assets.demoResult2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
          child: Text(
            "Download Both Files After Payment.",
            textAlign: TextAlign.center,
            style: CustomTextTheme.regular20
                .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SubscriptionCard(
                        title: "Standard",
                        photoCount: 1,
                        price: "\$6.99",
                        description: "Perfect for one time",
                        isPopular: false,
                        savings: "",
                        onBuy: () {
                          Get.toNamed(PrimaryRoute.payment_method);
                        },
                      ),
                      SizedBox(width: 8),
                      SubscriptionCard(
                        title: "Smart Pack",
                        photoCount: 3,
                        price: "\$14.99",
                        description: "Perfect for three photos",
                        isPopular: true,
                        savings: "Save - 28 %",
                        onBuy: () {
                          Get.toNamed(PrimaryRoute.payment_method);
                        },
                      ),
                      SizedBox(width: 8),
                      SubscriptionCard(
                        title: "Family Pack",
                        photoCount: 5,
                        price: "\$19.99",
                        description: "Ideal for families or agencies",
                        isPopular: false,
                        savings: "Save - 43 %",
                        onBuy: () {
                          Get.toNamed(PrimaryRoute.payment_method);
                        },
                      ),
                    ],
                  ),
                ),
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

  void _showCountryPicker(controller) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 41, 42, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        TextEditingController searchController = TextEditingController();
        RxList<Country> filteredCountries = allCountries.obs;

        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  cursorColor: AppColors.whiteColor,
                  style:
                      TextStyle(color: AppColors.whiteColor), // <-- important
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: AppColors.whiteColor),
                    labelText: 'Search country',
                    labelStyle: TextStyle(color: AppColors.whiteColor),
                    hintStyle: CustomTextTheme.regular14
                        .copyWith(color: AppColors.whiteColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    filteredCountries.value = allCountries
                        .where((c) =>
                            c.name.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  },
                ),
                SizedBox(height: 16),
                Obx(() => SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: filteredCountries.length,
                        itemBuilder: (_, index) {
                          final country = filteredCountries[index];
                          return ListTile(
                            leading: SvgPicture.asset(
                              country.flag,
                              width: 24,
                              height: 24,
                            ),
                            title: Text(
                              country.name,
                              style: CustomTextTheme.regular14.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                            onTap: () => controller.selectCountry(country),
                          );
                        },
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyData(PhotoController controller) {
    switch (controller.currentStep.value) {
      case 1:
        return _step1(controller);
      case 2:
        return _step2(controller);
      case 3:
        return _step3(controller);
      case 4:
        return _step4(controller);

      default:
        return Container();
    }
  }
}
