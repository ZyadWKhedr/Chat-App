class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final String? imageUrl;
  final String? audioPath;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    this.imageUrl,
    this.audioPath,
    required this.timestamp,
  });
}
