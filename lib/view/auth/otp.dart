import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/auth/opt/otp_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/message_popup.dart';

class OtpScreen extends StatelessWidget {
  final OtpController controller = Get.put(OtpController());

  OtpScreen({super.key});

  Widget buildOtpBox(int index) {
    return Obx(() => Container(
          width: 50,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: controller.filledFields[index].value
                ? Border.all(color: Colors.deepPurpleAccent)
                : Border.all(color: Colors.transparent),
            color: const Color.fromRGBO(255, 255, 255, 0.05),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller.otp[index],
            focusNode: controller.focusNodes[index],
            onChanged: (value) => controller.handleInput(value, index),
            style: const TextStyle(color: Colors.white, fontSize: 24),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Assets.appBg,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Text(
                        "Verify Your Identity",
                        style: CustomTextTheme.headingLarge.copyWith(
                          fontSize: 32,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Select how you'd like to receive \nthe verification code.",
                        textAlign: TextAlign.center,
                        style: CustomTextTheme.regular16.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) => buildOtpBox(index)),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: ()  {
                      controller.verifyOtp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(60),
                    ),
                    child: Text(
                      controller.isPasswordForgot
                          ? "Verify"
                          : "Verify & Continue",
                      style: CustomTextTheme.regular16
                          .copyWith(color: AppColors.whiteColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      Get.toNamed(PrimaryRoute.verification);
                    },
                    icon:
                        const Icon(Icons.sync, color: Colors.white54, size: 18),
                    label: const Text(
                      "Change Method",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      const Text(
                        "Didn't receive the code?",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Obx(() => TextButton(
                            onPressed: controller.secondsRemaining.value > 0
                                ? null
                                : () {
                                    controller.resendOtp();
                                  },
                            child: Text(
                              controller.secondsRemaining.value > 0
                                  ? "Resend in ${controller.secondsRemaining.value}s"
                                  : "Resend",
                              style: TextStyle(
                                color: controller.secondsRemaining.value > 0
                                    ? Colors.white54
                                    : Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}