import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_app/features/chat/data/datasources/socket_service.dart';
import 'package:chat_app/features/chat/data/models/chat_message_model.dart';
import 'package:chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:http/http.dart' as http;

class ChatRepositoryImpl extends ChatRepository {
  final String _baseUrl = 'http://10.0.2.2:3000';
  final SocketService socketService;
  final StreamController<ChatMessage> _messageController =
      StreamController.broadcast(); //allows multiple listeners to subscribe to it simultaneously.

  ChatRepositoryImpl(this.socketService) {
    socketService.listenMessages((data) {
      final message = ChatMessageModel.fromJson(data);
      _messageController.add(message);
    });
  }

  @override
  Stream<ChatMessage> getMessagesStream() {
    return _messageController.stream;
  }

  @override
  void sendMessage(ChatMessage message) {
    final model = ChatMessageModel(
      id: message.id,
      senderId: message.senderId,
      text: message.text,
      timestamp: message.timestamp,
      receiverId: message.receiverId,
    );
    socketService.sendMessage(model.toJson());
  }

  @override
  Future<void> sendImageMessage(File file, String receiverId) async {
    final url = await uploadFile(file);
    await socketService.sendImageMessage(fileUrl: url, receiverId: receiverId);
  }

  @override
  Future<void> sendAudioMessage(File file, String receiverId) async {
    final url = await uploadFile(file);
    await socketService.sendAudioMessage(fileUrl: url, receiverId: receiverId);
  }

  @override
  Future<String> uploadFile(File file) async {
    final uri = Uri.parse('$_baseUrl/upload'); // FIXED: should match backend
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);
      return data['url'];
    } else {
      throw Exception('File upload failed');
    }
  }
}
