import 'package:get/get.dart';
import 'package:snapid/controllers/auth/forgot_password_controller.dart';
import 'package:snapid/controllers/biometric/biometric._controller.dart';
import 'package:snapid/controllers/dashboard/dashboard_controller.dart';
import 'package:snapid/controllers/history/history_controller.dart';
import 'package:snapid/controllers/home/home_controller.dart';
import 'package:snapid/controllers/notification/notification_controller.dart';

import 'package:snapid/controllers/onboarding/onbording_controller.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/controllers/security_settting/security_setting_controller.dart';
import 'package:snapid/controllers/splash/splash.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => OnBoardingController());
    Get.lazyPut(() => HistoryController());
    Get.lazyPut(() => NotificationController());
    Get.lazyPut(() => PhotoController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ForgotPasswordController());
    Get.lazyPut(() => SecuritySettingController());
    Get.lazyPut<DashboardController>(() => DashboardController());

    Get.lazyPut<BiometricController>(() => BiometricController(), fenix: true);
  }
}
