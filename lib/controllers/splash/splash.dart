import 'package:get/get.dart';
import 'package:snapid/main.dart';
import 'package:snapid/routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () async {
      final token = appStorage.read("accessToken")?.toString() ?? "";

     
      if (token.isNotEmpty) {
        // User is logged in, navigate to dashboard
        Get.offAllNamed(PrimaryRoute.home, arguments: {'index': 0});
      } else {
        // User is not logged in, navigate to onboarding
        Get.offAllNamed(PrimaryRoute.onBoard);
      }

      Get.offAllNamed(PrimaryRoute.onBoard);
      // Get.offAllNamed(PrimaryRoute.dashboard);
    });

  }
}
