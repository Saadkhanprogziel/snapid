import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/models/countries/country_response.dart';
import 'package:snapid/repositories/countries/countries_repository.dart';

class PopularCountriesController extends GetxController {
  ScrollController? scrollController;
  TextEditingController searchController = TextEditingController();
  final CountriesRepository countriesRepository = CountriesRepository();

  // Changed to store list of Country
  var countries = <Country>[].obs;
  var pagination = <Pagination>[].obs;

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;
  var currentPage = 1.obs;
  var searchQuery = ''.obs;

  final int pageSize = 10;
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    initScrollController();
    initSearchListener();
    fetchCountries();
  }

  void initScrollController() {
    scrollController?.removeListener(_scrollListener);
    scrollController?.dispose();

    scrollController = ScrollController();
    scrollController!.addListener(_scrollListener);
  }

  void initSearchListener() {
    searchController.addListener(() {
      _onSearchChanged(searchController.text);
    });
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (searchQuery.value != query) {
        searchQuery.value = query;
        _performSearch();
      }
    });
  }

  void _performSearch() {
    currentPage.value = 1;
    hasMoreData.value = true;
    countries.clear();
    fetchCountries();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _performSearch();
  }

  Future<void> fetchCountries({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      countries.clear();
    }

    if (isLoading.value || isLoadingMore.value) return;

    if (currentPage.value == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final result = await countriesRepository.getCountries(
        page: currentPage.value,
        pageSize: pageSize,
        searchQuery: searchQuery.value,
      );

      result.fold(
        (error) {
          Get.snackbar(
            "Error",
            error,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        },
        (success) {
          print("Fetched ${success.formatted.length} countries for page ${currentPage.value}");

          // Check if there's more data
          if (success.formatted.length < pageSize) {
            hasMoreData.value = false;
          }

          // ✅ FIXED: Map<String, Country> → List<Country>
          if (isRefresh || currentPage.value == 1) {
            countries.value = success.formatted.values.toList();
          } else {
            countries.addAll(success.formatted.values);
          }

          // Update pagination data
          pagination.add(success.pagination);

          currentPage.value++;
        },
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch countries",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void _scrollListener() {
    if (scrollController!.position.pixels >=
        scrollController!.position.maxScrollExtent - 200) {
      if (hasMoreData.value && !isLoadingMore.value && !isLoading.value) {
        fetchCountries();
      }
    }
  }

  Future<void> refreshCountries() async {
    await fetchCountries(isRefresh: true);
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    scrollController?.removeListener(_scrollListener);
    scrollController?.dispose();
    searchController.dispose();
    super.onClose();
  }
}
