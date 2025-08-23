import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/utlis/message_popup.dart';

class OtpController extends GetxController {
  AuthRespository authRepository = AuthRespository();
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> otp =
      List.generate(6, (_) => TextEditingController());

  final RxList<RxBool> filledFields = List.generate(6, (_) => false.obs).obs;
  final secondsRemaining = 60.obs;
  late bool isPasswordForgot;
  late String identifier;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    isPasswordForgot = args?['isPasswordForgot'] ?? false;
    identifier = args?['identifier'] ?? '';
    startTimer();

    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus && otp[i].text.isNotEmpty) {
          otp[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: otp[i].text.length,
          );
        }
      });
    }
  }

  
  void resendOtp() {
    authRepository.reSendOtp(identifier).then((response) => response.fold(
          (error) {
            Get.snackbar("Error", error);
          },
          (success) {
            Get.snackbar("Success", "OTP has been resent successfully");
            startTimer();
          },
        ));
    // if (secondsRemaining.value == 0) {
    //   // Call your resend OTP logic here
    //   startTimer();
    // }
  }


  void verifyOtp()  {
    final code = otp.map((controller) => controller.text).join();
    if (code.length < 6) {
      Get.snackbar("Error", "Please enter the complete OTP");
      return;
    }

    authRepository.verifyOtp(identifier: identifier, code: int.parse(code) ).then(
          (response) => response.fold(
            (error) {
              Get.snackbar("Error", error);
            },
            (success) async {
              if (isPasswordForgot) {
                Get.toNamed('/reset-password', arguments: {'email': identifier});
              } else {
                 Get.dialog(
                        CustomMessagePopUp(
                          title: 'Verified Successfully!',
                          message:
                              'Your account has been verified. You\'re all set to start using SnapID.',
                        ),
                        barrierDismissible: false,
                      );
                      await Future.delayed(const Duration(milliseconds: 1300));
                      Get.back();

                    
                Get.offAllNamed(PrimaryRoute.login);
              }
            },
          ),
        );
  }

  void startTimer() {
    secondsRemaining.value = 60;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (secondsRemaining.value == 0) {
        t.cancel();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  void handleInput(String value, int index) {
    filledFields[index].value = value.isNotEmpty;

    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  @override
  void onClose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in otp) {
      controller.dispose();
    }
    timer?.cancel();
    super.onClose();
  }
}
