import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String id;
  final int photoCount;
  final String price;
  final String description;
  final String savings;
  final bool isPopular;
  final Color bgColor;
  final VoidCallback onBuy;
  final PhotoController controller;

  const SubscriptionCard({
    Key? key,
    required this.id,
    required this.title,
    required this.photoCount,
    required this.price,
    required this.description,
    required this.savings,
    required this.isPopular,
    required this.onBuy,
    required this.controller,
    this.bgColor = AppColors.primaryColor,  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0), // Extra space for the badge
      child: Stack(
        clipBehavior: Clip.none, // important to allow overflow!
        children: [
          Obx(() {
            final bool isSelected = controller.selectedPackage.value == id;
            
            return GestureDetector(
              onTap: () {
                          print(controller.selectedPackage.value);
                controller.selectedPackage.value = id;

              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 140,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primaryColor 
                      : (isPopular ? null : Colors.grey[900]),
                  image: isPopular && !isSelected
                      ? DecorationImage(
                          image: AssetImage('assets/images/skinprimary.png'),
                          fit: BoxFit.cover,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected 
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: isSelected ? Colors.white24 : Colors.black38,
                      blurRadius: isSelected ? 15 : 10,
                      spreadRadius: isSelected ? 2 : 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "$photoCount Photos",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      price,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (savings.isEmpty) SpaceH20(),
                    if (savings.isNotEmpty) ...[
                      SizedBox(
                        height: 20,
                        child: Text(
                          savings,
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                    ],
                    // SizedBox(height: 10),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     controller.selectedPackage.value = title;
                    //     onBuy();
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: isSelected ? Colors.yellow[700] : Colors.white,
                    //     foregroundColor: isSelected ? Colors.black : Colors.black,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    //   child: Text(isSelected ? "Selected" : "Buy it"),
                    // ),
                    SizedBox(height: 10),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (isPopular)
            Positioned(
              top: -12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    "POPULAR",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}