import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_spaces.dart';


class HistoryCustomCard extends StatelessWidget {
  final String imageUrl;
  final String country;
  final String date;
  final String status;
  final Color statusColor;
  final GestureTapDownCallback? onMoreTapDown;

  const HistoryCustomCard({
    super.key,
    required this.imageUrl,
    required this.country,
    required this.date,
    required this.status,
    required this.statusColor,
    this.onMoreTapDown,
  });
  

  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(20, 223, 222, 222),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Image
                  Container(
                    width: 130,
                    height: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              country,
                              style: CustomTextTheme.regular22
                                  .copyWith(color: AppColors.whiteColor),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "Created",
                                  style: CustomTextTheme.regular12
                                      .copyWith(color: AppColors.whiteColor),
                                ),
                                SpaceW10(),
                                Text(
                                  date,
                                  style: CustomTextTheme.regular12
                                      .copyWith(color: AppColors.whiteColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SpaceH20(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: CustomTextTheme.regular14
                                    .copyWith(color: AppColors.whiteColor),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Expire Within 7 days",
                              style: CustomTextTheme.regular12
                                  .copyWith(color: AppColors.whiteColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  PopupMenuButton<String>(
                    
                    color: const Color.fromARGB(194, 46, 46, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onSelected: (value) {
                      print('Selected: $value');
                      // Add your action logic here
                    },
                    popUpAnimationStyle: AnimationStyle(),
                    itemBuilder: (BuildContext context) =>
                     
                        <PopupMenuEntry<String>>[
                      _buildMenuItem(
                          Icons.file_download_outlined, 'Re-Download', 'redownload'),
                      _buildDivider(),
                      _buildMenuItem(
                          Icons.replay, 'Reuse Setting', 'reuse_setting'),
                      _buildDivider(),
                      _buildMenuItem(
                          Icons.delete, 'Delete', 'delete'),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(159, 46, 46, 46),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              SpaceH20(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(20, 223, 222, 222),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset(
                          Assets.globeIcon,
                          width: 15,
                        ),
                      ),
                      SpaceW10(),
                      Text(
                        "Passport",
                        style: CustomTextTheme.regular12
                            .copyWith(color: AppColors.whiteColor),
                      ),
                    ],
                  ),
                  Text(
                    "3.5 x 4.5 cm",
                    style: CustomTextTheme.regular12
                        .copyWith(color: AppColors.whiteColor),
                  ),
                ],
              )
            ],
          ),
        ),
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
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  PopupMenuDivider _buildDivider() {
    return const PopupMenuDivider(
      height: 1,
    );
  }
}
