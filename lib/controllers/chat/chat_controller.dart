import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/chat_message/chat_message.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isConnected = false.obs;
  final RxBool isTyping = false.obs;
  final RxBool isLoading = false.obs;
  var roomId = 0.obs;
  final RxString connectionStatus = 'Disconnected'.obs;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late String ticketId;
  late String ticketSubject;
  late String ticketStatus;
  late String ticketDate;

  @override
  void onInit() {
    super.onInit();
    _initializeTicketData();
  }

  void _initializeTicketData() {
    final Map<String, dynamic> arguments = Get.arguments ?? {};

    ticketId = arguments['id']?.toString() ??
        arguments['ticketId']?.toString() ??
        arguments['ticket_id']?.toString() ??
        '';

    ticketSubject = arguments['subject'] ?? 'Support Ticket';
    ticketStatus = arguments['status'] ?? 'Open';
    ticketDate = arguments['date'] ?? 'Today';


    log('Initialized with ticket ID: $ticketId'); 
    log('Ticket subject: $ticketSubject');
    log('Ticket status: $ticketStatus');

    appSocket.fireEvent("event", {});
  }
}
