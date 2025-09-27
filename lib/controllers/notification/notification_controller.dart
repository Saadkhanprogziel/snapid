import 'package:get/get.dart';

class NotificationController extends GetxController {
  var selectedTab = 0.obs;
 var allNotifications = [].obs; // Add this line
  void onTabChanged(int index) {
    print(index);
   selectedTab.value = index;
  }
  
}