import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';

import 'package:snapid/controllers/notification/notification_controller.dart';

import 'package:snapid/utlis/custom_header.dart';
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
                CustomHeader(
                  title: "Notifications",
                  showBackButton: true,
                  rightWidget: _buildPopupMenu(),
                ),
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

  Widget _buildCustomTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(20, 223, 222, 222),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Obx(
                  () => TabBarWidgetFlexible(
                    tabs: ['All ', 'Read', 'Unread'],
                    selectedIndex: controller.selectedTab.value,
                    onTabSelected: (index) {
                      controller.onTabChanged(index);
                    },
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
    return Obx(() {
      // Check if notifications list is empty
      if (controller.allNotifications.isEmpty) {
        return _buildEmptyNotificationsWidget();
      }
      
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.allNotifications.length,
        itemBuilder: (context, index) {
          final notification = controller.allNotifications[index];
          return Column(
            children: [
              NotificationCard(
                endDate: notification.endDate,
                isReminder: notification.isReminder,
                icon: notification.icon,
                imagePath: notification.imagePath,
                iconBackgroundColor: notification.iconBackgroundColor,
                glowColor: notification.glowColor,
                title: notification.title,
                daysLeft: notification.daysLeft,
                message: notification.message,
                onPressed: () {},
              ),
              if (index < controller.allNotifications.length - 1) SpaceH12(),
            ],
          );
        },
      );
    });
  }

  Widget _buildEmptyNotificationsWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              "No Notifications",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "You're all caught up! We'll notify you when your photos are processed or about to expire.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTab() {
    return EmptyDataWidget(
      imagePath: Assets.historIcon,
      title: "You are all caught up!",
      subtitle:
          "We'll notify you when your photos are processed or about to expire!",
      buttonTitle: "Start a new photo",
    );
  }

  PopupMenuButton<String> _buildPopupMenu() {
    return PopupMenuButton<String>(
      color: const Color.fromARGB(210, 46, 46, 46),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (value) => print('Selected: $value'),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildMenuItem(
            Icons.file_download_outlined, 'Re-Download', 'redownload'),
        _buildDivider(),
        _buildMenuItem(Icons.replay, 'Reuse Setting', 'reuse_setting'),
        _buildDivider(),
        _buildMenuItem(Icons.delete, 'Delete', 'delete'),
      ],
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(10),
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