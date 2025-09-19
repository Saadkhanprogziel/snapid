import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_setting_item.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isMobile = deviceWidth <= 800;

    final List<Widget> items = [
      SettingItem(
        title: "Ticket Management",
        icon: Icons.lock,
         onTap: () {
          Get.toNamed(PrimaryRoute.ticket_management);
        },
      ),

      SettingItem(
        title: "Ask SnapBot",
        icon: Icons.lock,
      ),
      SettingItem(
        title: "Report a Bug",
        icon: Icons.lock,
        onTap: () {
          Get.toNamed(PrimaryRoute.report_bug);
        },
      )
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
            padding: EdgeInsets.all(isMobile  ? 8.0 : 50),
            child: Column(
              children: [
                SafeArea(
                  child: CustomHeader(
                    title: 'Help & Support',
                    showBackButton: true,
                  ),
                ),
                // SpaceH20(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                     padding:
                          EdgeInsets.symmetric(horizontal: isMobile ? 0 : 20),
                      child: Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isMobile ? 1 : 2,
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
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                                    color:
                                                        AppColors.whiteColor),
                                          ),
                                          Text(
                                            "support@snapid.app!",
                                            style: CustomTextTheme.regular12
                                                .copyWith(
                                                    color: AppColors.grey),
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
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: AppColors.cardColor,
                                        ),
                                        child: Center(
                                          child: Icon(Icons.language,
                                              color: Colors.white70),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Help Center Website",
                                            style: CustomTextTheme.regular16
                                                .copyWith(
                                                    color:
                                                        AppColors.whiteColor),
                                          ),
                                          Text(
                                            "www.snapid.com",
                                            style: CustomTextTheme.regular12
                                                .copyWith(
                                                    color: AppColors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
// _buildHeader
