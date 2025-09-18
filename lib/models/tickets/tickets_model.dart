class Ticket {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime? closedAt;
  final Chat chat;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.closedAt,
    required this.chat,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      closedAt: json['closedAt'] != null ? DateTime.parse(json['closedAt']) : null,
      chat: Chat.fromJson(json['chat'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
      'chat': chat.toJson(),
    };
  }

  /// Helper to parse a list of tickets from JSON array
  static List<Ticket> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Ticket.fromJson(json)).toList();
  }
}

class Chat {
  final String id;

  Chat({required this.id});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
