// Message model
class ChatMessage {
  final String id;
  final String text;
  final String sender;
  final DateTime timestamp;
  final bool isFromSupport;
  final String? senderName;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    required this.isFromSupport,
    this.senderName,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      text: json['message'] ?? '',
      sender: json['sender'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      isFromSupport: json['isFromSupport'] ?? false,
      senderName: json['senderName'],
    );
  }
}
