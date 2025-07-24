import 'package:get/get.dart';

class DeleteAccountController extends GetxController {
  RxString selectedReason = ''.obs;

  void setReason(String reason) {
    selectedReason.value = reason;
  }

  void deleteAccount() {
    // Add deletion logic here
    print("Deleting account for reason: ${selectedReason.value}");
  }
}
