import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/onboarding/onbording_controller.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';

import 'package:snapid/view/onboarding/components/gb_dot_indicator.dart';

class OnBoardingView extends GetView<OnBoardingController> {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.appBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: controller.pageController,
              itemCount: controller.pages.length,
              onPageChanged: (index) {
                controller.setCurrentPage(index);
              },
              itemBuilder: (context, index) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 350,
                        width: 350,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              controller.pages[index]['image']!,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        return GBDotIndicator(
                          itemCount: controller.pages.length,
                          currentIndex: controller.currentPage.value,
                          activeColor: AppColors.primaryColor,
                          inactiveColor: Colors.white,
                        );
                      }),
                      const SizedBox(height: 20),
                      Text(
                        controller.pages[index]['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          controller.pages[index]['subtitle']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Buttons at the bottom (fixed)
            Positioned(
              bottom: 30,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button (conditionally hidden)
                  Obx(() {
                    return Visibility(
                      visible: !controller.isLastPage,
                      child: TextButton(
                        onPressed: () {
                          controller.goToLastPage();
                        },
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }),

                  // Next button (always visible)
                  SizedBox(
                    height: 54,
                    width: 54,
                    child: CustomElevatedButton(onPressed: (){
                      controller.goToNextPage();
                    },icon: Icon(
                        Icons.arrow_forward,
                        size: 26,
                        color: AppColors.whiteColor,
                      ),),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
