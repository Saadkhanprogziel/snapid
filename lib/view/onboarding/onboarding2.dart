import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';

class Onboarding3 extends StatefulWidget {
  const Onboarding3({super.key});

  @override
  State<Onboarding3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.onboard3),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                child: Image.asset(Assets.logo),
              ),
              Spacer(),

            SizedBox(
               width: 160, // Set desired width
               child: CustomElevatedButton(
                 onPressed: () => Get.toNamed(PrimaryRoute.login),
                 text: "Get Started",
                 icon: Icon(Icons.arrow_forward,color: AppColors.whiteColor,),
                 iconOnRight: true,
               ),
             ),
             
              
            ],
          ),
        ),
      ),
    );
  }
}
