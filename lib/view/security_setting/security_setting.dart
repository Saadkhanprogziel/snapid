import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:snapid/constant/assets.dart';
import 'package:snapid/routes/routes.dart';

import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_setting_item.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class SecuritySetting extends StatelessWidget {
  const SecuritySetting({super.key});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isMobile = deviceWidth <= 800;

    final List<Widget> items = [
      SettingItem(
        title: "Change Password",
        subtitle: "Update account security",
        icon: Icons.lock,
        onTap: () {
          Get.toNamed(PrimaryRoute.resetPassword);
        },
      ),
      if (!kIsWeb)
        SettingItem(
          title: "Enable Biometric Login",
          subtitle: "Toggle Face ID / Touch ID",
          icon: Icons.fingerprint,
          onTap: () {
            Get.toNamed(PrimaryRoute.biometric);
          },
        ),
      SettingItem(
        title: "Delete My Account",
        subtitle: "Permanently remove account",
        icon: Icons.delete,
        onTap: () {
          Get.toNamed(PrimaryRoute.deleteAccount);
        },
      ),
    ];

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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SafeArea(
                  child: CustomHeader(
                    title: 'Security Setting',
                    showBackButton: true,
                  ),
                ),
                SpaceH20(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: isMobile ? 0 : 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 1 : 3,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: isMobile ? 100 : 80,
                        ),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: isMobile ? 100 : 80,
                            child: items[index],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
