import 'package:chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListPage extends ConsumerWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final users = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: users.when(
        data:
            (list) => ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, index) {
                final user = list[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl ?? ''),
                    child: user.imageUrl == null ? Text(user.name[0]) : null,
                  ),
                  title: Text(user.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(targetUser: user),
                      ),
                    );
                  },
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
