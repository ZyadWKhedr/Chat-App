enum MessageType { text, image, audio }

extension MessageTypeExtension on MessageType {
  String get name => toString().split('.').last;

  static MessageType fromString(String value) {
    return MessageType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MessageType.text,
    );
  }
}
