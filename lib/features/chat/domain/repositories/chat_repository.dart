import '../entities/chat_message.dart';

abstract class ChatRepository {
  void sendMessage(ChatMessage message);
  Stream<ChatMessage> getMessagesStream();
}
