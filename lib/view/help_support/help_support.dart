import 'package:flutter/material.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_setting_item.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});

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
            children: [
              SafeArea(
                  child: CustomHeader(
                title: 'Help & Support',
                showBackButton: true,
              )),
              SpaceH20(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SettingItem(
                        title: "Ask SnapBot",
                        icon: Icons.lock,
                      ),
                      SpaceH10(),
                      SettingItem(
                        title: "Report a Bug",
                        icon: Icons.lock,
                        onTap: () {
                          // Get.toNamed(PrimaryRoute.biometric);
                        },
                      ),
                      SpaceH10(),
                      SettingItem(
                        title: "Rate Us",
                        icon: Icons.delete,
                        onTap: () {
                          // Get.toNamed(PrimaryRoute.deleteAccount);
                        },
                      ),
                      SpaceH10(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 25),
                        decoration: BoxDecoration(
                          color: AppColors.cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: AppColors.cardColor,
                                    ),
                                    child: Center(
                                      child: Icon(Icons.email,
                                          color: Colors.white70),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email",
                                        style: CustomTextTheme.regular16
                                            .copyWith(
                                                color: AppColors.whiteColor),
                                      ),
                                      Text(
                                        "support@snapid.app!",
                                        style: CustomTextTheme.regular12
                                            .copyWith(color: AppColors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: AppColors.grey.withAlpha(50),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: AppColors.cardColor,
                                    ),
                                    child: Center(
                                      child: Icon(Icons.email,
                                          color: Colors.white70),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email",
                                        style: CustomTextTheme.regular16
                                            .copyWith(
                                                color: AppColors.whiteColor),
                                      ),
                                      Text(
                                        "support@snapid.app!",
                                        style: CustomTextTheme.regular12
                                            .copyWith(color: AppColors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// _buildHeader
