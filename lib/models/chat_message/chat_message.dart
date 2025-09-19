class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String status;
  final DateTime createdAt;
  final Sender sender;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.status,
    required this.createdAt,
    required this.sender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'],
        chatId: json['chatId'],
        senderId: json['senderId'],
        content: json['content'],
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
        sender: Sender.fromJson(json['sender']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': chatId,
        'senderId': senderId,
        'content': content,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'sender': sender.toJson(),
      };
}

class Sender {
  final String id;
  final String firstName;
  final String lastName;
  final String role;

  Sender({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        role: json['role'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
      };
}

