import 'package:flutter/material.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/constant/strings.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/popular_country_card.dart';

class PopularCountries extends StatelessWidget {
  static const List<Map<String, dynamic>> _popularCountries = [
    {
      'name': Strings.unitedStates,
      'flag': 'assets/flags/us.svg',
      'passportSize': Strings.passportSizeUS,
    },
    {
      'name': Strings.unitedArabEmirates,
      'flag': 'assets/flags/ae.svg',
      'passportSize': Strings.passportSizeUAE,
    },
    {
      'name': Strings.unitedArabEmirates,
      'flag': 'assets/flags/ag.svg',
      'passportSize': Strings.passportSizeUAE,
    },
    {
      'name': Strings.unitedArabEmirates,
      'flag': 'assets/flags/ss.svg',
      'passportSize': Strings.passportSizeUAE,
    },
    {
      'name': Strings.unitedArabEmirates,
      'flag': 'assets/flags/sx.svg',
      'passportSize': Strings.passportSizeUAE,
    },
    {
      'name': Strings.unitedArabEmirates,
      'flag': 'assets/flags/vg.svg',
      'passportSize': Strings.passportSizeUAE,
    },
  ];
  const PopularCountries({super.key});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isMobile = deviceWidth <= 800;

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
          Padding(
            padding: EdgeInsets.all(isMobile ? 0 : 30), // ✅ fixed
            child: Column(
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
                            prefixIcon:
                                Icon(Icons.search, color: AppColors.grey),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile ? 1 : 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        mainAxisExtent: 220, // 🔑 fixed height
                      ),
                      itemCount: _popularCountries.length,
                      itemBuilder: (context, index) {
                        final country = _popularCountries[index];
                        return PopularCountryCard(
                          countryName: country['name'],
                          flagAsset: country['flag'],
                          passportSize: country['passportSize'],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
