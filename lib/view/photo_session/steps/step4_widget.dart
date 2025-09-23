import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
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
              : kIsWeb ? SizedBox.shrink(): Center(
                  child: SingleChildScrollView(
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
                            setState(() {
                              selectedPlan = "Standard";
                              selectedPrice = "\$6.99";
                            });
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
                            setState(() {
                              selectedPlan = "Smart Pack";
                              selectedPrice = "\$14.99";
                            });
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
                            setState(() {
                              selectedPlan = "Family Pack";
                              selectedPrice = "\$19.99";
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),

        // Payment method section - always present, expandable
        if (!widget.controller.canDownload.value || kIsWeb) Column(
          children: [
            _buildPaymentMethodSection(),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header - always visible
          GestureDetector(
            onTap: () {
              setState(() {
                isPaymentExpanded = !isPaymentExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    isPaymentExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Choose Payment Method",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (isPaymentExpanded) ...[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Cards section
                  Text(
                    "Payment Cards",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: 12),

                  // Payment method icons
                  Row(
                    children: [
                      _buildPaymentIcon(Icons.credit_card, Colors.blue),
                      SizedBox(width: 8),
                      _buildPaymentIcon(Icons.credit_card, Colors.lightBlue),
                      SizedBox(width: 8),
                      _buildPaymentIcon(Icons.paypal, Colors.blue[800]!),
                      SizedBox(width: 8),
                      _buildPaymentIcon(Icons.credit_card, Colors.red),
                      SizedBox(width: 8),
                      _buildPaymentIcon(Icons.credit_card, Colors.orange),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Card number field
                  Text(
                    "Card number",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: cardNumberController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "0000 0000 0000 0000",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 16),

                  // Expiry and CVV row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expire date",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: expiryController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "MM/YY",
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CVV/CVC",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: cvvController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "000",
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomElevatedButton(onPressed: () {
                        _processPayment();
                        Get.toNamed(PrimaryRoute.photo_preview);
                      },text: "Pay Now",minHeight: 65,)),
                ],
              ),
            ),
          ],
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

  void _processPayment() {
    // Add your payment processing logic here
    print("Processing payment for $selectedPlan - $selectedPrice");
    print("Card: ${cardNumberController.text}");
    print("Expiry: ${expiryController.text}");
    print("CVV: ${cvvController.text}");

   
    Get.snackbar(
      "Payment",
      "Processing payment for $selectedPlan",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
