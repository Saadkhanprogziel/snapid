import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isNotificationOn = false.obs;

  void setNotification(val){
    isNotificationOn.value = val;
  }
}