import 'package:get/get.dart';
import 'package:snapid/main.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/routes/routes.dart';

class SplashController extends GetxController {
  AuthRespository authRespository = AuthRespository();

  @override
  void onInit() {
    super.onInit();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() async {
    bool biometricEnabled = appStorage.read("biometric_enabled") ?? false;
    final token = appStorage.read("token") ?? "";

    if (token.isNotEmpty) {
      if (biometricEnabled) {
        // Navigate to login where biometric auth will be handled
        Get.offNamed(PrimaryRoute.login, arguments: {"biometric": true});
      } else {
        // Normal flow → fetch user details and go home
        await authRespository.getUserDetails().then((response) => response.fold(
              (error) {
                Get.snackbar("Error", error);
                update();
              },
              (success) {
                
                Get.offNamed(PrimaryRoute.home, arguments: {'index': 0});
              },
            ));
        // Get.offNamed(PrimaryRoute.login,);
      }
    } else {
      final onBoarded = appStorage.read("onBoarded") ?? false;
      if (onBoarded) {
        Get.offNamed(PrimaryRoute.login);
      } else {
        Get.offNamed(PrimaryRoute.onBoard);
      }
    }
  }
}

