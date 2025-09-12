import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/home/home_controller.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/view/assistant_fragment/assistant.dart';
import 'package:snapid/view/dashboard_fragment/dashboard_fragment.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapid/view/history_fragment/history_fragment.dart';
import 'package:snapid/view/profile_fragment/profile_fragment.dart';

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

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isMobile = deviceWidth <= 800;

    if (!isMobile) {
      return Scaffold(
        body: Row(
          children: [
            Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: isExpanded.value ? 250 : 80,
                  color: Colors.black,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: isExpanded.value
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                          children: [
                            if (isExpanded.value)
                              const Text(
                                'SnapID',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            IconButton(
                              onPressed: () => isExpanded.toggle(),
                              icon: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryColor),
                                child: Icon(
                                  isExpanded.value
                                      ? Icons.arrow_back_ios_rounded
                                      : Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          children: [
                            buildExpandableNavItem('assets/icons/home.svg',
                                'Home', 0, isExpanded.value),
                            buildExpandableNavItem('assets/icons/clock.svg',
                                'History', 1, isExpanded.value),
                            buildExpandableNavItem('assets/icons/assistant.svg',
                                'Assistant', 2, isExpanded.value),
                            buildExpandableNavItem('assets/icons/profile.svg',
                                'Profile', 3, isExpanded.value),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: Obx(() => _screens[controller.selectedIndex.value]),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      body: Obx(() => _screens[controller.selectedIndex.value]),
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
                buildNavBarItem('assets/icons/home.svg', 'Home', 0),
                buildNavBarItem('assets/icons/clock.svg', 'History', 1),
                const SizedBox(width: 20),
                buildNavBarItem('assets/icons/assistant.svg', 'Assistant', 2),
                buildNavBarItem('assets/icons/profile.svg', 'Profile', 3),
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

  Widget buildExpandableNavItem(
      String svgPath, String label, int index, bool expanded) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Material(
          color: isSelected
              ? const Color.fromARGB(75, 121, 97, 255)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
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

  Widget buildNavBarItem(String svgPath, String label, int index) {
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
