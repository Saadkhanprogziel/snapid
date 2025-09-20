import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/chat/chat_controller.dart';
import 'package:snapid/models/chat_message/chat_message.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = deviceWidth >= 800;
    final ChatController chatController = Get.put(ChatController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.appBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: isLargeScreen
                ? _buildLargeScreenLayout(
                    context,
                    chatController.ticketSubject,
                    chatController.ticketStatus,
                    chatController.ticketDate,
                    chatController.ticketId)
                : _buildMobileLayout(
                    context,
                    chatController.ticketSubject,
                    chatController.ticketStatus,
                    chatController.ticketDate,
                    chatController.ticketId),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, String subject, String status,
      String date, String ticketId) {
    return Column(
      children: [
        SpaceH20(),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border:
                    Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
              ),
              child: Icon(
                Icons.support_agent,
                size: 40,
                color: AppColors.primaryColor,
              ),
            ),
            SpaceH10(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    status,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: _getStatusColor(status).withOpacity(0.3)),
              ),
            ),
          ],
        ),
        SpaceH20(),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: _buildChatContent(
                context, false, subject, status, date, ticketId),
          ),
        ),
      ],
    );
  }

  Widget _buildLargeScreenLayout(BuildContext context, String subject,
      String status, String date, String ticketId) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.3)),
                    ),
                    child: Icon(
                      Icons.support_agent,
                      size: 24,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              subject,
                              style: CustomTextTheme.regular22.copyWith(
                                color: AppColors.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              ticketId,
                              style: CustomTextTheme.regular16.copyWith(
                                color: AppColors.whiteColor.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: _getStatusColor(status)
                                        .withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(status),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    status,
                                    style: TextStyle(
                                      color: _getStatusColor(status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              date,
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildChatContent(
                  context, true, subject, status, date, ticketId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatContent(
    BuildContext context,
    bool isLargeScreen,
    String subject,
    String status,
    String date,
    String ticketId,
  ) {
    final ChatController chatController = Get.find<ChatController>();

    return Column(
      children: [
        if (!isLargeScreen) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SpaceH30(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject,
                                  style: CustomTextTheme.regular22.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 18,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '$date',
                                  style: CustomTextTheme.regular16.copyWith(
                                    color:
                                        AppColors.whiteColor.withOpacity(0.6),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SpaceH20(),
              ],
            ),
          ),
        ],
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 24.0 : 16.0,
              vertical: isLargeScreen ? 12.0 : 0.0,
            ),
            child: Obx(() => ListView.builder(
                  controller: chatController.scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatController.messages[index];
                    return MessageBubble(
                      message: message,
                      isLargeScreen: isLargeScreen,
                    );
                  },
                )),
          ),
        ),
        // Wrap input area with Padding and add keyboard padding
        Padding(
          padding: EdgeInsets.only(
            left: isLargeScreen ? 24.0 : 10.0,
            right: isLargeScreen ? 24.0 : 10.0,
            top: isLargeScreen ? 16.0 : 20.0,
            bottom: isLargeScreen ? 16.0 : 45.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isLargeScreen
                  ? Colors.grey[900]?.withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: isLargeScreen
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: isLargeScreen
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: chatController.messageController,
                      // Add text input action and onSubmitted
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          chatController.sendMessage();
                        }
                      },
                      // Add maxLines and minLines for better UX
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            if (chatController.messageController.text
                                .trim()
                                .isNotEmpty) {
                              chatController.sendMessage();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(14),
                            child: const Icon(Icons.send,
                                color: Colors.white, size: 20),
                          ),
                        ),
                        filled: true,
                        fillColor:
                            isLargeScreen ? Colors.grey[800] : Colors.grey[850],
                        hintText: 'Type your message...',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return AppColors.green;
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return AppColors.primaryColor;
    }
  }
}
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLargeScreen;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isLargeScreen,
  }) : super(key: key);

  bool get isUserMessage => message.sender.role.toLowerCase() == 'user';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4), // reduced margin
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 14 : 16,
          vertical: isLargeScreen ? 8 : 10, // reduced padding
        ),
        constraints: BoxConstraints(
          maxWidth: isLargeScreen
              ? MediaQuery.of(context).size.width * 0.7
              : MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: _getBubbleColor(),
          border: Border.all(
            color: _getBorderColor(),
          ),
          borderRadius: _getBorderRadius(),
          boxShadow: _getBoxShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // shrink to fit content
          children: [
            if (!isUserMessage) ...[
              Text(
                '${message.sender.firstName} ${message.sender.lastName}',
                style: TextStyle(
                  color: AppColors.whiteColor.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2), // smaller gap
            ],
            Text(
              message.content,
              style: CustomTextTheme.regular16.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.2, // reduced line spacing
              ),
            ),
            const SizedBox(height: 2), // smaller gap
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    color: isUserMessage
                        ? AppColors.whiteColor.withOpacity(0.7)
                        : AppColors.whiteColor.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
                if (isUserMessage) ...[
                  const SizedBox(width: 4),
                  // Icon(
                  //   _getStatusIcon(),
                  //   size: 12,
                  //   color: AppColors.whiteColor.withOpacity(0.7),
                  // ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getBubbleColor() {
    if (isUserMessage) {
      return AppColors.primaryColor;
    }
    return isLargeScreen
        ? Colors.grey[800]?.withOpacity(0.6) ?? Colors.grey[800]!
        : AppColors.cardColor;
  }

  Color _getBorderColor() {
    if (isUserMessage) {
      return Colors.transparent;
    }
    return isLargeScreen
        ? Colors.grey.withOpacity(0.3)
        : Colors.grey.withOpacity(0.2);
  }

  BorderRadius _getBorderRadius() {
    if (isUserMessage) {
      return const BorderRadius.only(
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(16),
        topLeft: Radius.circular(16),
      );
    }
    return const BorderRadius.only(
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    );
  }

  List<BoxShadow>? _getBoxShadow() {
    if (!isLargeScreen) return null;

    if (isUserMessage) {
      return [
        BoxShadow(
          color: AppColors.primaryColor.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ];
  }

  IconData _getStatusIcon() {
    switch (message.status.toLowerCase()) {
      case 'sent':
        return Icons.check;
      case 'delivered':
        return Icons.done_all;
      case 'read':
        return Icons.done_all;
      default:
        return Icons.access_time;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0), // reduced gap
      child: Text(
        'Support team is typing...',
        style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
      ),
    );
  }
}
