import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/main.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/routes/routes.dart';

class SplashController extends GetxController {
  AuthRespository authRespository = AuthRespository();

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () async {
      final token = appStorage.read("token") ?? "";
      print(token);

      if (token.isNotEmpty) {
        await authRespository
            .getUserDetails()
            .then((response) => response.fold((error) {
                  Get.snackbar("Error", error);
                 
                  update();
                }, (success) {
                  Get.offAllNamed(PrimaryRoute.home, arguments: {'index': 0});
                }));
        // Get.offAllNamed(PrimaryRoute.home, arguments: {'index': 0});
      } else {
        final onBoarded = appStorage.read("onBoarded") ?? false;
        if (onBoarded) {
          Get.offAllNamed(PrimaryRoute.login);
        } else {
          Get.offAllNamed(PrimaryRoute.onBoard);
        }
      }
    });
  }
}
