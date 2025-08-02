import 'dart:io';

import '../entities/chat_message.dart';

abstract class ChatRepository {
  void sendMessage(ChatMessage message);
  Stream<ChatMessage> getMessagesStream();
  Future<void> sendImageMessage(File file, String receiverId);
  Future<void> sendAudioMessage(File file, String receiverId);
  Future<String> uploadFile(File file);
}
