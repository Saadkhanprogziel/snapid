import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final int photoCount;
  final String price;
  final String description;
  final String savings;
  final bool isPopular;
  final Color bgColor;

  const SubscriptionCard({
    required this.title,
    required this.photoCount,
    required this.price,
    required this.description,
    required this.savings,
    required this.isPopular,
    this.bgColor = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0), // Extra space for the badge
      child: Stack(
        clipBehavior: Clip.none, // important to allow overflow!

        children: [
          Container(
            width: 140,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPopular ? null : Colors.grey[900], // dark grey fallback
              image: isPopular
                  ? DecorationImage(
                      image: AssetImage('assets/images/skinprimary.png'),
                      fit: BoxFit.cover,
                    )
                  : null,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10,
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
                if(savings.isEmpty)
                SpaceH20(),
                if (savings.isNotEmpty) ...[
                  SizedBox(height: 20, child: Text(
                    savings,
                    style: TextStyle(color: Colors.white60),
                  ),
                  
                  ),
                ],
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Buy it"),
                ),
                SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          if (isPopular)
            Positioned(
              top: -12,
              left: 0,
              right: 0,
              child: Center(
                // Center instead of Align to avoid ParentData conflict
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
