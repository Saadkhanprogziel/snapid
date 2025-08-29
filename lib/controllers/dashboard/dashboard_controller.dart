import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/keys_urls/local_storage.dart';
import 'package:snapid/models/user/user_model.dart';

class DashboardController extends GetxController {
  final ScrollController scrollController = ScrollController();

  // Observables
  var showGreeting = true.obs;
  var user = UserModel().obs; // store full user reactively

  String get userName => user.value.firstName ?? 'User';
  int get credits => user.value.credits ?? 0;

  @override
  void onInit() {
    super.onInit();
    loadUser(); // initial load
  }

  void loadUser() {
    final userData = LocalStorage.getUser();
    if (userData != null) {
      user.value = userData;
    } else {
      user.value = UserModel(firstName: 'User');
      print('No user data found, using default name');
    }
  }

  void refreshUser() {
    loadUser();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
