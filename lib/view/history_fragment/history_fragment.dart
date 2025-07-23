import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/history/history_controller.dart';
import 'package:snapid/routes/routes.dart';

import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_history_card.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_tabbar.dart';
import 'package:snapid/utlis/empty_data_widget.dart';

class HistoryFragment extends StatelessWidget {
  const HistoryFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController());

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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 18),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(20, 223, 222, 222),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset(Assets.asistantIcon),
                      ),
                      Text(
                        "History",
                        style: CustomTextTheme.regular24
                            .copyWith(color: AppColors.whiteColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(PrimaryRoute.notification);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 18),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(20, 223, 222, 222),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SvgPicture.asset(Assets.bellIcon),
                        ),
                      ),
                    ],
                  ),
                ),
                const SpaceH10(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(20, 223, 222, 222),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Obx(
                                () {
                                  return TabBarWidget(
                                    tabs: ['All Orders', 'Active', 'Expired'],
                                    selectedIndex: controller.selectedTab.value,
                                    onTabSelected: (index) {
                                      controller.onTabChanged(index);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SpaceH20(),
                Expanded(
                  child: Obx(
                    () {
                      // print(object)
                      return controller.selectedTab.value == 0
                          ? ListView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              children: const [
                                HistoryCustomCard(
                                  imageUrl:
                                      'https://www.w3schools.com/howto/img_avatar2.png',
                                  country: 'United States',
                                  date: 'May 17, 2025',
                                  status: 'Processed',
                                  statusColor: Color.fromARGB(113, 0, 229, 34),
                                ),
                                SizedBox(height: 20),
                                HistoryCustomCard(
                                  imageUrl:
                                      'https://www.w3schools.com/howto/img_avatar.png',
                                  country: 'Italy',
                                  date: 'May 17, 2025',
                                  status: 'Expire',
                                  statusColor: Color.fromARGB(58, 255, 0, 0),
                                ),
                              ],
                            )
                          : EmptyDataWidget(
                              imagePath: Assets.historIcon,
                              title: "No Photo Orders Yet",
                              subtitle:
                                  "Looks like you haven’t started yet. Tap below to create your first photo — it's quick and easy!",
                              buttonTitle: "Upload or Capture",
                              onPressed: () {
                                // handle action
                              },
                            );
                    },
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
