import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
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
      baseSocketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': appStorage.read("token")})
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      log("Socket Connected");
    });

    _socket.onDisconnect((_) {
      log("⚠️ Disconnected from socket");
    });

    _socket.onError((error) {
      log(" Socket transport error: $error");
    });

    // Listen for custom error event from backend
    _socket.on("chat_error", (data) {
      Get.snackbar("Error", data["error"], colorText: Colors.redAccent);
      log("🚨 Chat error event: ${data["error"]}");
    });
    
     // Listen for custom error event from backend
    _socket.on("ticket_closed", (data) {
      log("📩 TICKET CLOSED event data: $data");

      if (data is String) {
        data = jsonDecode(data);
      }

      final ticketTitle = data["ticket"]?["title"] ?? "Untitled Ticket";
      final message = data["message"] ?? "Your ticket has been closed.";

      Get.defaultDialog(
        title: "TICKET CLOSED",
        backgroundColor: AppColors.cardColor,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 1.2,
        ),
        radius: 16,
        content: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Colors.greenAccent, size: 60),
                const SizedBox(height: 20),

                // Ticket subject (received title)
                Text(
                  ticketTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Backend message (if any)
                Text(
                  message.toString(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        confirm: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            onPressed: () => Get.back(),
            child: const Text(
              "OK",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Listen for incoming messages (switch to `new_message` if your backend uses that)
  void listenToRecieveMessageEvent(void Function(dynamic data) dataCallBack) {
    _socket.off("new_message"); // prevent duplicate listeners
    _socket.on("new_message", (data) {
      log("📩 Received message data: $data");
      if (data != null) {
        dataCallBack.call(data);
      }
    });

    log("🔍 Listener initialized: ${_socket.hasListeners("new_message")}");
  }

  /// Generic event listener
  void listenToEvent(String event, dynamic Function(dynamic) callBackData) {
    _socket.on(event, callBackData);
  }

  /// Emit an event with data
  void fireEvent(String event, dynamic data) {
    _socket.emit(event, data);
  }

  /// Disconnect socket
  void disconnect() {
    _socket.disconnect();
    log("🔌 Socket manually disconnected");
  }
}





// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:snapid/keys_urls/urls.dart';
// import 'package:snapid/main.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {
//   late IO.Socket _socket;

//   SocketService() {
//     _initializeSocketService();
//   }

//   void _initializeSocketService() {
//     _socket = IO.io(
//       baseUrl,
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .enableAutoConnect()
//           // Change to setQuery if your server expects query params instead of auth
//           .setAuth({'token': appStorage.read("token")})
//           .build(),
//     );

//     _socket.connect();

//     _socket.onConnect((_) {
//       log("✅ Socket Connected");
//     });

//     _socket.onDisconnect((_) {
//       log("⚠️ Disconnected from socket");
//     });

//     _socket.onError((error) {
//       log("❌ Socket transport error: $error");
//     });

//     // Listen for custom error event from backend
//     _socket.on("chat_error", (data) {
//       Get.snackbar("Error", data["error"], colorText: Colors.redAccent);
//       log("🚨 Chat error event: ${data["error"]}");
//     });
//   }

//   /// Listen for incoming messages (switch to `new_message` if your backend uses that)
//   void listenToRecieveMessageEvent(void Function(dynamic data) dataCallBack) {
//     _socket.off("receive_message"); // prevent duplicate listeners
//     _socket.on("receive_message", (data) {
//       log("📩 Received message data: $data");
//       if (data != null) {
//         dataCallBack.call(data);
//       }
//     });

//     log("🔍 Listener initialized: ${_socket.hasListeners("receive_message")}");
//   }

//   /// Generic event listener
//   void listenToEvent(String event, dynamic Function(dynamic) callBackData) {
//     _socket.on(event, callBackData);
//   }

//   /// Emit an event with data
//   void fireEvent(String event, dynamic data) {
//     _socket.emit(event, data);
//   }

//   /// Disconnect socket
//   void disconnect() {
//     _socket.disconnect();
//     log("🔌 Socket manually disconnected");
//   }
// }

