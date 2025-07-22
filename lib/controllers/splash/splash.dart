
import 'package:get/get.dart';
import 'package:snapid/routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () async {
    
        Get.offAllNamed(PrimaryRoute.onBoard);
        // Get.offAllNamed(PrimaryRoute.dashboard);
        
      
    });
  }
}
