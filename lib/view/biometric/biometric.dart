import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:snapid/constant/assets.dart';
import 'package:snapid/controllers/biometric/biometric._controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_setting_item.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class Biometric extends StatelessWidget {
  const Biometric({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the controller registered in ControllerBindings
    final BiometricController controller = Get.find<BiometricController>();

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
                  title: "Enable Biometric Login",
                  showBackButton: true,
                ),
              ),
              SpaceH20(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    return Column(
                      children: [
                        SpaceH12(),

                        // Show info if biometrics available
                        if (controller.isBiometricAvailable.value)
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  controller.biometricType.value == 'Face ID'
                                      ? Icons.face
                                      : Icons.fingerprint,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Available: ${controller.biometricType.value}',
                                  style: CustomTextTheme.regular16.copyWith(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Toggle for enabling/disabling biometrics
                        SettingItem(
                          svgPath: Assets.face_id,
                          title: 'BIOMETRIC LOGIN',
                          hasToggle: true,
                          toggleValue: controller.faceId.value,
                          onToggle: controller.isBiometricAvailable.value
                              ? (val) => controller.setBiometric(val)
                              : null, // Disable if not available
                        ),

                        SpaceH20(),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "SnapID supports secure biometric login using the biometric system on your device. "
                            "This will replace the need to enter your password every time.",
                            style: CustomTextTheme.regular16.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
