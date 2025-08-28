import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/countries.dart';
import 'package:snapid/utlis/country_model.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class Step2Widget extends StatelessWidget {
  final PhotoController controller;

  const Step2Widget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                        _buildRadio(
                            controller, DocumentType.passport, "Passport"),
                        _buildRadio(controller, DocumentType.visa, "Visa"),
                        _buildRadio(controller, DocumentType.drivingLicense,
                            "Driving License"),
                        _buildRadio(
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
                                controller: controller.widthController,
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
                                controller: controller.heightController,
                                hintText: 'Height',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SpaceH20(),
                        Wrap(spacing: 16, runSpacing: 8, children: [
                          _buildUnitRadio(controller, Unit.cm, "cm"),
                          _buildUnitRadio(controller, Unit.inch, "inch"),
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

  Widget _buildRadio(
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

  Widget _buildUnitRadio(
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

  void _showCountryPicker(PhotoController controller) {
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
}