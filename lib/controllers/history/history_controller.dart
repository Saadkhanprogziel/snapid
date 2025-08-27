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
  var isLoadingMore = false.obs;
  var errorMessage = "".obs;
  var historyList = <PhotoCreationModel>[].obs;
  
  // Pagination variables
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var pageSize = 10;
  var currentStatus = "ALL";

  // ScrollController for detecting scroll events
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
    // 👇 Fetch default history when controller is created
    fetchHistory(status: "ALL");
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      // Check if user has scrolled to near the bottom (80% of scroll)
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.8 &&
          !isLoadingMore.value &&
          hasMoreData.value &&
          !isLoading.value) {
        loadMoreData();
      }
    });
  }

  void onTabChanged(int index) {
    selectedTab.value = index;

    // Reset pagination state when tab changes
    _resetPaginationState();

    // 👇 Fetch data based on selected tab
    if (index == 0) {
      currentStatus = "ALL";
      fetchHistory(status: "ALL");
    } else if (index == 1) {
      currentStatus = "CREDITED";
      fetchHistory(status: "CREDITED");
    } else {
      currentStatus = "IMAGE_PROCESSED";
      fetchHistory(status: "IMAGE_PROCESSED");
    }
  }

  void _resetPaginationState() {
    currentPage.value = 1;
    hasMoreData.value = true;
    historyList.clear();
  }

  Future<void> fetchHistory({
    int? page,
    int? pageSize,
    String status = "ALL",
    bool isLoadMore = false,
  }) async {
    try {
      if (!isLoadMore) {
        isLoading.value = true;
        _resetPaginationState();
      } else {
        isLoadingMore.value = true;
      }
      
      errorMessage.value = "";
      currentStatus = status;

      final response = await _historyRepository.fetchHistory(
        page: page ?? currentPage.value,
        pageSize: pageSize ?? this.pageSize,
        status: status,
      );

      // 👇 fold the Either
      response.fold(
        (error) {
          errorMessage.value = error;
          if (!isLoadMore) {
            historyList.clear();
          }
        },
        (data) {
          if (isLoadMore) {
            // Add new data to existing list
            historyList.addAll(data);
          } else {
            // Replace existing data
            historyList.assignAll(data);
          }

          // Check if we have more data to load
          if (data.length < (pageSize ?? this.pageSize)) {
            hasMoreData.value = false;
          } else {
            currentPage.value++;
          }
        },
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value || isLoadingMore.value || isLoading.value) return;

    await fetchHistory(
      status: currentStatus,
      isLoadMore: true,
    );
  }

  Future<void> refreshHistory() async {
    _resetPaginationState();
    await fetchHistory(status: currentStatus);
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