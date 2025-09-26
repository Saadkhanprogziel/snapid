import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/popular_countries/popular_countries_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/popular_country_card.dart';

class PopularCountries extends StatelessWidget {
  const PopularCountries({super.key});

  @override
  Widget build(BuildContext context) {
    final PopularCountriesController controller = Get.put(PopularCountriesController());
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
            padding: EdgeInsets.all(isMobile ? 0 : 30),
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
                        child: Obx(() => TextField(
                          controller: controller.searchController,
                          cursorColor: AppColors.whiteColor,
                          style: TextStyle(color: AppColors.whiteColor),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: AppColors.grey),
                            suffixIcon: controller.searchQuery.value.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: AppColors.grey),
                                    onPressed: controller.clearSearch,
                                  )
                                : null,
                            labelText: 'Search country',
                            labelStyle: TextStyle(color: AppColors.grey),
                            hintStyle: CustomTextTheme.regular14
                                .copyWith(color: AppColors.whiteColor),
                            border: InputBorder.none,
                          ),
                        )),
                      ),
                      SpaceH20(),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value && controller.countries.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                        ),
                      );
                    }

                    if (controller.countries.isEmpty && !controller.isLoading.value) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              controller.searchQuery.value.isNotEmpty 
                                  ? Icons.search_off 
                                  : Icons.public_off,
                              size: 64,
                              color: AppColors.grey,
                            ),
                            SpaceH20(),
                            Text(
                              controller.searchQuery.value.isNotEmpty
                                  ? "No countries found for '${controller.searchQuery.value}'"
                                  : "No countries found",
                              textAlign: TextAlign.center,
                              style: CustomTextTheme.regular16.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                            if (controller.searchQuery.value.isNotEmpty) ...[
                              SpaceH20(),
                              ElevatedButton(
                                onPressed: controller.clearSearch,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.cardColor,
                                  foregroundColor: AppColors.whiteColor,
                                ),
                                child: Text("Clear Search"),
                              ),
                            ],
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: controller.refreshCountries,
                      color: AppColors.whiteColor,
                      backgroundColor: AppColors.cardColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomScrollView(
                          controller: controller.scrollController,
                          slivers: [
                            // Search results header
                            if (controller.searchQuery.value.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: AppColors.grey,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Results for '${controller.searchQuery.value}'",
                                        style: CustomTextTheme.regular14.copyWith(
                                          color: AppColors.grey,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "${controller.countries.length} found",
                                        style: CustomTextTheme.regular14.copyWith(
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final country = controller.countries[index];
                                  return PopularCountryCard(
                                    countryName: country.name,
                                    flagAsset: country.flag,
                                    passportSize: country.passportSize,
                                    visaSize: country.visaSize,
                                    drivingLicense: country.drivingLicense,
                                  );
                                },
                                childCount: controller.countries.length,
                              ),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isMobile ? 1 : 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                mainAxisExtent: 220,
                              ),
                            ),
                            // Loading indicator at bottom
                            if (controller.isLoadingMore.value)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Loading more countries...",
                                          style: CustomTextTheme.regular12.copyWith(
                                            color: AppColors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            // End of data indicator
                            if (!controller.hasMoreData.value && controller.countries.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          color: AppColors.grey,
                                          size: 24,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          controller.searchQuery.value.isNotEmpty
                                              ? "All matching countries loaded"
                                              : "You've reached the end",
                                          style: CustomTextTheme.regular14.copyWith(
                                            color: AppColors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            // Extra space at bottom
                            SliverToBoxAdapter(
                              child: SizedBox(height: 20),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}