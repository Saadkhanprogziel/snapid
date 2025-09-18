import 'dart:developer';
import 'package:snapid/keys_urls/urls.dart';
import 'package:snapid/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;

  SocketService() {
    _initializeSocketService();
  }

  void _initializeSocketService() {
    _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setAuth({'token': appStorage.read("token")})
            .build());
    _socket.connect();

    _socket.onConnect((_) {
      log("Socket Connected");
    });

    _socket.onDisconnect((_) {
      log('Disconnected from socket');
    });

    _socket.onError((error) {
      log('Socket error: $error');
    });
  }

  void listenToJoinChatRoomEvent(void Function(int roomId) roomIdCallback) {
    _socket.off("joined_chat_room");
    _socket.on('joined_chat_room', (data) {
      int? roomId = data["roomId"];
      if (roomId != null) {
        roomIdCallback.call(roomId);
      }
    });
  }
void listenToRecieveMessageEvent(void Function(dynamic data) dataCallBack) {
    _socket.off("chat_joined");
    _socket.on('chat_joined', (data) {
      log("Recieved data in sockets: $data");
      if (data != null) {
        dataCallBack.call(data);
      }
    });

    log("Is reciever initialized: ${_socket.hasListeners("chat_joined")}");
  }

  // void listenToRecieveMessageEvent(void Function(dynamic data) dataCallBack) {
  //   _socket.off("receive_message");
  //   _socket.on('receive_message', (data) {
  //     log("Recieved data in sockets: $data");
  //     if (data != null) {
  //       dataCallBack.call(data);
  //     }
  //   });

  //   log("Is reciever initialized: ${_socket.hasListeners("receive_message")}");
  // }

  void listenToEvent(String event, dynamic Function(dynamic) callBackData) {
    _socket.on(event, callBackData);
  }

  void fireEvent(String event, dynamic data) {
    _socket.emit(event, data);
  }

  void disconnect() {
    _socket.disconnect();
  }
}
