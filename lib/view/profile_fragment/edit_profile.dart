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
                              /// Profile header
                              Center(
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            'https://www.w3schools.com/howto/img_avatar.png',
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              // TODO: upload image
                                            },
                                            child: const CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 14,
                                              child: Icon(
                                                Icons.upload,
                                                color: Colors.black,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
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
                                          onChanged: (value) =>
                                              controller.editProfile.firstName =
                                                  value,
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
                                          onChanged: (value) =>
                                              controller.editProfile.lastName =
                                                  value,
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
                                          controller: controller.emailController,
                                          onChanged: (value) =>
                                              controller.editProfile.email =
                                                  value,
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
                                              dropdownColor: const Color.fromARGB(
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

                                        /// Phone + Country Code
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
                                                // Country Code
                                                SizedBox(
                                                  height: 65,
                                                  child: OutlinedButton(
                                                    onPressed: () =>
                                                        _showCountryCodePicker(
                                                            controller),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.white10,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        if (controller
                                                                .selectedCountryCode
                                                                .value !=
                                                            null) ...[
                                                          SvgPicture.asset(
                                                            controller
                                                                .selectedCountryCode
                                                                .value!
                                                                .flag,
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          Text(
                                                            controller
                                                                .selectedCountryCode
                                                                .value!
                                                                .dialCode,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ] else
                                                          const Text(
                                                            "+00",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white70,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        const Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
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
                                                    validator: (value) =>
                                                        value == null ||
                                                                value.isEmpty
                                                            ? 'Phone number is required'
                                                            : (value.length < 10
                                                                ? 'Phone number must be at least 10 digits'
                                                                : null),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// Action Buttons
                              Row(
                                children: [
                                  SpaceW12(),
                                  Expanded(
                                    child: CustomOutlineButton(
                                      minHeight: 60,
                                      onPressed: () => Get.back(),
                                      label: "Cancel",
                                    ),
                                  ),
                                  SpaceW12(),
                                  Expanded(
                                    child: CustomElevatedButton(
                                      minHeight: 60,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          controller.onSaveProfile();
                                        }
                                      },
                                      text: "Save",
                                    ),
                                  ),
                                ],
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

  /// Country picker
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
