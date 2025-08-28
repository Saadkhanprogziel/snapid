import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/subscription_card.dart';
import 'package:snapid/view/photo_session/cached_image.dart';

class Step4Widget extends StatelessWidget {
  final PhotoController controller;

  const Step4Widget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceH40(),
        controller.processedWatermarkedUrl.value.isEmpty
            ? Center(
                child: Container(
                  width: 350,
                  height: 250,
                  child: Image.asset(Assets.demoResult2),
                ),
              )
            : Center(
                child: Container(
                  width: 230,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomCachedImage(
                      imageUrl: controller.processedWatermarkedUrl.value),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
          child: Text(
            controller.canDownload.value
                ? "Use the Available Credits to Download The Processed Image."
                : "Download Both Files After Payment.",
            textAlign: TextAlign.center,
            style: CustomTextTheme.regular20
                .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        // if controller.canDownload is true then show a download button other wise following subscription cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: controller.canDownload.value
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomElevatedButton(
                    minHeight: 60,
                    onPressed: () {
                      print(controller.sessionId.value);
                      // controller.downloadImageById(controller.sessionId.value);
                    },
                    text: "Proceed to Download",
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SubscriptionCard(
                        title: "Standard",
                        photoCount: 1,
                        price: "\$6.99",
                        description: "Perfect for one time",
                        isPopular: false,
                        savings: "",
                        onBuy: () {
                          Get.toNamed(PrimaryRoute.payment_method);
                        },
                      ),
                      SizedBox(width: 8),
                      SubscriptionCard(
                        title: "Smart Pack",
                        photoCount: 3,
                        price: "\$14.99",
                        description: "Perfect for three photos",
                        isPopular: true,
                        savings: "Save - 28 %",
                        onBuy: () {
                          Get.toNamed(PrimaryRoute.payment_method);
                        },
                      ),
                      SizedBox(width: 8),
                      SubscriptionCard(
                        title: "Family Pack",
                        photoCount: 5,
                        price: "\$19.99",
                        description: "Ideal for families or agencies",
                        isPopular: false,
                        savings: "Save - 43 %",
                        onBuy: () {
                          Get.toNamed(PrimaryRoute.payment_method);
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
