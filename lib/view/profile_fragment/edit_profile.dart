import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/profile/edit_profile_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/countries.dart';
import 'package:snapid/utlis/country_model.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_text_field.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.appBg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  SafeArea(
                    child: CustomHeader(
                      title: "Edit Profile",
                      showBackButton: true,
                    ),
                  ),
                  SpaceH80(),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Transform.translate(
                          offset: const Offset(0, -60),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /// Profile header with image picker
                              Center(
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Obx(() {
                                            if (controller.selectedProfileImage
                                                    .value !=
                                                null) {
                                              return Image.file(
                                                controller.selectedProfileImage
                                                    .value!,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              );
                                            } else if (controller
                                                .profileImageUrl
                                                .value
                                                .isNotEmpty) {
                                              return Image.network(
                                                controller
                                                    .profileImageUrl.value,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    width: 120,
                                                    height: 120,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Image.network(
                                                      'https://www.w3schools.com/howto/img_avatar.png',
                                                      width: 120,
                                                      height: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                },
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Container(
                                                    width: 120,
                                                    height: 120,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              return Image.network(
                                                'https://www.w3schools.com/howto/img_avatar.png',
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              );
                                            }
                                          }),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => controller
                                                .showImageSourceActionSheet(),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 18,
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.black,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Loading overlay when uploading
                                        Obx(() {
                                          if (controller.isLoading.value) {
                                            return Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        }),
                                      ],
                                    ),
                                    const SpaceH20(),
                                    Text(
                                      '${controller.editProfile.firstName ?? ''} ${controller.editProfile.lastName ?? ''}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      controller.editProfile.email ?? '',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// Form
                              Expanded(
                                child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20),

                                        /// First Name
                                        CustomTextField(
                                          controller:
                                              controller.firstNameController,
                                          onChanged: (value) => controller
                                              .editProfile.firstName = value,
                                          label: 'First Name',
                                          hintText: 'First Name',
                                          prefixIcon: Icons.person,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'First name is required';
                                            }
                                            if (value.length < 2) {
                                              return 'First name must be at least 2 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),

                                        /// Last Name
                                        CustomTextField(
                                          controller:
                                              controller.lastNameController,
                                          onChanged: (value) => controller
                                              .editProfile.lastName = value,
                                          label: 'Last Name',
                                          hintText: 'Last Name',
                                          prefixIcon: Icons.person,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Last name is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),

                                        /// Email
                                        CustomTextField(
                                          controller:
                                              controller.emailController,
                                          onChanged: (value) => controller
                                              .editProfile.email = value,
                                          label: 'Email',
                                          hintText: 'johndoe@example.com',
                                          prefixIcon: Icons.email,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Email is required';
                                            }
                                            if (!RegExp(
                                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                .hasMatch(value)) {
                                              return 'Please enter a valid email';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),

                                        /// Gender Dropdown
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 8),
                                              child: Text(
                                                'Gender',
                                                style: CustomTextTheme.regular14
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            DropdownButtonFormField<String>(
                                              value:
                                                  controller.editProfile.gender,
                                              onChanged: (value) {
                                                controller.editProfile.gender =
                                                    value;
                                                controller.update();
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please select your gender';
                                                }
                                                return null;
                                              },
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.white,
                                              ),
                                              dropdownColor:
                                                  const Color.fromARGB(
                                                      216, 39, 43, 52),
                                              style: CustomTextTheme.regular14
                                                  .copyWith(
                                                      color: Colors.white),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white10,
                                                hintText: 'Select Gender',
                                                hintStyle: const TextStyle(
                                                    color: Colors.white70),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide.none,
                                                ),
                                                errorStyle: const TextStyle(
                                                    color: Colors.red),
                                              ),
                                              items: controller.genderOptions
                                                  .map(
                                                    (gender) =>
                                                        DropdownMenuItem(
                                                      value: gender,
                                                      child: Text(gender),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),

                                        /// Phone Number
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 8),
                                              child: Text(
                                                'Phone Number',
                                                style: CustomTextTheme.regular14
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const SpaceW10(),
                                                Expanded(
                                                  child: CustomTextField(
                                                    controller: controller
                                                        .phoneController,
                                                    onChanged: (value) =>
                                                        controller.editProfile
                                                            .phone = value,
                                                    hintText: 'Phone Number',
                                                    prefixIcon: Icons.phone,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    validator: (value) => value ==
                                                                null ||
                                                            value.isEmpty
                                                        ? 'Phone number is required'
                                                        : (value.length < 10
                                                            ? 'Phone number must be at least 10 digits'
                                                            : null),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SpaceH20(),
                                          ],
                                        ),

                                        const SizedBox(height: 100),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// Action Buttons
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: [
                                    const SpaceW12(),
                                    Expanded(
                                      child: CustomOutlineButton(
                                        minHeight: 60,
                                        onPressed: () => Get.back(),
                                        label: "Cancel",
                                      ),
                                    ),
                                    const SpaceW12(),
                                    Expanded(
                                      child: Obx(() => CustomElevatedButton(
                                            minHeight: 60,
                                            onPressed: () {
                                              if (controller.isLoading.value) {
                                                return;
                                              }
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                controller.onSaveProfile();
                                              }
                                            },
                                            text: controller.isLoading.value
                                                ? "Saving..."
                                                : "Save",
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCountryCodePicker(EditProfileController controller) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: const Color.fromARGB(255, 41, 42, 50),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        TextEditingController searchController = TextEditingController();
        RxList<Country> filteredCountries = allCountries.obs;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Country',
                  style: CustomTextTheme.regular16.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: searchController,
                  cursorColor: AppColors.whiteColor,
                  style: TextStyle(color: AppColors.whiteColor),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: AppColors.whiteColor),
                    labelText: 'Search country or dial code',
                    labelStyle: TextStyle(color: AppColors.whiteColor),
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
                    filteredCountries.value = allCountries
                        .where((c) =>
                            c.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            c.dialCode.contains(value))
                        .toList();
                  },
                ),
                const SizedBox(height: 16),
                Obx(
                  () => SizedBox(
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
                            '${country.name} (${country.dialCode})',
                            style: CustomTextTheme.regular14.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                          onTap: () {
                            controller.selectCountryCode(country);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
