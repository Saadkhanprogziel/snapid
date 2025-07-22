import 'package:get/get.dart';

class HistoryController extends GetxController {
  var selectedTab = 0.obs;

  void onTabChanged(int index) {
    print(index);
   selectedTab.value = index;
  }
  
}