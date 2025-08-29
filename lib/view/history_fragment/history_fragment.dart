import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/history/history_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_history_card.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_tabbar.dart';
import 'package:snapid/utlis/empty_data_widget.dart';

class HistoryFragment extends StatelessWidget {
  const HistoryFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.find<HistoryController>();

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
                  title: "History",
                  leftIconPath: Assets.asistantIcon,
                  rightIconPath: Assets.bellIcon,
                  onLeftIconTap: () {
                    print("left Icon tap");
                  },
                  onRightIconTap: () {
                    Get.toNamed(PrimaryRoute.notification);
                  },
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
                                color: AppColors.cardColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Obx(
                                () {
                                  return TabBarWidget(
                                    tabs: [
                                      'All Orders',
                                      'Credited',
                                      'Processed'
                                    ],
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
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.errorMessage.isNotEmpty) {
                        return RefreshIndicator(
                          onRefresh: () => controller.refreshHistory(),
                          child: ListView(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.6,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        controller.errorMessage.value,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "Pull down to refresh",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (controller.historyList.isEmpty) {
                        return EmptyDataWidget(
                          imagePath: Assets.historIcon,
                          title: "No Photo Orders Yet",
                          subtitle:
                              "Looks like you haven't started yet. Tap below to create your first photo — it's quick and easy!",
                          buttonTitle: "Upload or Capture",
                          onPressed: () {
                            Get.toNamed(PrimaryRoute.photo_creation);
                          },
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () => controller.refreshHistory(),
                        child: ListView.builder(
                          controller: controller.scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: controller.historyList.length +
                              (controller.hasMoreData.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Show loading indicator at the bottom when loading more data
                            if (index == controller.historyList.length) {
                              return Obx(() {
                                if (controller.isLoadingMore.value) {
                                  return const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              });
                            }

                            final item = controller.historyList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: HistoryCustomCard(
                                photoCreationModel: item,
                                controller: controller,
                                
                                onDelete: () {
                                  controller.delete(item.id);
                                },
                               
                              ),
                            );
                          },
                        ),
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

  String formatDate(String? dateString, {String pattern = 'yyyy-MM-dd'}) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat(pattern).format(dateTime);
    } catch (e) {
      return dateString; // fallback in case parsing fails
    }
  }
}
