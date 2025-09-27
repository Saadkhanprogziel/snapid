import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/controllers/profile/edit_profile_controller.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/view/profile_fragment/edit_profile/edit_profile_fields.dart';
import 'package:snapid/view/profile_fragment/edit_profile/edit_profile_header.dart';


class ProfileFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final EditProfileController controller;
  final bool isWideScreen;

  const ProfileFormCard({
    super.key,
    required this.formKey,
    required this.controller,
    required this.isWideScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Profile header with image picker
        ProfileHeader(
          controller: controller,
        ),

        /// Form
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ProfileFormFields(
                    controller: controller,
                    isWideScreen: isWideScreen,
                  ),
                  // const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),

        /// Action Buttons
        Padding(
          padding: const EdgeInsets.only(bottom: 10,top: 10),
          child: Row(
            children: [
              // const SpaceW12(),
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
                        if (formKey.currentState!.validate()) {
                          controller.onSaveProfile();
                        }
                      },
                      text: controller.isLoading.value ? "Saving..." : "Save",
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}