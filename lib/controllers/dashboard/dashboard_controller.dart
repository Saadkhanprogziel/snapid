import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/keys_urls/local_storage.dart';
import 'package:snapid/models/countries/countries.dart';
import 'package:snapid/models/user/user_model.dart';
import 'package:snapid/repositories/countries/countries_repository.dart';

class DashboardController extends GetxController {
  ScrollController? scrollController;
  final CountriesRepository countriesRepository = CountriesRepository();

  var showGreeting = true.obs;
  var user = UserModel().obs;
  var isCollapsed = false.obs;
  var countries = <Country>[].obs;

  String get userName => user.value.firstName ?? 'User';
  int get credits => user.value.credits ?? 0;

  @override
  void onInit() {
    super.onInit();

    initScrollController();
    fetchCountries();
    loadUser();
  }

  void initScrollController() {
    scrollController?.removeListener(_scrollListener);
    scrollController?.dispose();

    scrollController = ScrollController();
    scrollController!.addListener(_scrollListener);
  }

  Future<void> fetchCountries() async {
    final result = await countriesRepository.getCountries(page: 1, pageSize: 10);
    result.fold(
      (error) {
        Get.snackbar("Error", error,
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      },
      (success) {
        print("Fetched ${success.countries.length} countries");
        countries.value = success.countries;
        
      },
    );
  }

  void _scrollListener() {
    const double expandedHeight = 200;
    const double toolbarHeight = 100;
    const double collapseThreshold = expandedHeight - toolbarHeight - 20;

    bool shouldCollapse = scrollController!.hasClients &&
        scrollController!.offset > collapseThreshold;

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
    scrollController?.removeListener(_scrollListener);
    scrollController?.dispose();
    super.onClose();
  }
}
