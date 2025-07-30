import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.text,
    required super.timestamp,
    super.imageUrl,
    super.audioPath,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      audioPath: json['audioPath'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'imageUrl': imageUrl,
      'audioPath': audioPath,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
