import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/notification/notification_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_notification_cart.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_tabbar.dart';
import 'package:snapid/utlis/empty_data_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        controller.onTabChanged(_tabController.index);
      }
    });

    // Keep TabController in sync with controller
    controller.selectedTab.listen((index) {
      if (_tabController.index != index) {
        _tabController.animateTo(index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SpaceH10(),
                _buildCustomTabBar(),
                const SpaceH20(),
                _buildTabBarView(),
              ],
            ),
          ),
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
              "Notification",
              style: CustomTextTheme.regular24
                  .copyWith(color: AppColors.whiteColor),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildPopupMenu(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Padding(
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
                    () => TabBarWidget(
                      tabs: ['All ', 'Success', 'Reminders'],
                      selectedIndex: controller.selectedTab.value,
                      onTabSelected: (index) {
                        controller.onTabChanged(index);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildAllTab(),
          _buildEmptyTab(),
          _buildEmptyTab(),
        ],
      ),
    );
  }

  Widget _buildAllTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        NotificationCard(
          icon: Icons.check,
          imagePath: Assets.tick,
          iconBackgroundColor: const Color.fromRGBO(0, 143, 0, 1),
          glowColor: const Color.fromRGBO(20, 162, 20, 0.709),
          title: "Success",
          message:
              "Your photo for “US Passport” has been processed and is ready to download.",
          onPressed: () {},
        ),
        SpaceH12(),
        NotificationCard(
          endDate: "Aug 30, 2025",
          isReminder: true,
          icon: Icons.check,
          imagePath: Assets.reminder,
          iconBackgroundColor: const Color.fromARGB(201, 213, 114, 33),
          glowColor: const Color.fromARGB(255, 208, 93, 0),
          title: "Reminder",
          daysLeft: "2 Days Left",
          message:
              "Your photo order will expire in 2 days. Be sure to download it.",
          onPressed: () {},
        )
      ],
    );
  }

  Widget _buildEmptyTab() {
    return EmptyDataWidget(
      imagePath: Assets.historIcon,
      title: "You are all caught up!",
      subtitle:
          "We’ll notify you when your photos are processed or about to expire!",
      buttonTitle: "Start a new photo",
      onPressed: () {},
    );
  }

  PopupMenuButton<String> _buildPopupMenu() {
    return PopupMenuButton<String>(
      color: const Color.fromARGB(194, 46, 46, 46),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (value) => print('Selected: $value'),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildMenuItem(Icons.file_download_outlined, 'Re-Download', 'redownload'),
        _buildDivider(),
        _buildMenuItem(Icons.replay, 'Reuse Setting', 'reuse_setting'),
        _buildDivider(),
        _buildMenuItem(Icons.delete, 'Delete', 'delete'),
      ],
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(181, 46, 46, 46),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.more_vert, color: Colors.white),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      IconData icon, String text, String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  PopupMenuDivider _buildDivider() => const PopupMenuDivider(height: 1);
}
