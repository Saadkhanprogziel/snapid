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

class DashboardFragment extends StatelessWidget {
  const DashboardFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final PhotoController photoController = Get.find<PhotoController>();
    final DashboardController controller = Get.find<DashboardController>();
    controller.initScrollController();

    return LayoutBuilder(builder: (context, constraints) {
      final double deviceWidth = MediaQuery.of(context).size.width;
      bool isMobile = deviceWidth <= 800;
      bool isDesktop = deviceWidth < 1200;

      return Stack(
        children: [
          CustomScrollView(
            key: PageStorageKey("dashboardScroll"),
            controller: controller.scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              !isMobile
                  ? SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        margin:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Obx(
                                () => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hello, ${controller.userName}",
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
                            Row(
                              children: [
                                Obx(
                                  () => Container(
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
                                SpaceW10(),
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
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  : _buildMobileSliverAppBar(controller),
              if (isMobile)
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 0 : 20.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
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
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: isMobile ? 10 : 50),
                                          child: Row(
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
                                                    color:
                                                        AppColors.primaryColor,
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
                                            
                                            if (isMobile) ...[
                                              GestureDetector(
                                                child: SvgPicture.asset(
                                                  Assets.hintIcon,
                                                  height: 14,
                                                  width: 14,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(208,
                                                                33, 33, 33),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Container(
                                                          width: 400,
                                                          child: kIsWeb
                                                              ? _photoGuideline(
                                                                  cardHeight)
                                                              : _photoGuideline(
                                                                  cardHeight),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
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
                                            ]
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (kIsWeb && !isDesktop) _photoGuideline(cardHeight),
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
                    child: Obx(() {
                      if (controller.countries.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: controller.countries.length,
                          scrollDirection: Axis.horizontal,
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(left: 20),
                          itemBuilder: (context, index) {
                            var country = controller.countries[index];
                            return Row(
                              children: [
                                CountryCard(
                                  countryName: country.name,
                                  flagAsset: country.flag,
                                  passportSize: country.passportSize,
                                  drivingLicense: country.drivingLicense,
                                  visaSize: country.visaSize,
                                ),
                                SizedBox(width: 16),
                              ],
                            );
                          });
                    })),
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 30,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildMobileSliverAppBar(DashboardController controller) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: 100,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Container(
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
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Obx(
                    () => GestureDetector(
                      onTap: controller.credits != 0
                          ? null
                          : () {
                              Fluttertoast.showToast(
                                  msg:
                                      "We're working on it! Credits purchase coming soon.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: AppColors.solidCardColor,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                            },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
            Obx(
              () => AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                offset: controller.isCollapsed.value
                    ? const Offset(0, 0.3)
                    : Offset.zero,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: controller.isCollapsed.value ? 0 : 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, ${controller.userName}",
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
    );
  }

  Widget _photoGuideline(cardHeight) {
    Widget content = SizedBox(
      height: cardHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Photo Guidelines",
                  textAlign: TextAlign.center,
                  style: CustomTextTheme.regular16.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageWithIcon(
                    imagePath: 'assets/images/correct_image_1.jpg',
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  ),
                  const SizedBox(width: 12),
                  ImageWithIcon(
                    imagePath: 'assets/images/correct_image_2.jpg',
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  ),
                  if (kIsWeb) ...[
                    const SizedBox(width: 12),
                    ImageWithIcon(
                      imagePath: 'assets/images/correct_image_3.jpg',
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                    ),
                  ]
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageWithIcon(
                    imagePath: 'assets/images/incorrect_image_1.jpg',
                    icon: Icons.close,
                    iconColor: Colors.redAccent,
                  ),
                  const SizedBox(width: 12),
                  ImageWithIcon(
                    imagePath: 'assets/images/incorrect_image_2.jpg',
                    icon: Icons.close,
                    iconColor: Colors.redAccent,
                  ),
                  if (kIsWeb) ...[
                    const SizedBox(width: 12),
                    ImageWithIcon(
                      imagePath: 'assets/images/incorrect_image_3.jpg',
                      icon: Icons.close,
                      iconColor: Colors.redAccent,
                    ),
                  ]
                ],
              )
            ],
          ),
        ),
      ),
    );

    return kIsWeb ? Expanded(child: content) : content;
  }
}
