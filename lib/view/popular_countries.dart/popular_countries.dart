import 'package:flutter/material.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/popular_country_card.dart';

class PopularCountries extends StatelessWidget {
  const PopularCountries({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.appBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              SafeArea(
                child: CustomHeader(
                  title: "Popular Countries",
                  showBackButton: true,
                ),
              ),
              SpaceH10(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      child: TextField(
                        cursorColor: AppColors.whiteColor,
                        style: TextStyle(color: AppColors.whiteColor),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: AppColors.grey),
                          labelText: 'Search country',
                          labelStyle: TextStyle(color: AppColors.grey),
                          hintStyle: CustomTextTheme.regular14
                              .copyWith(color: AppColors.whiteColor),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // Handle input change
                        },
                      ),
                    ),
                    SpaceH20(),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    PopularCountryCard(
                      countryName: Strings.unitedStates,
                      flagAsset: 'assets/flags/us.svg',
                      passportSize: Strings.passportSizeUS,
                    ),
                    SpaceH15(),
                    PopularCountryCard(
                      countryName: Strings.unitedArabEmirates,
                      flagAsset: 'assets/flags/ae.svg',
                      passportSize: Strings.passportSizeUAE,
                    ),
                    SpaceH15(),
                    PopularCountryCard(
                      countryName: Strings.unitedArabEmirates,
                      flagAsset: 'assets/flags/ag.svg',
                      passportSize: Strings.passportSizeUAE,
                    ),
                    SpaceH15(),
                    PopularCountryCard(
                      countryName: Strings.unitedArabEmirates,
                      flagAsset: 'assets/flags/ss.svg',
                      passportSize: Strings.passportSizeUAE,
                    ),
                    SpaceH15(),
                    PopularCountryCard(
                      countryName: Strings.unitedArabEmirates,
                      flagAsset: 'assets/flags/sx.svg',
                      passportSize: Strings.passportSizeUAE,
                    ),
                    SpaceH15(),
                    PopularCountryCard(
                      countryName: Strings.unitedArabEmirates,
                      flagAsset: 'assets/flags/vg.svg',
                      passportSize: Strings.passportSizeUAE,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
