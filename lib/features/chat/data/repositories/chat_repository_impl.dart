import 'dart:async';

import 'package:chat_app/features/chat/data/datasources/socket_service.dart';
import 'package:chat_app/features/chat/data/models/chat_message_model.dart';
import 'package:chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
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
    );
    socketService.sendMessage(model.toJson());
  }
}
