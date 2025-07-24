import 'package:flutter/material.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class PhotoCreationScreen extends StatelessWidget {
  const PhotoCreationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _buildBodyData(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.appBg),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(Assets.headerbg),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SpaceH60(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStepText(),
                    _buildStepIndicator(),
                  ],
                ),
                const SpaceH60(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLineStepIndicator(currentStep: 1),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLineStepIndicator({int totalSteps = 4, int currentStep = 1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.white : Colors.white30,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBodyData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "For best results, choose a well-lit photo showing your full face and both ears.",
            textAlign: TextAlign.center,
            style: CustomTextTheme.regular20
                .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          SpaceH20(),
          Column(
            children: [
              CustomOutlineButton(
                onPressed: () {},
                label: "Take a Photo",
                icon: Icons.camera_alt_outlined,
                iconColor: AppColors.whiteColor,
                textColor: AppColors.whiteColor,
                minHeight: 60,
              ),
              SpaceH20(),
              CustomElevatedButton(
                onPressed: () {},
                text: "Upload from Gallery",
                minHeight: 60,
                icon: Icon(
                  Icons.upload,
                  color: AppColors.whiteColor,
                ),
                iconOnRight: false,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStepText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step 1",
          style:
              CustomTextTheme.regular26.copyWith(color: AppColors.whiteColor),
        ),
        Text(
          "Upload or Take a photo",
          style:
              CustomTextTheme.regular14.copyWith(color: AppColors.whiteColor),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white24.withAlpha(10),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        "1/4",
        style: CustomTextTheme.regular22.copyWith(color: AppColors.whiteColor),
      ),
    );
  }
}
