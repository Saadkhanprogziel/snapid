import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_text_field.dart';
import 'package:snapid/view/photo_session/steps/selected_details_widget.dart';

class Step2Widget extends StatelessWidget {
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
                  onPressed: () {
                    controller.fetchCountries();
                    controller.searchController.clear();
                    _showCountryPicker(context, controller);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade800),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                  child: Row(
                    children: [
                      if (country != null)
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: 34,
                              height: 20,
                               child: (country.flag.isNotEmpty)
                                   ? CachedNetworkImage(
                                       imageUrl: country.flag,
                                       fit: BoxFit.cover,
                                     )
                                   : Container(
                                       decoration: BoxDecoration(
                                         color: Colors.grey,
                                         borderRadius: BorderRadius.circular(8),
                                       ),
                                     ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              country.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      else
                        const Text(
                          "Select Country",
                          style: TextStyle(color: Colors.white),
                        ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                _MaxValueInputFormatter(1080),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "X",
                            style: CustomTextTheme.regular20
                                .copyWith(color: AppColors.whiteColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: controller.heightController,
                              hintText: 'Height',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                _MaxValueInputFormatter(1080),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SpaceH20(),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          _buildUnitRadio(controller, Unit.cm, "cm"),
                          _buildUnitRadio(controller, Unit.inch, "inch"),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
              // const SpaceH10(),
              SelectedDetailsWidget(controller: controller)
            ],
          ),
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

  void _showCountryPicker(BuildContext context, PhotoController controller) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Use dialog for larger screens (tablets/desktop), bottomsheet for mobile
    if (screenWidth >= 800) {
      _showCountryDialog(context, controller);
    } else {
      _showCountryBottomSheet(context, controller);
    }
  }

  void _showCountryDialog(BuildContext context, PhotoController controller) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color.fromARGB(255, 41, 42, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 500,
          height: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Country',
                    style: CustomTextTheme.regular20.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Field
              TextField(
                controller: controller.searchController,
                cursorColor: AppColors.whiteColor,
                style: const TextStyle(color: AppColors.whiteColor),
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.whiteColor),
                  labelText: 'Search country',
                  labelStyle: const TextStyle(color: AppColors.whiteColor),
                  hintStyle: CustomTextTheme.regular14
                      .copyWith(color: AppColors.whiteColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                },
              ),
              const SizedBox(height: 20),

              // Country List
              Expanded(
                child: Obx(() {
                  if (controller.countryLoads.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                      ),
                    );
                  }

                  final displayCountries = controller.countries.isEmpty 
                      ? controller.countries 
                      : controller.countries;

                  return ListView.builder(
                    itemCount: displayCountries.length,
                    itemBuilder: (_, index) {
                      final country = displayCountries[index];
                      return ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 50,
                          height: 30,
                           child: (country.flag.isNotEmpty)
                               ? CachedNetworkImage(
                                   imageUrl: country.flag,
                                   fit: BoxFit.cover,
                                 )
                               : Container(
                                   decoration: BoxDecoration(
                                     color: Colors.grey,
                                     borderRadius: BorderRadius.circular(8),
                                   ),
                                 ),
                        ),
                         title: Text(
                           country.name,
                           style: CustomTextTheme.regular14.copyWith(
                             color: AppColors.whiteColor,
                           ),
                         ),
                        onTap: () {
                          controller.selectCountry(country);
                          // Get.back();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hoverColor: Colors.white12,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCountryBottomSheet(
      BuildContext context, PhotoController controller) {
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 41, 42, 50),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (_, controllerSheet) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search Field
                    TextField(
                      controller: searchController,
                      cursorColor: AppColors.whiteColor,
                      style: const TextStyle(color: AppColors.whiteColor),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.whiteColor),
                        labelText: 'Search country',
                        labelStyle:
                            const TextStyle(color: AppColors.whiteColor),
                        hintStyle: CustomTextTheme.regular14
                            .copyWith(color: AppColors.whiteColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade800),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                            },
                    ),
                    const SizedBox(height: 16),

                    // Country List
                    Expanded(
                      child: Obx(() {
                        final displayCountries = controller.countries.isEmpty 
                            ? controller.countries 
                            : controller.countries;

                        return ListView.builder(
                          controller: controllerSheet,
                          itemCount: displayCountries.length,
                          itemBuilder: (_, index) {
                            final country = displayCountries[index];
                            return ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                width: 50,
                                height: 30,
                                 child: (country.flag.isNotEmpty)
                                     ? CachedNetworkImage(
                                         imageUrl: country.flag,
                                         fit: BoxFit.cover,
                                       )
                                     : Container(
                                         decoration: BoxDecoration(
                                           color: Colors.grey,
                                           borderRadius: BorderRadius.circular(8),
                                         ),
                                       ),
                              ),
                              title: Text(
                                country.name,
                                style: CustomTextTheme.regular14.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              onTap: () {
                                controller.selectCountry(country);
                                // Get.back();
                              },
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _MaxValueInputFormatter extends TextInputFormatter {
  final int max;
  _MaxValueInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final int? value = int.tryParse(newValue.text);
    if (value == null) return oldValue;

    if (value > max) {
      return oldValue; // prevent going beyond 1080
    }
    return newValue;
  }
}