import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/keys_urls/local_storage.dart';
import 'package:snapid/models/user/user_model.dart';

class DashboardController extends GetxController {
  final ScrollController scrollController = ScrollController();

  
  var showGreeting = true.obs;
  var user = UserModel().obs; 
  var isCollapsed = false.obs; 

  String get userName => user.value.firstName ?? 'User';
  int get credits => user.value.credits ?? 0;

  @override
  void onInit() {
    super.onInit();
    loadUser(); 
    _setupScrollListener(); 
  }

  void _setupScrollListener() {
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    const double expandedHeight = 200;
    const double toolbarHeight = 100;
    const double collapseThreshold = expandedHeight - toolbarHeight - 20;

    bool shouldCollapse = scrollController.hasClients &&
        scrollController.offset > collapseThreshold;

    if (shouldCollapse != isCollapsed.value) {
      isCollapsed.value = shouldCollapse;
    }
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
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }
}