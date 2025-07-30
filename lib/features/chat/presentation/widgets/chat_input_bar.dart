import 'package:chat_app/core/services/audio_recorder_service.dart';
import 'package:chat_app/core/services/image_picker_service.dart';
import 'package:chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:chat_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class ChatInputBar extends ConsumerStatefulWidget {
  final String receiverId;

  const ChatInputBar({super.key, required this.receiverId});

  @override
  ConsumerState<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends ConsumerState<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final _imagePicker = ImagePickerService();
  final _audioRecorder = AudioRecorderService();

  bool isRecording = false;

  void _sendText() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final senderId = ref.read(currentUserProvider)!.id;

    final msg = ChatMessage(
      id: const Uuid().v4(),
      senderId: senderId,
      receiverId: widget.receiverId,
      text: text,
      timestamp: DateTime.now(),
    );

    ref.read(chatMessagesProvider.notifier).sendMessage(msg);
    _controller.clear();
  }

  Future<void> _sendImage() async {
    final file = await _imagePicker.pickImageFromGallery();
    if (file == null) return;

    final senderId = ref.read(currentUserProvider)!.id;

    final msg = ChatMessage(
      id: const Uuid().v4(),
      senderId: senderId,
      receiverId: widget.receiverId,
      text: '',
      imageUrl: file.path,
      timestamp: DateTime.now(),
    );

    ref.read(chatMessagesProvider.notifier).sendMessage(msg);
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      final path = await _audioRecorder.stopRecording();
      if (path != null) {
        final senderId = ref.read(currentUserProvider)!.id;

        final msg = ChatMessage(
          id: const Uuid().v4(),
          senderId: senderId,
          receiverId: widget.receiverId,
          text: '',
          audioPath: path,
          timestamp: DateTime.now(),
        );

        ref.read(chatMessagesProvider.notifier).sendMessage(msg);
      }
    } else {
      await _audioRecorder.startRecording();
    }

    setState(() {
      isRecording = !isRecording;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.image), onPressed: _sendImage),
          IconButton(
            icon: Icon(isRecording ? Icons.stop : Icons.mic),
            onPressed: _toggleRecording,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Type a message'),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: _sendText),
        ],
      ),
    );
  }
}
