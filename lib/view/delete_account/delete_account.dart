import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/security_settting/security_setting_controller.dart';

import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';

// Import your SecurityController

class DeleteAccount extends StatelessWidget {
  DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SecuritySettingController>(
      init: SecuritySettingController(), // Initialize controller here
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: CustomHeader(
                      title: 'Delete My Account',
                      showBackButton: true,
                    ),
                  ),
                  SpaceH20(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Why Are You Leaving?",
                            style: CustomTextTheme.bold16
                                .copyWith(color: Colors.white),
                          ),
                          SpaceH20(),
                          _buildRadioOption(controller, "I no longer need this service"),
                          _buildRadioOption(controller, "I had issues with the app"),
                          _buildRadioOption(controller, "Concerned about privacy"),
                          _buildRadioOption(controller, "Other"),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomOutlineButton(
                            minHeight: 60,
                            onPressed: () => Get.back(),
                            label: "Cancel",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomElevatedButton(
                            minHeight: 60,
                            onPressed: controller.onDeleteProfile,
                            text: "Delete Account",
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
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

  Widget _buildRadioOption(SecuritySettingController controller, String title) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      value: title,
      groupValue: controller.selectedReason,
      onChanged: (value) {
        controller.setReason(value!);
      },
      activeColor: Colors.deepPurpleAccent,
      contentPadding: EdgeInsets.zero,
    );
  }
}
