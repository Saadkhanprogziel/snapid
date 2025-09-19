import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/chat_message/chat_message.dart';
import 'package:snapid/repositories/chat_repository/chat_repository.dart';

class ChatController extends GetxController {
  final chatRepository = ChatRepository();

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
  late String chatId;

  @override
  void onInit() {
    super.onInit();
    _initializeTicketData();
    getAllMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void sendMessage() {
    final trimmedMessage = messageController.text.trim();
    print("message ${messageController.text}");
    if (trimmedMessage.isNotEmpty) {
      log("[sendMessage] Sending message: $trimmedMessage");
      appSocket.fireEvent('send_message', {
        'chatID': chatId,
        'content': trimmedMessage,
      });
      messageController.clear();
      // Scroll to bottom after sending message
      _scrollToBottom();
    } else {
      log("[sendMessage] Text field is empty, no message sent");
    }
  }

  Future<void> getAllMessages() async {
    isLoading.value = true;
    await chatRepository
        .fetchAllMessages(limit: 20, chatId: chatId)
        .then((response) {
      response.fold((error) {
        isLoading.value = false;
        Get.snackbar("Error", error, colorText: Colors.redAccent);
      }, (success) {
        isLoading.value = false;
        messages.value = success;
      });
    });
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
    chatId = arguments['chat_id'] ?? '';

    log('Initialized with ticket ID: $ticketId');
    log('Ticket subject: $ticketSubject');
    log('Ticket status: $ticketStatus');
    log('Chat Id: $chatId');

    joinRoom();
  }

  void joinRoom() {
    log("[joinRoom] Joining room with chatId: $chatId");
    appSocket.fireEvent('join_chat', {
      'chatID': chatId,
    });

    listenEvents();
  }

  void listenEvents() {
    log("[listenEvents] Listening to socket events");
    appSocket.listenToRecieveMessageEvent((data) {
      log("[listenEvents] Message received: $data");
      print(data);
      try {
        final message = ChatMessage.fromJson(data);
        addNewMessage(message);
      } catch (e) {
        log("[listenEvents] Error parsing message: $e");
      }
    });
  }

  void addNewMessage(ChatMessage message) {
    log("[addNewMessage] Adding new message: ${message.content}");

    // Check if message already exists to avoid duplicates
    bool messageExists = messages.any((msg) => msg.id == message.id);

    if (!messageExists) {
      // Add the message to the list
      messages.add(message);

      // Sort messages by creation date to maintain chronological order
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      // Scroll to bottom to show the new message
      _scrollToBottom();
    } else {
      log("[addNewMessage] Message already exists, skipping duplicate");
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
