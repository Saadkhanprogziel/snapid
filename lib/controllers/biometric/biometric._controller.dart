import 'package:get/get.dart';

class BiometricController extends GetxController {
  var biometirc = false.obs;
  var face_id = false.obs;



  void setBiometric(val) {
    biometirc.value = val;
  }



  void setFaceId(val) {
    face_id.value = val;
  }
}
