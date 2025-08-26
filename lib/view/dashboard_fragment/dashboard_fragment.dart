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
          CustomScrollView(
            controller: controller.scrollController,
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
                      width: 55,
                      height: 55,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
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
                              onTap:controller.credits == 0 ? null:  (){
                                print("Tap Test");
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white24.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(controller.credits == 0 ? "Purchase Credits":
                                  "${Strings.creditsRemaining}  ${controller.credits}",
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

                // 🔹 Flexible space with background switching
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    // check if collapsed
                    final collapsed =
                        constraints.biggest.height <= kToolbarHeight + 20;

                    return Container(
                      decoration: BoxDecoration(
                        color: collapsed
                            ? Colors.black.withOpacity(
                                0.6) // 👈 collapsed background color
                            : null,
                        image: collapsed
                            ? null
                            : DecorationImage(
                                image: AssetImage(Assets.headerbg),
                                fit: BoxFit.cover,
                              ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!collapsed) // 👈 show greeting only when expanded
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Obx(
                                () => AnimatedGreeting(
                                  userName: controller.user.value.firstName ?? "",
                                  visible: controller.showGreeting.value,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
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
                    bottom: MediaQuery.of(context).padding.bottom + 80),
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
  final String userName;
  const AnimatedGreeting({required this.visible, required this.userName, super.key});

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
          const SizedBox(height: 0),
          Text(
            "Hello, ${widget.userName.isEmpty ? 'User' : widget.userName}!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
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