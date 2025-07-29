import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/home/home_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/view/assistant_fragment/assistant.dart';
import 'package:snapid/view/dashboard_fragment/dashboard_fragment.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapid/view/history_fragment/history_fragment.dart';
import 'package:snapid/view/profile_fragment/profile_fragment.dart';
// import 'dashboard_screen.dart';
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

 final List<Widget> _screens = [
  DashboardFragment(), 
  HistoryFragment(),  
  AssistantFragment(),
  ProfileFragment(),    
];


  @override
  Widget build(BuildContext context) {
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
}
