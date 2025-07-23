import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';

import 'package:snapid/controllers/profile/profile_controller.dart';

import 'package:snapid/theme/text_theme.dart';
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
              SafeArea(child: _buildHeader()),
              // SpaceH40(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  // padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        27, 223, 222, 222), // Light translucent color
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Transform.translate(
                            offset: const Offset(0, -60),
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
                        ),
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
                            child: Obx(()
                               {
                                return Column(
                                  children: [
                                    buildSettingItem(
                                      icon: Icons.shopping_bag_outlined,
                                      title: 'My Orders',
                                      subtitle: 'View History And Manage Downloads',
                                    ),
                                    const SizedBox(height: 14),
                                    buildSettingItem(
                                      icon: Icons.straighten,
                                      title: 'Measurement Unit',
                                      subtitle: 'Set Your Preferred Unit.',
                                       onTap: () {
                                        print("Measurement Unit");
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    buildSettingItem(
                                      icon: Icons.lock_outline,
                                      title: 'Security Setting',
                                      subtitle: 'Update Account Security',
                                      onTap: () {
                                        print("Security Setting");
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    buildSettingItem(
                                      icon: Icons.notifications,
                                      title: 'Notification',
                                      subtitle: 'Receive updates via push/email.',
                                      isNotificationOn:
                                          controller.isNotificationOn.value,
                                      onNotificationToggle: (val) {
                                        controller.setNotification(val);
                                      },
                                    ),
                                    SpaceH90()
                                  ],
                                );
                              }
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              "Profile",
              style: CustomTextTheme.regular24
                  .copyWith(color: AppColors.whiteColor),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                color: const Color.fromARGB(20, 223, 222, 222),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(Assets.bellIcon),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isNotificationOn = false,
    ValueChanged<bool>? onNotificationToggle,
      VoidCallback? onTap,

  }) {
    return InkWell(
    onTap: title == "Notification" ? null : onTap, 
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(61, 82, 79, 112),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: CustomTextTheme.regular16
                          .copyWith(color: AppColors.whiteColor)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: CustomTextTheme.regular12
                          .copyWith(color: AppColors.grey)),
                ],
              ),
            ),
            title == "Notification"
                ? Switch(
                    value: isNotificationOn,
                    onChanged: onNotificationToggle,
                    activeColor: AppColors.primaryColor,

                  )
                : const Icon(Icons.arrow_forward_ios,
                    color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
