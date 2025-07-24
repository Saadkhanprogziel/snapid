import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    final BiometricController controller = Get.put(BiometricController());

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
          Column(children: [
            SafeArea(
                child: CustomHeader(
              title: "Enable Biometirc Login",
              showBackButton: true,
            )),
            SpaceH20(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                  return Column(
                    children: [
                      SettingItem(
                        svgPath: Assets.touch_id,
                        title: 'Touch ID',
                        hasToggle: true,
                        toggleValue: controller.biometirc.value,
                        onToggle: (val) {
                          controller.setBiometric(val);
                        },
                      ),
                      SpaceH12(),
                      SettingItem(
                        svgPath: Assets.face_id,
                        title: 'Face Id',
                        hasToggle: true,
                        toggleValue: controller.face_id.value,
                        onToggle: (val) {
                          controller.setFaceId(val);
                        },
                      ),
                      SpaceH20(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("SnapID supports secure biometric login using the biometric system on your device. This will replace the need to enter your password every time.",style: CustomTextTheme.regular16.copyWith(color: Colors.white,fontWeight: FontWeight.w400),textAlign:TextAlign.center,),
                      )
                    ],
                  );
                }
              ),
            ),
          ])
        ],
      ),
    );
  }
}
