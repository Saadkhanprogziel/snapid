import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/main.dart';
import 'package:snapid/models/chat_message/chat_message.dart';
import 'package:snapid/repositories/chat_repository/chat_repository.dart';

class ChatController extends GetxController {
  final chatRepository = ChatRepository();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final int _pageSize = 20; // messages per page
  int _currentPage = 1; // current page number for pagination
  bool _hasMore = true; // whether more pages are available
  final RxBool isConnected = false.obs;
  final RxBool isTyping = false.obs;
  final RxBool isLoading = false.obs;
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
    getAllMessages(isInitial: true);

    // Scroll listener for pagination (load older messages)
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isLoading.value &&
          _hasMore) {
        getAllMessages();
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void sendMessage() {
    final trimmedMessage = messageController.text.trim();
    if (trimmedMessage.isNotEmpty) {
      log("[sendMessage] Sending message: $trimmedMessage");
      appSocket.fireEvent('send_message', {
        'chatID': chatId,
        'content': trimmedMessage,
      });
      messageController.clear();

      // Optional: scroll to bottom for new message
      scrollController.animateTo(
        0, // top of reversed list
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      log("[sendMessage] Text field is empty, no message sent");
    }
  }

  Future<void> getAllMessages({bool isInitial = false}) async {
    if (!_hasMore && !isInitial) return;

    isLoading.value = true;

    if (isInitial) {
      _currentPage = 1;
      _hasMore = true;
    }

    await chatRepository
        .fetchAllMessages(
          page: _currentPage, // page number
          chatId: chatId,
          pageSize: _pageSize, // page size
        )
        .then((response) {
      response.fold((error) {
        isLoading.value = false;
        Get.snackbar("Error", error, colorText: Colors.redAccent);
      }, (success) {
        isLoading.value = false;

        // Order messages oldest → newest
        final ordered = success.reversed.toList();

        if (isInitial) {
          messages.value = ordered;
        } else {
          // append older messages at the end (reverse: true)
          messages.addAll(ordered);
        }

        if (success.length < _pageSize) {
          _hasMore = false; // no more pages
        } else {
          _currentPage++; // next page
        }
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
    appSocket.listenToRecieveMessageEvent((data) {
      log("[listenEvents] Message received: $data");
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

    bool messageExists = messages.any((msg) => msg.id == message.id);

    if (!messageExists) {
      messages.insert(0, message); // insert at start because list is reversed
    } else {
      log("[addNewMessage] Message already exists, skipping duplicate");
    }
  }
}
