import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/keys_urls/local_storage.dart';
import 'package:snapid/models/user/user_model.dart';

class DashboardController extends GetxController {
  final ScrollController scrollController = ScrollController();
  var showGreeting = true.obs;
  
  // Observable user name for reactive updates
  var userName = ''.obs;
  
  UserModel get user => LocalStorage.getUser() ?? UserModel();


  // Load user name and update observable
  void _loadUserName() {
    final userData = LocalStorage.getUser();
    if (userData != null && userData.firstName != null) {
      userName.value = userData.firstName!;
      print('User name loaded: ${userData.firstName}');
    } else {
      userName.value = 'User';
      print('No user data found, using default name');
    }
  }

  @override
  void onInit() {
    scrollController.addListener(_onScroll);
        _loadUserName();

    super.onInit();
  }

  void _onScroll() {
    if (scrollController.offset > 40 && showGreeting.value) {
      showGreeting.value = false;
    } else if (scrollController.offset <= 10 && !showGreeting.value) {
      showGreeting.value = true;
    }
  }

  @override
  void onClose() {
    // scrollController.removeListener(_onScroll);
    // scrollController.dispose();
    super.onClose();
  }
}
