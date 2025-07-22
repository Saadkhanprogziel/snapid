
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/routes/routes.dart';
class OnBoardingController extends GetxController {
  var currentPage = 0.obs;

  final PageController pageController = PageController();

  bool get isLastPage => currentPage.value == pages.length - 1;

  void setCurrentPage(int index) {
    currentPage.value = index;
  }

  void goToNextPage() {
    if (!isLastPage) {
      pageController.animateToPage(
        currentPage.value + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.toNamed(PrimaryRoute.onBoard3);
    }
  }

  void goToLastPage() {
    pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  final List<Map<String, String>> pages = [
    {
      "title": "Snap a Photo",
      "subtitle": "Take or upload any photo",
      "image": Assets.board1,
    },
    {
      "title": "AI Makes It Right",
      "subtitle": "We auto-adjust background, lighting, and size",
      "image": Assets.board2,
    },
  ];
}
