import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/routes/routes.dart';
// import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/message_popup.dart';

class ResetPassowrd extends StatelessWidget {
  const ResetPassowrd({super.key});

  @override
  Widget build(BuildContext context) {
    const fillColor = Color.fromRGBO(255, 255, 255, 0.05);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              Assets.appBg,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "Create a New Password",
                      style: CustomTextTheme.headingLarge
                          .copyWith(fontSize: 32, color: AppColors.whiteColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Choose a strong password to secure your account.",
                      textAlign: TextAlign.center,
                      style: CustomTextTheme.regular16.copyWith(
                        color: Colors.white70,
                        // fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: fillColor,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18), // makes height ~55
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: fillColor,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18), // makes height ~55
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomElevatedButton(onPressed: () async{
                   Get.dialog(
                        CustomMessagePopUp(
                          title: 'Password Updated',
                          message:
                              'Your password has been reset successfully. You can now log in with your new credentials.',
                        ),
                        barrierDismissible: false,
                      );
                      await Future.delayed(Duration(milliseconds: 1300), () {
                        Get.back(); 
                      });

                      Get.offNamed(PrimaryRoute.login);


                },
                text: "Reset Password",)
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
