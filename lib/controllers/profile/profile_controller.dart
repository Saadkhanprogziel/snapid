import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isNotificationOn = false.obs;
final selectedOption = 'metric'.obs;

final radioOptions = [
  {'id': 'metric', 'name': 'Metric (cm)'},
  {'id': 'imperial', 'name': 'Imperial (inches)'},
];



  void setNotification(val) {
    isNotificationOn.value = val;
  }
}
