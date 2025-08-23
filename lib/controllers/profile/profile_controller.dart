import 'package:get/get.dart';
import 'package:snapid/keys_urls/local_storage.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/user/user_model.dart';
import 'package:snapid/routes/routes.dart';

class ProfileController extends GetxController {
  var isNotificationOn = false.obs;
  final selectedOption = 'metric'.obs;

  final radioOptions = [
    {'id': 'metric', 'name': 'Metric (cm)'},
    {'id': 'imperial', 'name': 'Imperial (inches)'},
  ];

  UserModel get user => LocalStorage.getUser() ?? UserModel();

  void logout() {

    appStorage.remove('user');
    appStorage.remove('accessToken');
    appStorage.remove('refreshToken');

    Get.offAllNamed(PrimaryRoute.login);
  }

  void setNotification(val) {
    isNotificationOn.value = val;
  }
}
