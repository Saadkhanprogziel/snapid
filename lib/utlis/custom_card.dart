import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/utils_fucntions.dart';
import 'package:snapid/main.dart'; // Needed to read appStorage

class CountryCard extends StatelessWidget {
  final String countryName;
  final String flagAsset;
  final String passportSize;
  final String visaSize;
  final String drivingLicense;

  const CountryCard({
    super.key,
    required this.countryName,
    required this.flagAsset,
    required this.passportSize,
    required this.visaSize,
    required this.drivingLicense,
  });


 
  String _formatSize(String sizeStr) {
    final parts = sizeStr.split(',');
    if (parts.length != 2) return sizeStr;

    final widthPx = double.tryParse(parts[0].trim()) ?? 0;
    final heightPx = double.tryParse(parts[1].trim()) ?? 0; 

    final selectedUnit = appStorage.read("unit") ?? "cm";

    final widthConverted = UtilsFunc.convertUnits(widthPx);
    final heightConverted = UtilsFunc.convertUnits(heightPx);

    final unitLabel = (selectedUnit == "in" || selectedUnit == "inch" || selectedUnit == "inches")
        ? "in"
        : "cm";

    return "${widthConverted.toStringAsFixed(1)} × ${heightConverted.toStringAsFixed(1)} $unitLabel";
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: flagAsset,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              countryName,
              style: CustomTextTheme.regular16.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildSizeRow('Passport:', _formatSize(passportSize)),
            _buildSizeRow('Visa:', _formatSize(visaSize)),
            _buildSizeRow('Driving License:', _formatSize(drivingLicense)),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: CustomTextTheme.regular12.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: CustomTextTheme.regular12.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
