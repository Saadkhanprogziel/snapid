
import 'package:get/get.dart';
import 'package:snapid/controllers/history/history_controller.dart';
import 'package:snapid/controllers/notification/notification_controller.dart';


import 'package:snapid/controllers/onboarding/onbording_controller.dart';
import 'package:snapid/controllers/photoController/photo_controller.dart';
import 'package:snapid/controllers/splash/splash.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => OnBoardingController());
    Get.lazyPut(() => HistoryController());
    Get.lazyPut(() => NotificationController());
    Get.lazyPut(() => PhotoController());
    // Get.lazyPut(() => UserRegisterController());
    // Get.lazyPut(() => RegisterProfileController());
    // Get.lazyPut(() => LoginController());
    // Get.lazyPut(() => ForgotPasswordController());
    // Get.lazyPut(() => DashboardController());
   
  }
}
