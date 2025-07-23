import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/dashboard/dashboard_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_card.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';

class DashboardFragment extends StatefulWidget {
  @override
  State<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  final DashboardController controller = Get.put(DashboardController());

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
          Column(
            children: [
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 70, bottom: 30),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.headerbg),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://www.w3schools.com/howto/img_avatar2.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white24.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Credits Remaining: 03",
                                    style: CustomTextTheme.regular14
                                        .copyWith(color: AppColors.whiteColor),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white24.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SvgPicture.asset(
                                    Assets.bellIcon,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Obx(() {
                          return Visibility(
                            visible: controller.showGreeting.value,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  "Hello, John! 👋",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Welcome back! Let's get your next\nphoto ready in just a few steps.",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(20, 223, 222,
                                    222), // Light translucent color
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Text("Upload or Take a Photo",
                                        style: CustomTextTheme.regular18
                                            .copyWith(
                                                color: AppColors.whiteColor)),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                child:
                                                    Image.asset(Assets.sample1),
                                              ),
                                              SizedBox(height: 12),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: OutlinedButton.icon(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                        Icons
                                                            .file_upload_outlined,
                                                        color: AppColors
                                                            .whiteColor),
                                                    label: Text(
                                                      "Upload Photo",
                                                      style: CustomTextTheme
                                                          .regular14
                                                          .copyWith(
                                                        color: AppColors
                                                            .whiteColor,
                                                      ),
                                                    ),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 15),
                                                      side: const BorderSide(
                                                          color:
                                                              Colors.white24),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                child:
                                                    Image.asset(Assets.sample2),
                                              ),
                                              SizedBox(height: 12),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: CustomElevatedButton(
                                                    onPressed: () {},
                                                    text: "Take Photo",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          child: SvgPicture.asset(
                                            Assets.hintIcon,
                                            height: 14,
                                            width: 14,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Photo Guidelines",
                                            style: CustomTextTheme.regular14
                                                .copyWith(
                                                    color:
                                                        AppColors.whiteColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Most Popular',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'View All →',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              height: 220,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: const [
                                  CountryCard(
                                    countryName: 'United State',
                                    flagAsset: 'assets/images/us.png',
                                    passportSize: '3.5 x 4.5 Cm',
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: 'United Arab Emirates',
                                    flagAsset: 'assets/images/us.png',
                                    passportSize: '4.3 x 5.5 Cm',
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: 'United Arab Emirates',
                                    flagAsset: 'assets/images/us.png',
                                    passportSize: '4.3 x 5.5 Cm',
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: 'United Arab Emirates',
                                    flagAsset: 'assets/images/us.png',
                                    passportSize: '4.3 x 5.5 Cm',
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: 'United Arab Emirates',
                                    flagAsset: 'assets/images/us.png',
                                    passportSize: '4.3 x 5.5 Cm',
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: 'United Arab Emirates',
                                    flagAsset: 'assets/images/us.png',
                                    passportSize: '4.3 x 5.5 Cm',
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: 'United Arab Emirates',
                                    flagAsset: 'assets/images/us.png',
                                    passportSize: '4.3 x 5.5 Cm',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 80), // Bottom padding
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
