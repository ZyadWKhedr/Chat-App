import 'package:chat_app/core/route/routes.dart';
import 'package:chat_app/core/widgets/language_dialog.dart';
import 'package:chat_app/core/widgets/theme_toggle_button.dart';
import 'package:chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class UserListPage extends ConsumerWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(allUsersProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: () {
          ref.read(authStateProvider.notifier).signOut;
          context.go(AppRoutes.login);
        },
      ),
      body: users.when(
        data:
            (list) => CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: const ThemeToggleButton(),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.language),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const LanguageDialog(),
                        );
                      },
                    ),
                  ],

                  pinned: true,
                  floating: true,
                  expandedHeight: 100.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(AppLocalizations.of(context)!.users),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final user = list[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            user.imageUrl != null
                                ? NetworkImage(user.imageUrl!)
                                : null,
                        child:
                            user.imageUrl == null ? Text(user.name[0]) : null,
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
                  }, childCount: list.length),
                ),
              ],
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
