import 'dart:io';

import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:chat_app/features/chat/presentation/widgets/audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final hasText = message.text.isNotEmpty;
    final hasImage = message.imageUrl != null;
    final hasAudio = message.audioPath != null;

    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final crossAxisAlignment =
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (hasText)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primaryColor : Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          if (hasImage)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(message.imageUrl!), height: 150),
              ),
            ),
          if (hasAudio)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: AudioPlayerWidget(url: message.audioPath!),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              DateFormat('hh:mm a').format(message.timestamp),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
