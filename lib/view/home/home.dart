import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/home/home_controller.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/controllers/profile/profile_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_dialog_pop.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/view/assistant_fragment/assistant.dart';
import 'package:snapid/view/dashboard_fragment/dashboard_fragment.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapid/view/history_fragment/history_fragment.dart';
import 'package:snapid/view/profile_fragment/profile_fragment.dart';
import 'dart:io';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());
  final RxBool isExpanded = false.obs;

  final List<Widget> _screens = [
    DashboardFragment(),
    HistoryFragment(),
    AssistantFragment(),
    ProfileFragment(),
  ];

  // Handle back button press logic
  Future<void> _handleBackPress() async {
    if (controller.selectedIndex.value > 0) {
      // If not on first screen, go back to first screen
      controller.setIndex(0);
      return;
    } else {
      // If on first screen, show exit dialog
      Get.dialog(
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: CustomDialogPop(
            solidBtnLabel: "Exit",
            title: "Exit App?",
            message: "Do you really want to exit Snapid?",
            svgPath: Assets.logout,
            isActionPopUp: true,
            backgroundColor: AppColors.cardColor,
            onCancel: () => Get.back(),
            onPressed: () {
              Get.back(); // close dialog first
              // Exit the app
              Future.delayed(const Duration(milliseconds: 200), () {
                exit(0); // For mobile apps
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isMobile = deviceWidth <= 800;

    // Wrap the entire widget with PopScope for both mobile and desktop
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBackPress();
      },
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.appBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              Obx(
                () => ClipRRect(
                  child: AnimatedSize(
                    alignment: Alignment.topLeft,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear,
                    child: Container(
                      width: isExpanded.value ? 250 : 80,
                      color: AppColors.cardColor,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: isExpanded.value
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Obx(() {
                                    return Image.network(
                                      controller
                                              .user.value.profilePicture ??
                                          'https://www.w3schools.com/howto/img_avatar2.png',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.grey[600],
                                            size: 24,
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                                SpaceW10(),
                                if (isExpanded.value)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller.user.value.firstName ??
                                              'User',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          controller.user.value.email ??
                                              'user@example.com',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              children: [
                                ExpandableNavItem('assets/icons/home.svg',
                                    'Home', 0, isExpanded.value),
                                ExpandableNavItem('assets/icons/clock.svg',
                                    'History', 1, isExpanded.value),
                                ExpandableNavItem(
                                    'assets/icons/assistant.svg',
                                    'Assistant',
                                    2,
                                    isExpanded.value),
                                ExpandableNavItem(
                                    'assets/icons/profile.svg',
                                    'Profile',
                                    3,
                                    isExpanded.value),
                              ],
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              var profileController =
                                  Get.find<ProfileController>();

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
                                    backgroundColor: AppColors.cardColor,
                                    onCancel: () => Get.back(),
                                    onPressed: () {
                                      profileController.logout();
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.backBtnColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    Assets.logout,
                                    height: 20,
                                    width: 20,
                                    colorFilter: ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  if (isExpanded.value) ...[
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: AnimatedOpacity(
                                        duration: const Duration(
                                            milliseconds: 300),
                                        opacity:
                                            isExpanded.value ? 1.0 : 0.0,
                                        child: Text("Logout",
                                            style:
                                                CustomTextTheme.regular12),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          SpaceH20()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() => _screens[controller.selectedIndex.value]),
              ),
            ],
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: (isExpanded.value ? 250 : 85) - 20,
              top: 50,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: IconButton(
                  onPressed: () => isExpanded.toggle(),
                  icon: Icon(
                    isExpanded.value
                        ? Icons.arrow_back_ios_rounded
                        : Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      extendBody: true,
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
          Obx(() => _screens[controller.selectedIndex.value]),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(227, 18, 18, 18),
                Color(0xFF000000),
              ],
            ),
          ),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navBarItem('assets/icons/home.svg', 'Home', 0),
                navBarItem('assets/icons/clock.svg', 'History', 1),
                const SizedBox(width: 20),
                navBarItem('assets/icons/assistant.svg', 'Assistant', 2),
                navBarItem('assets/icons/profile.svg', 'Profile', 3),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(117, 104, 76, 243),
                blurRadius: 2,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: Material(
              color: AppColors.primaryColor,
              elevation: 10,
              child: InkWell(
                onTap: () {
                  Get.toNamed(PrimaryRoute.photo_creation);
                  PhotoController photoController = Get.put(PhotoController());
                  photoController.initializeFromNavigation();
                },
                child: const SizedBox(
                  width: 70,
                  height: 70,
                  child: Icon(
                    CupertinoIcons.add,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget ExpandableNavItem(
      String svgPath, String label, int index, bool expanded) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Material(
          color: isSelected
              ? const Color.fromARGB(75, 121, 97, 255)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (index == 2) {
                Get.toNamed(PrimaryRoute.assistant);
              } else {
                controller.setIndex(index);
              }
            },
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SvgPicture.asset(
                    svgPath,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      isSelected ? const Color(0xFF7861FF) : Colors.white70,
                      BlendMode.srcIn,
                    ),
                  ),
                  if (expanded) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: expanded ? 1.0 : 0.0,
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF7861FF)
                                : Colors.white70,
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget navBarItem(String svgPath, String label, int index) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;

      return InkWell(
        onTap: () {
          if (index == 2) {
            Get.toNamed(PrimaryRoute.assistant);
          } else {
            controller.setIndex(index);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? const Color(0xFF7861FF) : Colors.white70,
                BlendMode.srcIn,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF7861FF) : Colors.white70,
              ),
            ),
          ],
        ),
      );
    });
  }

  NavigationRailDestination buildNavDestination(String svgPath, String label) {
    return NavigationRailDestination(
      icon: SvgPicture.asset(
        svgPath,
        height: 24,
        width: 24,
        color: Colors.white70,
      ),
      selectedIcon: SvgPicture.asset(
        svgPath,
        height: 24,
        width: 24,
        color: const Color(0xFF7861FF),
      ),
      label: Text(label),
    );
  }
}