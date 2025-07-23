import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/message_popup.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  late bool isPasswordForgot;

  int secondsRemaining = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    isPasswordForgot = args?['isPasswordForgot'] ?? false;
    startTimer();

    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus && controllers[i].text.isNotEmpty) {
          controllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: controllers[i].text.length,
          );
        }
      });
    }
  }

  void startTimer() {
    secondsRemaining = 30;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (secondsRemaining == 0) {
        t.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    timer?.cancel();
    super.dispose();
  }

  void handleInput(String value, int index) {
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  Widget buildOtpBox(int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: controllers[index].text.isNotEmpty
            ? Border.all(color: Colors.deepPurpleAccent)
            : Border.all(color: Colors.transparent),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        onChanged: (value) {
          setState(() {});
          handleInput(value, index);
        },
        style: TextStyle(color: Colors.white, fontSize: 24),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Assets.appBg, // Replace with your actual image path
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Text(
                        "Verify Your Identity",
                        style: CustomTextTheme.headingLarge.copyWith(
                            fontSize: 32, color: AppColors.whiteColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Select how you'd like to receive \nthe verification code.",
                        textAlign: TextAlign.center,
                        style: CustomTextTheme.regular16.copyWith(
                          color: Colors.white70,
                          // fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) => buildOtpBox(index)),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      Get.dialog(
                        CustomMessagePopUp(
                          title: 'Verified Successfully!',
                          message:
                              'Your account has been verified. You\'re all set to start using SnapID.',
                        ),
                        barrierDismissible: false,
                      );
                     await Future.delayed(Duration(milliseconds: 1300), () {
                        Get.back(); // Close the popup
                      });
                      if(isPasswordForgot){
                        Get.toNamed(PrimaryRoute.resetPassword);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(60),
                    ),
                    child: Text(
                      isPasswordForgot ? "Verify" : "Verify & Continue",
                      style: CustomTextTheme.regular16
                          .copyWith(color: AppColors.whiteColor),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      Get.toNamed(PrimaryRoute.verification);
                    },
                    icon: Icon(Icons.sync, color: Colors.white54, size: 18),
                    label: Text(
                      "Change Method",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: "Didn't receive the code?\n",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      children: [
                        TextSpan(
                          text: secondsRemaining > 0
                              ? "Resend in ${secondsRemaining}s"
                              : "Resend",
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
