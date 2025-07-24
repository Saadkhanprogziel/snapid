import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/delete_account/delete_account_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class DeleteAccount extends StatelessWidget {
  DeleteAccount({super.key});

  final DeleteAccountController controller = Get.put(DeleteAccountController());

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Why Are You Leaving?",
                        style: CustomTextTheme.bold16.copyWith(color: Colors.white),
                      ),
                      SpaceH20(),
                      _buildRadioOption("I no longer need this service"),
                      _buildRadioOption("I had issues with the app"),
                      _buildRadioOption("Concerned about privacy"),
                      _buildRadioOption("Other"),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomOutlineButton(
                        onPressed: () => Get.back(),
                        label: "Cancel",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: controller.deleteAccount,
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
  }

  Widget _buildRadioOption(String title) {
    return Obx(() => RadioListTile<String>(
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          value: title,
          groupValue: controller.selectedReason.value,
          onChanged: (value) {
            controller.setReason(value!);
          },
          activeColor: Colors.deepPurpleAccent,
          contentPadding: EdgeInsets.zero,
        ));
  }
}
