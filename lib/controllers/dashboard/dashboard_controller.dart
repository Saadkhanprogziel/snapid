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
  int get credits => user.value.credits ?? 0  ;


  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
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
 void _onScroll() {
    if (!scrollController.hasClients) return; // ✅ guard
    if (scrollController.offset > 40 && showGreeting.value) {
      showGreeting.value = false;
    } else if (scrollController.offset <= 10 && !showGreeting.value) {
      showGreeting.value = true;
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll); // ✅ no dispose()
    super.onClose();
  }

}
