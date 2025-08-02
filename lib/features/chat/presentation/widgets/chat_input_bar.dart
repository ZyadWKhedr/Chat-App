import 'package:chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:chat_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatInputBar extends ConsumerStatefulWidget {
  final String receiverId;

  const ChatInputBar({super.key, required this.receiverId});

  @override
  ConsumerState<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends ConsumerState<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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
                  maxLines: null,

                  minLines: 1,
                  style: TextStyle(fontSize: 15.sp, color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,

                    isCollapsed: true,
                    hintText: AppLocalizations.of(context)!.chatHint,
                    hintStyle: TextStyle(color: Colors.grey),
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
