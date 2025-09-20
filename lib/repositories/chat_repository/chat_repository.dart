import 'package:dartz/dartz.dart';
import 'package:snapid/models/chat_message/chat_message.dart';

import '../../network/network_repository.dart';

class ChatRepository {
  final networkRepository = NetworkRepository();

  Future<Either<String, List<ChatMessage>>> fetchAllMessages({
    required int limit,
    required String chatId,
    int offset = 0,
  }) async {
    final response = await networkRepository.get(
      url: "/chat/$chatId/get-all-messages",
      extraQuery: {
        "limit": limit,
        "offset": offset,
      },
    );

    if (!response.failed) {
      final List<dynamic> messages = response.data['data'];
      List<ChatMessage> data =
          messages.map((item) => ChatMessage.fromJson(item)).toList();
      return right(data);
    }

    return left(response.message);
  }

  Future<Either<String, int>> getRoomId() async {
    final response = await networkRepository.get(url: "/chat/get-chat-room");

    if (!response.failed && response.data["roomId"] != null) {
      if (response.data["roomId"] == null) {
        return left("Room ID is null");
      }
      final data = response.data["roomId"] as int;
      return right(data);
    }

    return left(response.message);
  }
}
