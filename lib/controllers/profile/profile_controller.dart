import 'package:get/get.dart';
import 'package:snapid/keys_urls/local_storage.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/user/user_model.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/routes/routes.dart';

class ProfileController extends GetxController {
  var isNotificationOn = false.obs;
  final selectedOption = 'metric'.obs;
  final authRepository = AuthRespository();

  final radioOptions = [
    {'id': 'metric', 'name': 'Metric (cm)'},
    {'id': 'imperial', 'name': 'Imperial (inches)'},
  ];

  

  void logout() {
    // print(appStorage.read('accessToken'));

    authRepository.logout().then((response) => response.fold((error) {
          Get.snackbar("Error", error);
          Get.back();
        }, (success) {
          print("success");
          appStorage.remove('user');
          appStorage.remove('token');
          appStorage.remove('refreshToken');
          Get.offAllNamed(PrimaryRoute.login);
        }));
  }

  void setNotification(val) {
    isNotificationOn.value = val;
  }
}
