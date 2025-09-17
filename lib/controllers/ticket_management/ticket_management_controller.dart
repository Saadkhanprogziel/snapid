import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/models/tickets/tickets_model.dart';
import 'package:snapid/repositories/tickets/tickets_repository.dart';

class TicketManagementController extends GetxController {
  TicketsRepository ticketsRepository = TicketsRepository();
  var selectedTab = 0.obs;
  var isLoading = false.obs;

  void onTabChanged(int index) {
    print(index);
    selectedTab.value = index;
  }

  // Store all tickets fetched from API
  var allTickets = <Ticket>[].obs;
  
  // Computed property that returns filtered tickets based on selected tab
  List<Ticket> get tickets {
    switch (selectedTab.value) {
      case 0: // All
        return allTickets;
      case 1: // Open
        return allTickets.where((ticket) => 
          ticket.status.toLowerCase() == 'open').toList();
      case 2: // Pending
        return allTickets.where((ticket) => 
          ticket.status.toLowerCase() == 'pending').toList();
      case 3: // Closed
        return allTickets.where((ticket) => 
          ticket.status.toLowerCase() == 'closed').toList();
      default:
        return allTickets;
    }
  }
  
  Future<void> getTickets() async { 
    isLoading.value = true;
    ticketsRepository.fetchTickets().then(
      (response) {
        response.fold(
          (error) {
            Get.snackbar(
              'Error',
              error,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }, 
          (success) {
            allTickets.value = success;
          }
        );
      },
    ).whenComplete(() {
      isLoading.value = false;
    });
  }
  
  @override
  void onInit() {
    super.onInit();
    getTickets();
  }
}