import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:chat_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  final UserEntity targetUser;

  const ChatPage({super.key, required this.targetUser});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(authStateProvider);

    return currentUserAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, stack) =>
              Scaffold(body: Center(child: Text('Error loading user'))),
      data: (currentUser) {
        if (currentUser == null) {
          return Scaffold(body: Center(child: Text('User not authenticated')));
        }

        final messages = ref.watch(chatMessagesProvider);

        return Scaffold(
          appBar: AppBar(title: Text(widget.targetUser.name)),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUser.id;
                    return MessageBubble(message: msg, isMe: isMe);
                  },
                ),
              ),
              ChatInputBar(receiverId: widget.targetUser.id),
            ],
          ),
        );
      },
    );
  }
}
