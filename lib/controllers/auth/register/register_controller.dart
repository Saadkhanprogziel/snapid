import 'package:get/get.dart';
import 'package:snapid/models/register/register.dart';

import 'package:snapid/utlis/country_model.dart';

class RegisterController extends GetxController {
    final register = RegisterModel().obs;
  final isLoading = false.obs;
    var agreeToTerms = false.obs;

  
  var selectedCountry = Rxn<Country>();
  final List<String> countryCodes = ['+1', '+44', '+91', '+61', '+81'];
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  void selectCountry(Country country) {
    selectedCountry.value = country;
    Get.back();
  }

}