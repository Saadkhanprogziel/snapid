import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/screenBg.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackground(),
          Column(
            children: [
              SafeArea(
                  child: CustomHeader(
                showBackButton: true,
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpaceH20(),
                    Text(
                      "Choose Payment\nMethod",
                      style: CustomTextTheme.regular26.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w500),
                    ),
                    SpaceH20(),
                    GestureDetector(
                      onTap: () {
                        Get.snackbar("Working on it", "This Flow will be fixed during the INTEGRATION");
                        Get.toNamed(PrimaryRoute.home);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.2, color: AppColors.grey),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Assets.apple,
                                  width: 30,
                                ),
                                SpaceW4(),
                                Text("Pay",
                                    style: CustomTextTheme.regular22.copyWith(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            SpaceW20(),
                            Text("Apple Pay",
                                style: CustomTextTheme.regular18.copyWith(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                      ),
                    ),
                    SpaceH20(),
                      GestureDetector(
                      onTap: () {
                        Get.snackbar("Working on it", "This Flow will be fixed during the INTEGRATION");
                        Get.toNamed(PrimaryRoute.home);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.2, color: AppColors.grey),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Assets.google,
                                  width: 30,
                                ),
                                SpaceW4(),
                                Text("Pay",
                                    style: CustomTextTheme.regular22.copyWith(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            SpaceW20(),
                            Text("Google Pay",
                                style: CustomTextTheme.regular18.copyWith(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
