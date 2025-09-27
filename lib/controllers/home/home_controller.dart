import 'package:get/get.dart';
import 'package:snapid/keys_urls/local_storage.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/user/user_model.dart';
import 'package:snapid/repositories/services/socketServices.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;

  void setIndex(int index) {
    selectedIndex.value = index;
  }

  Rx<UserModel> user = UserModel().obs;

  @override
  void onInit() {
    appSocket = SocketService();
    final args = Get.arguments;
    if (args != null && args['index'] is int) {
      selectedIndex.value = args['index'];
    }
    user.value = LocalStorage.getUser() ?? UserModel();

    super.onInit();
  }

  refreshUser() {
    user.value = LocalStorage.getUser() ?? UserModel();
    update();
  }

  @override
  void onClose() {
    // Dispose resources here if needed
    super.onClose();
  }
}
