import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final ScrollController scrollController = ScrollController();
  var showGreeting = true.obs;

  


  @override
  void onInit() {
    scrollController.addListener(_onScroll);
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
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
