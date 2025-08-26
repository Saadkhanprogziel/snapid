import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:snapid/models/photo_creation/photo_creation_model.dart';
import 'package:snapid/repositories/history/history_repository.dart';

class HistoryController extends GetxController {
  final HistoryRepository _historyRepository = HistoryRepository();

  var selectedTab = 0.obs;

  // Observables for history state
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var historyList = <PhotoCreationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 👇 Fetch default history when controller is created
    fetchHistory(status: "ALL");
  }

  void onTabChanged(int index) {
    selectedTab.value = index;

    // 👇 Fetch data based on selected tab
    if (index == 0) {
      fetchHistory(status: "ALL");
    } else if (index == 1) {
      fetchHistory(status: "CREDITED");
    } else {
      fetchHistory(status: "IMAGE_PROCESSED");
    }
  }

  Future<void> fetchHistory({
    int page = 1,
    int pageSize = 10,
    String status = "ALL",
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final response = await _historyRepository.fetchHistory(
        page: page,
        pageSize: pageSize,
        status: status,
      );

      // 👇 fold the Either
      response.fold(
        (error) {
          errorMessage.value = error;
          historyList.clear();
        },
        (data) {
          historyList.assignAll(data);
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> delete(id) async {
    final result = await _historyRepository.deleteSession(id);

    result.fold(
      (errorMessage) {
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (success) {
        historyList.removeWhere((item) => item.id == id);
        Fluttertoast.showToast(
          msg: "Session deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      },
    );
  }
}
