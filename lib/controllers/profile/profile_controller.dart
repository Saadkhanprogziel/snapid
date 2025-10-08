import 'package:get/get.dart';
import 'package:snapid/main.dart';
import 'package:snapid/repositories/auth/auth_respository.dart';
import 'package:snapid/routes/routes.dart';

class ProfileController extends GetxController {
  var isNotificationOn = false.obs;
  final selectedOption = 'cm'.obs;
  final authRepository = AuthRespository();

  final radioOptions = [
    {'id': 'cm', 'name': 'Metric (cm)'},
    {'id': 'in', 'name': 'Imperial (inches)'},
  ];

  

  void logout() {
    // print(appStorage.read('accessToken'));

    authRepository.logout().then((response) => response.fold((error) {
          Get.snackbar("Error", error);
          Get.back();
        }, (success) {
         
        
          Get.offAllNamed(PrimaryRoute.login);
        }));
  }

  void setNotification(val) {
    isNotificationOn.value = val;
  }
  void saveSelectedUnit() {
    appStorage.write("unit", selectedOption.value);
    print(selectedOption.value);
  }
}
