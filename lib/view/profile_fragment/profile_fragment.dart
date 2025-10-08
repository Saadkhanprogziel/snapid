import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/dashboard/dashboard_controller.dart';
import 'package:snapid/controllers/profile/profile_controller.dart';
import 'package:snapid/main.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_dialog_pop.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_setting_Item.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class ProfileFragment extends StatelessWidget {
  const ProfileFragment({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.put(ProfileController());
    DashboardController dashboardController = Get.find<DashboardController>();
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isMobile = deviceWidth <= 800;

    return Column(
      children: [
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: !isMobile ? 20 : 0),
            child: CustomHeader(
              title: "Profile",
              rightIconPath: Assets.bellIcon,
              onRightIconTap: () {
                Get.toNamed(PrimaryRoute.notification);
              },
            ),
          ),
        ),
        if (!isMobile) SpaceH120(),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: !isMobile ? 50 : 0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMobile ? 60 : 25),
                topRight: Radius.circular(isMobile ? 60 : 25),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 30 : 20),
              child: Transform.translate(
                offset: Offset(0, isMobile ? -60 : -40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: isMobile ? 120 : 90,
                                height: isMobile ? 120 : 90,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(isMobile ? 10 : 8),
                                  child: Obx(() {
                                    return CachedNetworkImage(
                                      imageUrl: dashboardController
                                              .user.value.profilePicture ??
                                          'https://www.w3schools.com/howto/img_avatar2.png',
                                      fit: BoxFit.cover,
                                    );
                                  }),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(PrimaryRoute.editProfile);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: isMobile ? 16 : 14,
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: isMobile ? 16 : 14,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SpaceH20(),
                          Obx(() => Text(
                                dashboardController.user.value.firstName != ""
                                    ? "${dashboardController.user.value.firstName} ${dashboardController.user.value.lastName}"
                                    : "John Doe",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 20 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Obx(() => Text(
                                dashboardController.user.value.email ?? "",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: isMobile ? 14 : 12,
                                ),
                              )),
                          SpaceH10(),
                          Obx(() => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 16 : 12,
                                  vertical: isMobile ? 20 : 14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(61, 82, 79, 112),
                                  borderRadius:
                                      BorderRadius.circular(isMobile ? 16 : 12),
                                ),
                                child: Text(
                                  'Credits Remaining: ${dashboardController.user.value.credits ?? 0}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 14 : 12,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SpaceH20(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Account Settings',
                        style: CustomTextTheme.regular18.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: isMobile ? 18 : 16,
                        ),
                      ),
                    ),
                    SpaceH10(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final bool isMobile = constraints.maxWidth <= 800;

                            return GridView.builder(
                              shrinkWrap: true,
                              itemCount: 4,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isMobile ? 1 : 3,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                mainAxisExtent: isMobile ? 100 : 80,
                              ),
                              itemBuilder: (context, index) {
                                final items = [
                                  SettingItem(
                                    svgPath: Assets.measurement,
                                    title: 'Measurement Unit',
                                    subtitle: 'Set Your Preferred Unit.',
                                    onTap: () {
                                      Get.dialog(
                                        CustomDialogPop(
                                          title: 'Select Measurement Unit',
                                          message:
                                              'Select how you want photo sizes to be displayed throughout the app.',
                                          isIcon: false,
                                          iconData: Icons.check,
                                          iconColor: AppColors.whiteColor,
                                          isActionPopUp: true,
                                          isRadio: true,
                                          
                                          radioOptions: controller.radioOptions,
                                          selectedOption:
                                              controller.selectedOption,
                                          onCancel: () => Get.back(),
                                          onPressed: () {
                                            controller.saveSelectedUnit();
                                            Get.back();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  SettingItem(
                                    icon: Icons.lock_outline,
                                    title: 'Security Setting',
                                    subtitle: 'Update Account Security',
                                    onTap: () => Get.toNamed(
                                        PrimaryRoute.securitySetting),
                                  ),
                                  SettingItem(
                                    icon: Icons.question_mark,
                                    title: 'Help & Support',
                                    subtitle: 'Chat Or Contact Us Directly.',
                                    onTap: () =>
                                        Get.toNamed(PrimaryRoute.help_support),
                                  ),
                                  SettingItem(
                                    svgPath: Assets.logout,
                                    title: 'Log Out',
                                    showArrow: false,
                                    onTap: () {
                                      Get.dialog(
                                        BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 15, sigmaY: 15),
                                          child: CustomDialogPop(
                                            solidBtnLabel: "Logout",
                                            title: "Log Out ?",
                                            message:
                                                "Are you sure you want to log out of your Snapid account?",
                                            svgPath: Assets.logout,
                                            isActionPopUp: true,
                                            backgroundColor:
                                                AppColors.cardColor,
                                            onCancel: () => Get.back(),
                                            onPressed: () {
                                              controller.logout();
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ];

                                return SizedBox(
                                  height: isMobile ? 100 : 80,
                                  child: items[index],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
