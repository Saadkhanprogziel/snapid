import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/controllers/dashboard/dashboard_controller.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/utlis/custom_bullets.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_card.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/image_with_icon.dart';

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
    const double collapseThreshold = expandedHeight - toolbarHeight - 20;

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
    final DashboardController controller = Get.find<DashboardController>();

    return LayoutBuilder(builder: (context, constraints) {
      final double deviceWidth = MediaQuery.of(context).size.width;
      bool isMobile = deviceWidth <= 800;
      bool isDesktop = deviceWidth < 1200;
      print("$deviceWidth $isMobile");
      final List<String> guidelineImages = [
        'assets/images/correct_image_1.jpg',
        'assets/images/correct_image_1.jpg',
        'assets/images/correct_image_1.jpg',
        'assets/images/correct_image_1.jpg',
        'assets/images/correct_image_1.jpg',
        'assets/images/correct_image_1.jpg',
      ];

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
                !isMobile
                    ? SliverToBoxAdapter(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          margin: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Obx(
                                  () => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hello, ${controller.user.value.firstName ?? 'User'}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        Strings.welcomeBackDesktop,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SpaceW20(),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SvgPicture.asset(Assets.bellIcon),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : SliverAppBar(
                        expandedHeight: 200,
                        pinned: true,
                        stretch: true,
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        toolbarHeight: 100,
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
                                      'https:://www.w3schools.com/howto/img_avatar2.png',
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
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
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
                                          color:
                                              Colors.white24.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          controller.credits == 0
                                              ? "Purchase Credits"
                                              : "${Strings.creditsRemaining}  ${controller.credits}",
                                          style: CustomTextTheme.regular14
                                              .copyWith(
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
                                offset: _isCollapsed
                                    ? const Offset(0, 0.3)
                                    : Offset.zero,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: _isCollapsed ? 0 : 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Obx(
                                      () => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                if(isMobile) 
                SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                ),
                SliverToBoxAdapter(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double cardHeight = 420;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: cardHeight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 12, sigmaY: 12),
                                      child: Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: AppColors.cardColor,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "For best results, choose a well lit photo showing your full face and both ears.",
                                              textAlign: TextAlign.center,
                                              style: CustomTextTheme.regular16
                                                  .copyWith(
                                                color: AppColors.whiteColor,
                                                height: 1.3,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 120,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.3),
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          photoController
                                                              .capturePhotosSimple();
                                                        },
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                16),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .camera_alt_outlined,
                                                              color: AppColors
                                                                  .whiteColor,
                                                              size: 28,
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                            Text(
                                                              "Take a Photo",
                                                              style:
                                                                  CustomTextTheme
                                                                      .regular16
                                                                      .copyWith(
                                                                color: AppColors
                                                                    .whiteColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Container(
                                                    height: 120,
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end:
                                                            Alignment.bottomRight,
                                                        colors: [
                                                          Color(0xFF6366F1),
                                                          Color(0xFF8B5CF6),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Get.toNamed(PrimaryRoute
                                                              .selectedPhoto);
                                                        },
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                16),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .cloud_upload_outlined,
                                                              color: Colors.white,
                                                              size: 28,
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                            Text(
                                                              "Upload Photo",
                                                              style:
                                                                  CustomTextTheme
                                                                      .regular16
                                                                      .copyWith(
                                                                color:
                                                                    Colors.white,
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
                                            // const SizedBox(height: 30),
                                            BulletList(
                                              fontWeight: FontWeight.w400,
                                              items: [
                                                "Use a neutral expression",
                                                "Avoid glasses, hats, and shadows",
                                                "Background doesn't matter (we'll remove it)",
                                              ],
                                            ),
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
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                  ),
                                                  child: Text(
                                                    Strings.photoGuidelines,
                                                    style: CustomTextTheme
                                                        .regular14
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
                            ),
                            if(kIsWeb && !isDesktop)
                            Expanded(
                              child: SizedBox(
                                height: cardHeight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        color: AppColors.cardColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              "Photo Guidelines",
                                              textAlign: TextAlign.center,
                                              style: CustomTextTheme.regular16
                                                  .copyWith(
                                                color: AppColors.whiteColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ImageWithIcon(
                                                imagePath:
                                                    'assets/images/correct_image_1.jpg',
                                                icon: Icons.check_circle,
                                                iconColor: Colors.green,
                                              ),
                                              const SizedBox(width: 12),
                                              ImageWithIcon(
                                                imagePath:
                                                    'assets/images/correct_image_1.jpg',
                                                icon: Icons.check_circle,
                                                iconColor: Colors.green,
                                              ),
                                              const SizedBox(width: 12),
                                              ImageWithIcon(
                                                imagePath:
                                                    'assets/images/correct_image_1.jpg',
                                                icon: Icons.check_circle,
                                                iconColor: Colors.green,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ImageWithIcon(
                                                imagePath:
                                                    'assets/images/correct_image_1.jpg',
                                                icon: Icons.close,
                                                iconColor: Colors.redAccent,
                                              ),
                                              const SizedBox(width: 12),
                                              ImageWithIcon(
                                                imagePath:
                                                    'assets/images/correct_image_1.jpg',
                                                icon: Icons.close,
                                                iconColor: Colors.redAccent,
                                              ),
                                              const SizedBox(width: 12),
                                              ImageWithIcon(
                                                imagePath:
                                                    'assets/images/correct_image_1.jpg',
                                                icon: Icons.close,
                                                iconColor: Colors.redAccent,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
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
                SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
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
                          countryName: "Antigua & Barbuda",
                          flagAsset: 'assets/flags/ag.svg',
                          passportSize: Strings.passportSizeUAE,
                        ),
                        SizedBox(width: 16),
                        CountryCard(
                          countryName: "South Sudan",
                          flagAsset: 'assets/flags/ss.svg',
                          passportSize: Strings.passportSizeUAE,
                        ),
                        SizedBox(width: 16),
                        CountryCard(
                          countryName: "Sint Maarten",
                          flagAsset: 'assets/flags/sx.svg',
                          passportSize: Strings.passportSizeUAE,
                        ),
                        SizedBox(width: 16),
                        CountryCard(
                          countryName: "British Virgin Islands",
                          flagAsset: 'assets/flags/vg.svg',
                          passportSize: Strings.passportSizeUAE,
                        ),
                        SizedBox(width: 16),
                        CountryCard(
                          countryName: "United States",
                          flagAsset: 'assets/flags/us.svg',
                          passportSize: Strings.passportSizeUS,
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
