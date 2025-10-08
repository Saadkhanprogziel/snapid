import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_stripe_web/card_field.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/controllers/stripe_controller/stripe_controller.dart';
import 'package:snapid/main.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_dialog_pop.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/subscription_card.dart';
import 'package:snapid/view/photo_session/cached_image.dart';
import 'package:snapid/constant/colors.dart';

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

  StripeController? stripeController;
  bool isStripeInitialized = false;
  String? token;

  @override
  void initState() {
    super.initState();
    token = appStorage.read("token")?.toString();

    if (kIsWeb) {
      _initializeStripe();
    }
  }

  Future<void> _initializeStripe() async {
    if (!mounted) return;

    try {
      // Check if StripeController already exists
      if (Get.isRegistered<StripeController>()) {
        stripeController = Get.find<StripeController>();
      } else {
        stripeController = Get.put(StripeController());
      }

      // Wait for Stripe to be properly initialized
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          isStripeInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('❌ Error initializing Stripe: $e');

      if (mounted) {
        Get.snackbar(
          "Error",
          "Failed to initialize payment system. Please refresh the page.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildImageGrid(List<String> imageUrls) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.8,
      ),
      itemCount: imageUrls.length > 5 ? 5 : imageUrls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: imageUrls[index].isEmpty
              ? Container(
                  color: Colors.white10,
                  child: Image.asset(Assets.demoResult, fit: BoxFit.cover),
                )
              : CustomCachedImage(imageUrl: imageUrls[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceH40(),
            _buildImagePreview(),
            if (widget.controller.isUserLoading.value)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              _buildInstructionText(),
              _buildActionSection(),
              if (!widget.controller.canDownload.value && kIsWeb)
                _buildPaymentMethodSection(widget.controller),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildImagePreview() {
    return Obx(() {
      final imageUrl = widget.controller.processedWatermarkedUrl.value;
      final capturedImages = widget.controller.photoCreationModelData.value?.originalImages ?? [];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Before Images Grid
            Expanded(
              child: Column(
                children: [
                  Text(
                    "BEFORE",
                    style: CustomTextTheme.regular14.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 280,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: capturedImages.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              Assets.demoResult2,
                              fit: BoxFit.contain,
                            ),
                          )
                        : _buildImageGrid(capturedImages),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // After Image
            Expanded(
              child: Column(
                children: [
                  Text(
                    "AFTER",
                    style: CustomTextTheme.regular14.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primaryColor ,
                          width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl.isNotEmpty
                          ? CustomCachedImage(imageUrl: imageUrl)
                          : Image.asset(
                              Assets.demoResult2,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInstructionText() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
        child: Center(
          child: Text(
            widget.controller.canDownload.value
                ? "Use the Available Credits to Download The Processed Image."
                : "Download Both Files After Payment.",
            textAlign: TextAlign.center,
            style: CustomTextTheme.regular20.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildActionSection() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: _buildActionContent(),
      );
    });
  }

  Widget _buildActionContent() {
    // User has credits - show download button
    if (widget.controller.canDownload.value) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomElevatedButton(
          minHeight: 60,
          onPressed: () {
            Get.dialog(CustomDialogPop(
              title: 'Are you sure?',
              message:
                  'Downloading this will deduct credits from your account.',
              isIcon: false,
              iconData: Icons.check,
              iconColor: AppColors.whiteColor,
              isActionPopUp: true,
              solidBtnLabel: "Continue",
              onCancel: () => Get.back(),
              onPressed: () {
                _handleDownload();
              },
            ));
          },
          text: "Proceed to Download",
        ),
      );
    }

    // Guest user (no token) - hide subscription options
    if (token == null) {
      return const SizedBox.shrink();
    }

    // Logged in user without credits - show subscription options
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SubscriptionCard(
              id: "816814a8-fe33-4c4f-8432-3f29c8c14782",
              title: "Standard",
              photoCount: 1,
              price: "\$6.99",
              description: "Perfect for one time",
              isPopular: false,
              savings: "",
              controller: widget.controller,
              onBuy: () => _handleSubscriptionSelect("Standard", "\$6.99"),
            ),
            const SizedBox(width: 8),
            SubscriptionCard(
              id: "63e39c54-5d74-4afd-8c98-b1af702bf613",
              title: "Smart Pack",
              photoCount: 3,
              price: "\$14.99",
              description: "Perfect for three photos",
              isPopular: true,
              savings: "Save - 28 %",
              controller: widget.controller,
              onBuy: () => _handleSubscriptionSelect("Smart Pack", "\$14.99"),
            ),
            const SizedBox(width: 8),
            SubscriptionCard(
              id: "d3ff3d1c-a0f4-4898-b741-ad21c6d32cca",
              title: "Family Pack",
              photoCount: 5,
              price: "\$19.99",
              description: "Ideal for families or agencies",
              isPopular: false,
              savings: "Save - 43 %",
              controller: widget.controller,
              onBuy: () => _handleSubscriptionSelect("Family Pack", "\$19.99"),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDownload() {
    final sessionId = widget.controller.sessionId.value;

    if (sessionId.isEmpty) {
      Get.snackbar(
        "Error",
        "Session ID not found. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    debugPrint('📥 Downloading image with session ID: $sessionId');
    widget.controller.downloadImageById(sessionId);
  }

  void _handleSubscriptionSelect(String plan, String price) {
    setState(() {
      selectedPlan = plan;
      selectedPrice = price;
    });
    debugPrint('Selected plan: $plan at $price');
  }

  Widget _buildPaymentMethodSection(PhotoController photocontroller) {
    // if (!kIsWeb) {
    //   return _buildPlatformNotSupportedMessage();
    // }

    // if (!isStripeInitialized) {
    //   return _buildLoadingState();
    // }

    // if (stripeController == null) {
    //   return _buildErrorState();
    // }

    return Obx(() {
      if (widget.controller.canDownload.value) {
        return SizedBox.shrink();
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
            // _buildPaymentForm(),
            // const SpaceH20(),
            // _buildPaymentButton(photocontroller),
          ],
        ),
      );
    });
  }

  // Widget _buildPlatformNotSupportedMessage() {
  //   return Container(
  //     margin: const EdgeInsets.all(12),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: AppColors.cardColor,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: const Text(
  //       "Payment processing is only available on web platform",
  //       style: TextStyle(color: Colors.white),
  //       textAlign: TextAlign.center,
  //     ),
  //   );
  // }

  // Widget _buildLoadingState() {
  //   return Container(
  //     margin: const EdgeInsets.all(12),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: AppColors.cardColor,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: const Center(
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           CircularProgressIndicator(color: Colors.white),
  //           SizedBox(height: 8),
  //           Text(
  //             "Initializing payment system...",
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildErrorState() {
  //   return Container(
  //     margin: const EdgeInsets.all(12),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: AppColors.cardColor,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         const Text(
  //           "Payment system failed to initialize",
  //           style: TextStyle(color: Colors.red),
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: 8),
  //         ElevatedButton(
  //           onPressed: _initializeStripe,
  //           child: const Text("Retry"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildPaymentForm() {
  //   return Container(
  //     margin: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           margin:
  //               const EdgeInsets.only(top: 12, bottom: 15, left: 20, right: 20),
  //           child: WebCardField(
  //             style: CardStyle(),
  //             controller: stripeController!.cardEditController,
  //           ),
  //         ),
  //         const SpaceH10(),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //           child: TextFormField(
  //             controller: stripeController!.email,
  //             keyboardType: TextInputType.emailAddress,
  //             decoration: InputDecoration(
  //               labelText: "Email",
  //               labelStyle: TextStyle(color: Colors.grey.shade500),
  //               contentPadding:
  //                   const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
  //               enabledBorder: OutlineInputBorder(
  //                 borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               focusedBorder: OutlineInputBorder(
  //                 borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               errorBorder: OutlineInputBorder(
  //                 borderSide: const BorderSide(color: Colors.red, width: 1),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               focusedErrorBorder: OutlineInputBorder(
  //                 borderSide: const BorderSide(color: Colors.red, width: 2),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //             ),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please enter your email';
  //               }
  //               if (!GetUtils.isEmail(value)) {
  //                 return 'Enter a valid email address';
  //               }
  //               return null;
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildPaymentButton(PhotoController photocontroller) {
  //   return Obx(() {
  //     final isLoading = stripeController?.isStripeLoading.value ?? false;

  //     return isLoading
  //         ? const CircularProgressIndicator(color: Colors.white)
  //         : SizedBox(
  //             width: 200,
  //             child: CustomElevatedButton(
  //               onPressed: () => _handlePayment(photocontroller),
  //               text: "Make Payment",
  //             ),
  //           );
  //   });
  // }

  // void _handlePayment(PhotoController photocontroller) {
  //   if (token != null) {
  //     if (photocontroller.selectedPackage.value.isEmpty) {
  //       Get.snackbar(
  //         "Error",
  //         "Please select a subscription plan",
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //       return;
  //     }
  //   }

  //   // Validate email
  //   final email = stripeController?.email.text.trim() ?? '';
  //   if (email.isEmpty) {
  //     Get.snackbar(
  //       "Error",
  //       "Please enter your email address",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }

  //   if (!GetUtils.isEmail(email)) {
  //     Get.snackbar(
  //       "Error",
  //       "Please enter a valid email address",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }

  //   // Proceed with payment
  //   stripeController?.createPaymentMethodWeb();
  // }
}