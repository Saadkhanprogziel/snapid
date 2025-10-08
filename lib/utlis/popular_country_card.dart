import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/main.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/utils_fucntions.dart';

class PopularCountryCard extends StatelessWidget {
  final String countryName;
  final String flagAsset;
  final String passportSize;
  final String? visaSize;
  final String? drivingLicense;

  const PopularCountryCard({
    super.key,
    required this.countryName,
    required this.flagAsset,
    required this.passportSize,
    this.visaSize,
    this.drivingLicense,
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                 flagAsset.isNotEmpty ? CachedNetworkImage(imageUrl: flagAsset) : Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SpaceH15(),
                  Text(
                    countryName,
                    textAlign: TextAlign.center,
                    style: CustomTextTheme.regular16.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            SpaceW12(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _infoRow('Passport:', _formatSize(passportSize)),
                  const SizedBox(height: 12),
                  _infoRow('Visa:', _formatSize(passportSize)),
                  const SizedBox(height: 12),
                  _infoRow('Driving License:', _formatSize(passportSize) ),
                  const SizedBox(height: 12),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

 

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Text(
            label,
            style: CustomTextTheme.regular12.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: CustomTextTheme.regular12.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}