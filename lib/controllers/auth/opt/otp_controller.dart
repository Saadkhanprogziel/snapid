import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  final RxList<RxBool> filledFields = List.generate(6, (_) => false.obs).obs;
  final secondsRemaining = 30.obs;
  late bool isPasswordForgot;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
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
    secondsRemaining.value = 30;
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
    for (var controller in controllers) {
      controller.dispose();
    }
    timer?.cancel();
    super.onClose();
  }
}
