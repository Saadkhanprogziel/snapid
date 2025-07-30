import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/controllers/dashboard/dashboard_controller.dart';
import 'package:snapid/controllers/photoController/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_card.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';

class DashboardFragment extends StatelessWidget {
  const DashboardFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    final PhotoController photoController = Get.find<PhotoController>();

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
                alignment: Alignment.topCenter,
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: Container(
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
                                    Strings.creditsRemaining,
                                    style: CustomTextTheme.regular14.copyWith(
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(PrimaryRoute.notification);
                                  },
                                  child: Container(
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
                                ),
                              ],
                            ),
                          ],
                        ),
                        Obx(() => AnimatedGreeting(
                            visible: controller.showGreeting.value)),
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
                                color: AppColors.cardColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      Strings.uploadOrTakePhoto,
                                      style: CustomTextTheme.regular18.copyWith(
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(Assets.sample1),
                                              SizedBox(height: 12),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: CustomOutlineButton(
                                                    onPressed: () {
                                                      Get.toNamed(PrimaryRoute
                                                          .selectedPhoto);
                                                    },
                                                    label: Strings.uploadPhoto,
                                                    icon: Icons
                                                        .file_upload_outlined,
                                                    iconColor:
                                                        AppColors.whiteColor,
                                                    textColor:
                                                        AppColors.whiteColor,
                                                    borderColor: Colors.white24,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(Assets.sample2),
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
                                                    text: Strings.takePhoto,
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
                                            Strings.photoGuidelines,
                                            style: CustomTextTheme.regular14
                                                .copyWith(
                                              color: AppColors.whiteColor,
                                            ),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Strings.mostPopular,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(PrimaryRoute.popularCountires);
                                  },
                                  child: Text(
                                    Strings.viewAll,
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
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
                                    countryName: Strings.unitedStates,
                                    flagAsset: 'assets/flags/us.svg',
                                    passportSize: Strings.passportSizeUS,
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: Strings.unitedArabEmirates,
                                    flagAsset: 'assets/flags/ae.svg',
                                    passportSize: Strings.passportSizeUAE,
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: Strings.unitedArabEmirates,
                                    flagAsset: 'assets/flags/ag.svg',
                                    passportSize: Strings.passportSizeUAE,
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: Strings.unitedArabEmirates,
                                    flagAsset: 'assets/flags/ss.svg',
                                    passportSize: Strings.passportSizeUAE,
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: Strings.unitedArabEmirates,
                                    flagAsset: 'assets/flags/sx.svg',
                                    passportSize: Strings.passportSizeUAE,
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: Strings.unitedArabEmirates,
                                    flagAsset: 'assets/flags/vg.svg',
                                    passportSize: Strings.passportSizeUAE,
                                  ),
                                  SizedBox(width: 16),
                                  CountryCard(
                                    countryName: Strings.unitedArabEmirates,
                                    flagAsset: 'assets/flags/us.svg',
                                    passportSize: Strings.passportSizeUAE,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 80),
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

class AnimatedGreeting extends StatefulWidget {
  final bool visible;
  const AnimatedGreeting({required this.visible, super.key});

  @override
  State<AnimatedGreeting> createState() => _AnimatedGreetingState();
}

class _AnimatedGreetingState extends State<AnimatedGreeting>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (widget.visible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedGreeting oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      widget.visible ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axisAlignment: -1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            Strings.helloUser,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            Strings.welcomeBack,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
