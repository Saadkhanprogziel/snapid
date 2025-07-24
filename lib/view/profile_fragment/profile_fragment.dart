import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';

import 'package:snapid/controllers/profile/profile_controller.dart';
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
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                title: "Profile",
                rightIconPath: Assets.bellIcon,
                onRightIconTap: () {
                  Get.toNamed(PrimaryRoute.notification);
                },
              )),
              // SpaceH40(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  // padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor, // Light translucent color
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Transform.translate(
                      offset: const Offset(0, -60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          'https://www.w3schools.com/howto/img_avatar2.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 14,
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                          size: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SpaceH20(),
                                const Text(
                                  'John Doe',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'johndoe@gmail.com',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                SpaceH10(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 20),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(61, 82, 79, 112),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    'Credits Remaining: 03',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SpaceH20(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Account Settings',
                              style: CustomTextTheme.regular18
                                  .copyWith(color: AppColors.whiteColor),
                            ),
                          ),
                          SpaceH10(),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Obx(() {
                                return Column(
                                  children: [
                                    SettingItem(
                                      svgPath: Assets.history,
                                      title: 'My Orders',
                                      subtitle:
                                          'View History And Manage Downloads',
                                      onTap: () {
                                        Get.toNamed(PrimaryRoute.history);
                                      },
                                    ),
                                    SpaceH14(),
                                    SettingItem(
                                      svgPath: Assets.measurement,
                                      title: 'Measurement Unit',
                                      subtitle: 'Set Your Preferred Unit.',
                                      onTap: () {
                                        Get.dialog(CustomDialogPop(
                                          title: 'Select Measurement Unit',
                                          message:
                                              'Your account has been verified. You\'re all set to start using SnapID.',
                                          isIcon: false,
                                          iconData: Icons.check,
                                          iconColor: AppColors.whiteColor,
                                          isActionPopUp: true,
                                          isRadio: true,
                                          radioOptions: controller.radioOptions,
                                          selectedOption:
                                              controller.selectedOption,
                                          onCancel: () {
                                            Get.back();
                                          },
                                          onPressed: () {},
                                        ));
                                      },
                                    ),
                                    SpaceH14(),
                                    SettingItem(
                                      icon: Icons.lock_outline,
                                      title: 'Security Setting',
                                      subtitle: 'Update Account Security',
                                      onTap: () {
                                        Get.toNamed(
                                            PrimaryRoute.securitySetting);
                                      },
                                    ),
                                    SpaceH14(),
                                    SettingItem(
                                      svgPath: Assets.notification,
                                      title: 'Notification',
                                      subtitle:
                                          'Receive updates via push/email.',
                                      hasToggle: true,
                                      toggleValue:
                                          controller.isNotificationOn.value,
                                      onToggle: (val) {
                                        controller.setNotification(val);
                                      },
                                    ),
                                    SpaceH14(),
                                    SettingItem(
                                      icon: Icons.question_mark,
                                      title: 'Help & Support',
                                      subtitle: 'Chat Or Contact Us Directly.',
                                      // showArrow: true,
                                      onTap: () {
                                        Get.toNamed(PrimaryRoute.help_support);
                                      },
                                    ),
                                    SpaceH14(),
                                    SettingItem(
                                      svgPath: Assets.logout,

                                   
                                      title: 'Log Out',
                                      // subtitle: 'Return To Login',
                                      showArrow: false,
                                      onTap: () {
                                        Get.dialog(
                                          CustomDialogPop(title: "Log Out ?", message: "Are you sure you want to log out of your Snapid account?", svgPath: Assets.logout, isActionPopUp: true, onCancel: ()=> Get.back(), onPressed: ()=> Get.toNamed(PrimaryRoute.login))
                                        );
                                      },
                                    ),
                                    SpaceH90()
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
