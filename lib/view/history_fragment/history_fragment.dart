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
                                    tabs: ['All Orders', 'Credited', 'Processed'],
                                    selectedIndex: controller.selectedTab.value,
                                    onTabSelected: (index) {
                                      controller.onTabChanged(index);

                                      // ✅ Fetch history based on tab
                                      if (index == 0) {
                                        // controller.fetchHistory(status: "ALL");
                                      } else if (index == 1) {
                                        controller.fetchHistory(status: "CREDITED");
                                      } else {
                                        controller.fetchHistory(status: "IMAGE_PROCESSED");
                                      }
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
                        return Center(child: Text(controller.errorMessage.value));
                      }

                      if (controller.historyList.isEmpty) {
                        return EmptyDataWidget(
                          imagePath: Assets.historIcon,
                          title: "No Photo Orders Yet",
                          subtitle:
                              "Looks like you haven’t started yet. Tap below to create your first photo — it's quick and easy!",
                          buttonTitle: "Upload or Capture",
                          onPressed: () {
                            // handle action
                          },
                        );
                      }

                      // ✅ Render dynamic history list
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.historyList.length,
                        itemBuilder: (context, index) {
                          final item = controller.historyList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: HistoryCustomCard(
                              imageUrl: item.processedImageUrl ??
                                  item.processedWatermarkedUrl ??
                                  'https://via.placeholder.com/150',
                              country: item.countryName,
                              documentType: item.documentType,
                              date: formatDate(item.createdAt)  ,
                              status: item.status ?? '',
                              onDelete: () {
                                controller.delete(item.id);
                              },
                              statusColor: item.status == "CREDITED"
                                  ?
                                   Colors.orange.withValues(alpha: 0.6)
                                  :
                                   Colors.green.withValues(alpha: 0.5)
                            ),
                          );
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
