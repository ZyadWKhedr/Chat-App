import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  void connect() {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      'http://10.0.2.2:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      log("✅ Connected");
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        _socket!.emit('register', uid);
      }
    });

    _socket!.connect();
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_socket?.connected ?? false) {
      _socket!.emit('send_message', message);
    }
  }

  void listenMessages(Function(Map<String, dynamic>) onMessageReceived) {
    _socket?.on('receive_message', (data) {
      onMessageReceived(Map<String, dynamic>.from(data));
    });
  }

  Future<void> sendImageMessage({
    required String fileUrl,
    required String receiverId,
  }) async {
    final message = {
      'senderId': FirebaseAuth.instance.currentUser?.uid,
      'receiverId': receiverId,
      'type': 'image',
      'message': fileUrl,
      'timestamp': DateTime.now().toIso8601String(),
    };

    sendMessage(message);
  }

  Future<void> sendAudioMessage({
    required String fileUrl,
    required String receiverId,
  }) async {
    final message = {
      'senderId': FirebaseAuth.instance.currentUser?.uid,
      'receiverId': receiverId,
      'type': 'audio',
      'message': fileUrl,
      'timestamp': DateTime.now().toIso8601String(),
    };

    sendMessage(message);
  }

  void dispose() {
    _socket?.dispose();
  }
}
