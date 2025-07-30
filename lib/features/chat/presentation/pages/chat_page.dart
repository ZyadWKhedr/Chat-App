import 'dart:io';
import 'package:chat_app/core/services/audio_recorder_service.dart';
import 'package:chat_app/core/services/image_picker_service.dart';
import 'package:chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:chat_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ImagePickerService _imagePickerService = ImagePickerService();
  final AudioRecorderService _audioRecorderService = AudioRecorderService();

  bool isRecording = false;

  void _sendTextMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final message = ChatMessage(
      id: const Uuid().v4(),
      senderId: 'user1',
      text: text,
      timestamp: DateTime.now(),
    );
    ref.read(chatMessagesProvider.notifier).sendMessage(message);
    _controller.clear();
  }

  Future<void> _sendImageMessage() async {
    final file = await _imagePickerService.pickImageFromGallery();
    if (file == null) return;

    final message = ChatMessage(
      id: const Uuid().v4(),
      senderId: 'user1',
      text: '',
      imageUrl: file.path,
      timestamp: DateTime.now(),
    );
    ref.read(chatMessagesProvider.notifier).sendMessage(message);
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      final path = await _audioRecorderService.stopRecording();
      if (path != null) {
        final message = ChatMessage(
          id: const Uuid().v4(),
          senderId: 'user1',
          text: '',
          audioPath: path,
          timestamp: DateTime.now(),
        );
        ref.read(chatMessagesProvider.notifier).sendMessage(message);
      }
    } else {
      await _audioRecorderService.startRecording();
    }

    setState(() {
      isRecording = !isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Test Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (msg.text.isNotEmpty) Text(msg.text),
                      if (msg.imageUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Image.file(File(msg.imageUrl!), height: 150),
                        ),
                      if (msg.audioPath != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: AudioPlayerWidget(filePath: msg.audioPath!),
                        ),
                      Text(
                        DateFormat('HH:mm').format(msg.timestamp),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _sendImageMessage,
          ),
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
          IconButton(icon: const Icon(Icons.send), onPressed: _sendTextMessage),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioRecorderService.dispose();
    super.dispose();
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String filePath;

  const AudioPlayerWidget({super.key, required this.filePath});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  void _togglePlay() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      await _player.play(DeviceFileSource(widget.filePath));
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
      onPressed: _togglePlay,
    );
  }
}
