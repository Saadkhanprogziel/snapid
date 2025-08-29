import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/controllers/dashboard/dashboard_controller.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_card.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';

class DashboardFragment extends StatefulWidget {
  const DashboardFragment({super.key});

  @override
  State<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {

    const double expandedHeight = 200;
    const double toolbarHeight = 100;
    const double collapseThreshold =
        expandedHeight - toolbarHeight - 20; // 80 with buffer

    bool shouldCollapse = _scrollController.hasClients &&
        _scrollController.offset > collapseThreshold;

    if (shouldCollapse != _isCollapsed) {
      setState(() {
        _isCollapsed = shouldCollapse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final PhotoController photoController = Get.find<PhotoController>();
    final DashboardController controller =
        Get.find<DashboardController>(); // 👈 don't re-put

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
          CustomScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                toolbarHeight: 100, // 👈 collapsed height

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          controller.user.value.profilePicture ??
                              'https://www.w3schools.com/howto/img_avatar2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: controller.credits != 0
                                  ? null
                                  : () {
                                      Fluttertoast.showToast(
                                          msg:
                                              "We're working on it! Credits purchase coming soon.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor:
                                              AppColors.solidCardColor,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                    },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white24.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  controller.credits == 0
                                      ? "Purchase Credits"
                                      : "${Strings.creditsRemaining}  ${controller.credits}",
                                  style: CustomTextTheme.regular14.copyWith(
                                    color: AppColors.whiteColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(PrimaryRoute.notification);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white24.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(
                                Assets.bellIcon,
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.headerbg),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        offset:
                            _isCollapsed ? const Offset(0, 0.3) : Offset.zero,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _isCollapsed ? 0 : 1,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Obx(
                              () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hello, ${controller.user.value.firstName ?? 'User'}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    Strings.welcomeBack,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Content Gap
              SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),

              // Upload/Take Photo Card
              SliverToBoxAdapter(
                child: Padding(
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: SizedBox(
                                            height: 50,
                                            width: double.infinity,
                                            child: CustomOutlineButton(
                                              onPressed: () {
                                                Get.toNamed(
                                                    PrimaryRoute.selectedPhoto);
                                              },
                                              label: Strings.uploadPhoto,
                                              icon: Icons.file_upload_outlined,
                                              iconColor: AppColors.whiteColor,
                                              textColor: AppColors.whiteColor,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: SizedBox(
                                            height: 50,
                                            width: double.infinity,
                                            child: CustomElevatedButton(
                                              onPressed: () async {
                                                photoController
                                                    .capturePhotosSimple();
                                              },
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                      style: CustomTextTheme.regular14.copyWith(
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
              ),

              // Gap before Most Popular section
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),

              // Most Popular Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
              ),

              // Gap before horizontal list
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),

              // Horizontal Country Cards List
              SliverToBoxAdapter(
                child: Container(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 20),
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
                      SizedBox(width: 20), // End padding
                    ],
                  ),
                ),
              ),

              // Bottom spacing
              SliverPadding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 30),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
