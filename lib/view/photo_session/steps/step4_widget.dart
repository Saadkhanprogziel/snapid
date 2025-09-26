import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_stripe_web/card_field.dart';
// import 'package:flutter_stripe_web/card_field.dart';
// import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/controllers/stripe_controller/stripe_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_text_field.dart';
import 'package:snapid/utlis/subscription_card.dart';
import 'package:snapid/view/photo_session/cached_image.dart';

class Step4Widget extends StatefulWidget {
  final PhotoController controller;

  const Step4Widget({super.key, required this.controller});

  @override
  State<Step4Widget> createState() => _Step4WidgetState();
}

class _Step4WidgetState extends State<Step4Widget> {
  bool isPaymentExpanded = false;
  String selectedPlan = '';
  String selectedPrice = '';
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  StripeController? stripeController;
  bool isStripeInitialized = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initializeStripe();
    }
  }

  Future<void> _initializeStripe() async {
    try {
      stripeController = Get.put(StripeController());
      // Wait for Stripe to be properly initialized
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          isStripeInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing Stripe: $e');
      // Handle initialization error
      if (mounted) {
        Get.snackbar(
          "Error",
          "Failed to initialize payment system. Please refresh the page.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceH40(),
        widget.controller.processedWatermarkedUrl.value.isEmpty
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
                      imageUrl:
                          widget.controller.processedWatermarkedUrl.value),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
          child: Center(
            child: Text(
              widget.controller.canDownload.value
                  ? "Use the Available Credits to Download The Processed Image."
                  : "Download Both Files After Payment.",
              textAlign: TextAlign.center,
              style: CustomTextTheme.regular20
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
            ),
          ),
        ),

        // Subscription cards or download button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: widget.controller.canDownload.value
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomElevatedButton(
                    minHeight: 60,
                    onPressed: () {
                      print(widget.controller.sessionId.value);
                      widget.controller
                          .downloadImageById(widget.controller.sessionId.value);
                    },
                    text: "Proceed to Download",
                  ),
                )
              : Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SubscriptionCard(
                          id: "816814a8-fe33-4c4f-8432-3f29c8c14782",
                          title: "Standard",
                          photoCount: 1,
                          price: "\$6.99",
                          description: "Perfect for one time",
                          isPopular: false,
                          savings: "",
                          controller: widget.controller, // Add this line
                          onBuy: () {
                            // Handle buy action for Standard package
                          },
                        ),
                        SizedBox(width: 8),
                        SubscriptionCard(
                          id:  "63e39c54-5d74-4afd-8c98-b1af702bf613",
                          title: "Smart Pack",
                          photoCount: 3,
                          price: "\$14.99",
                          description: "Perfect for three photos",
                          isPopular: true,
                          savings: "Save - 28 %",
                          controller: widget.controller, // Add this line
                          onBuy: () {
                            // Handle buy action for Smart Pack
                          },
                        ),
                        SizedBox(width: 8),
                        SubscriptionCard(
                          id: "d3ff3d1c-a0f4-4898-b741-ad21c6d32cca",
                          title: "Family Pack",
                          photoCount: 5,
                          price: "\$19.99",
                          description: "Ideal for families or agencies",
                          isPopular: false,
                          savings: "Save - 43 %",
                          controller: widget.controller, // Add this line
                          onBuy: () {
                            // Handle buy action for Family Pack
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),

        if (!widget.controller.canDownload.value || kIsWeb)
          _buildPaymentMethodSection(widget.controller),
      ],
    );
  }

  Widget _buildPaymentMethodSection(PhotoController photocontroller) {
    if (!kIsWeb) {
      // For non-web platforms, return a different payment UI or empty container
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "Payment processing is only available on web platform",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!isStripeInitialized) {
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 8),
              Text(
                "Initializing payment system...",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (stripeController == null) {
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              "Payment system failed to initialize",
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _initializeStripe,
              child: Text("Retry"),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Container(
          //   margin: const EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Container(
          //         margin:
          //             EdgeInsets.only(top: 12, bottom: 15, left: 20, right: 20),
          //         // height: 50,
          //         child: WebCardField(
          //           style: CardStyle(),
          //           controller: stripeController!.cardEditController,
          //         ),
          //       ),
          //       SpaceH10(),
          //       TextFormField(
          //         controller: stripeController!.email,
          //         decoration: InputDecoration(
          //           label: Text("Email"),
          //           labelStyle: TextStyle(color: Colors.grey.shade500),
          //           contentPadding:
          //               EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          //           enabledBorder: OutlineInputBorder(
          //             borderSide:
          //                 BorderSide(color: Colors.grey.shade300, width: 1),
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           focusedBorder: OutlineInputBorder(
          //             borderSide:
          //                 BorderSide(color: Colors.grey.shade300, width: 1),
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //         ),
          //         validator: (value) {
          //           if (value == null || value.isEmpty) {
          //             return 'Please enter your email or phone number';
          //           }
          //           if (GetUtils.isEmail(value)) {
          //             return null;
          //           }
          //           return 'Enter a valid email or phone number';
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          // SpaceH20(),
          // Obx(
          //   () => stripeController!.isStripeLoading.value
          //       ? CircularProgressIndicator(color: Colors.white)
          //       : SizedBox(
          //           width: 200,
          //           child: CustomElevatedButton(
          //               onPressed: () {
          //                 if(photocontroller.selectedPackage.value.isEmpty){
          //                   Get.snackbar("Error", "Please select a subscription plan",
          //                       backgroundColor: Colors.red,
          //                       colorText: Colors.white);
          //                   return;
          //                 }
          //                 stripeController?.createPaymentMethodWeb();
          //               },
          //               text: "Make Payment"),
          //         ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPaymentIcon(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }
}
