import 'package:get/get.dart';
import 'package:snapid/controllers/auth/forgot_password_controller.dart';
import 'package:snapid/controllers/auth/login/login_controller.dart';
import 'package:snapid/controllers/biometric/biometric._controller.dart';
import 'package:snapid/controllers/dashboard/dashboard_controller.dart';
import 'package:snapid/controllers/history/history_controller.dart';
import 'package:snapid/controllers/home/home_controller.dart';
import 'package:snapid/controllers/notification/notification_controller.dart';

import 'package:snapid/controllers/onboarding/onbording_controller.dart';
import 'package:snapid/controllers/photoSession/photo_controller.dart';
import 'package:snapid/controllers/profile/profile_controller.dart';
import 'package:snapid/controllers/security_settting/security_setting_controller.dart';
import 'package:snapid/controllers/splash/splash.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(),fenix: true);
    Get.lazyPut(() => OnBoardingController());
    Get.lazyPut(() => NotificationController());
    Get.lazyPut(() => PhotoController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ForgotPasswordController());
    Get.lazyPut(() => SecuritySettingController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => HistoryController(), fenix: false);
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);

    Get.lazyPut<BiometricController>(() => BiometricController(), fenix: true);
  }
}
