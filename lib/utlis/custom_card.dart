import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';

class CountryCard extends StatelessWidget {
  final String countryName;
  final String flagAsset;
  final String passportSize;

  const CountryCard({
    super.key,
    required this.countryName,
    required this.flagAsset,
    required this.passportSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: AppColors.cardColor, // Light translucent color
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
                  color: Colors.white, // Optional: background color
                ),
                clipBehavior: Clip.antiAlias,
                child: SvgPicture.asset(
                  flagAsset,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(countryName,
                  style: CustomTextTheme.regular16
                      .copyWith(color: AppColors.whiteColor)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Passport:',
                      style: CustomTextTheme.regular12.copyWith(
                          color: Colors.white70, fontWeight: FontWeight.w400)),
                  Text('$passportSize',
                      style: CustomTextTheme.regular12.copyWith(
                          color: Colors.white70, fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Visa:',
                      style: CustomTextTheme.regular12.copyWith(
                          color: Colors.white70, fontWeight: FontWeight.w400)),
                  Text('$passportSize',
                      style: CustomTextTheme.regular12.copyWith(
                          color: Colors.white70, fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Driving License:',
                      style: CustomTextTheme.regular12.copyWith(
                          color: Colors.white70, fontWeight: FontWeight.w400)),
                  Text('$passportSize',
                      style: CustomTextTheme.regular12.copyWith(
                          color: Colors.white70, fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('8G Color',
                      style: CustomTextTheme.regular12.copyWith(
                          color: Colors.white70, fontWeight: FontWeight.w400)),
                  Text('$passportSize',
                      style: CustomTextTheme.regular12.copyWith(
                          color: Colors.white70, fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
