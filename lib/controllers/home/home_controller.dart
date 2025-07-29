import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;

  void setIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    final args = Get.arguments;
    if (args != null && args['index'] is int) {
      selectedIndex.value = args['index'];
    }
    super.onInit();
  }
}
