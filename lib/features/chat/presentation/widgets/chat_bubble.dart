import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String message;

  const ChatBubble({super.key, required this.isMine, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMine ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(color: isMine ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
