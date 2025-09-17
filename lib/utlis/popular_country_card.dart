import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class PopularCountryCard extends StatelessWidget {
  final String countryName;
  final String flagAsset;
  final String passportSize;

  const PopularCountryCard({
    super.key,
    required this.countryName,
    required this.flagAsset,
    required this.passportSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Center( // ✅ centers the Row inside the card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ center horizontally
          crossAxisAlignment: CrossAxisAlignment.center, // ✅ center vertically
          children: [
            Container(
              width: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // ✅ vertical center
                crossAxisAlignment: CrossAxisAlignment.center, // ✅ horizontal center
                children: [
                  SvgPicture.asset(flagAsset, height: 40, width: 40),
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
                mainAxisAlignment: MainAxisAlignment.center, // ✅ center vertically
                crossAxisAlignment: CrossAxisAlignment.center, // ✅ center horizontally
                children: [
                  _infoRow('Passport:', passportSize),
                  const SizedBox(height: 12),
                  _infoRow('Visa:', passportSize),
                  const SizedBox(height: 12),
                  _infoRow('Driving License:', passportSize),
                  const SizedBox(height: 12),
                  _infoRow('8G Color:', passportSize),
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
