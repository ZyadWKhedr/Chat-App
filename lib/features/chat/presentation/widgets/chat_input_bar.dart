import 'package:chat_app/core/services/audio_recorder_service.dart';
import 'package:chat_app/core/services/image_picker_service.dart';
import 'package:chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:chat_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _sendImage,
            tooltip: 'Send Image',
          ),
          IconButton(
            icon: Icon(isRecording ? Icons.stop : Icons.mic),
            onPressed: _toggleRecording,
            tooltip: isRecording ? 'Stop Recording' : 'Start Recording',
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                minHeight: 48,
                maxHeight: 120,
              ), // ~3 lines max
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.sp),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Scrollbar(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // allow growing
                  minLines: 1,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: 'Type a message...',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendText,
            tooltip: 'Send Message',
          ),
        ],
      ),
    );
  }
}
