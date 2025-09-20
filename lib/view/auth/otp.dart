import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/auth/opt/otp_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';

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

  Widget _buildOtpCard(BuildContext context, bool isWideScreen) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Enter Verification Code",
                  style: CustomTextTheme.headingLarge.copyWith(
                    fontSize: 32,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "We sent a 6-digit code. Enter it below to continue.",
                  textAlign: TextAlign.center,
                  style: CustomTextTheme.regular16.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              width: isWideScreen ? 600 : 450,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color.fromARGB(20, 223, 222, 222),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) => buildOtpBox(index)),
                  ),
                  const SizedBox(height: 30),
                  Obx(() => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            controller.verifyOtp();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
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
                        )),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      Get.toNamed(PrimaryRoute.verification);
                    },
                    icon: const Icon(Icons.sync,
                        color: Colors.white54, size: 18),
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
          ],
        ),
      ),
    );
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
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWideScreen = constraints.maxWidth > 800;

              if (isWideScreen) {
                // ✅ Desktop/Web layout
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              Assets.otp_screen,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildOtpCard(context, isWideScreen),
                      ),
                    ],
                  ),
                );
              } else {
                // ✅ Mobile layout
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildOtpCard(context, isWideScreen),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
