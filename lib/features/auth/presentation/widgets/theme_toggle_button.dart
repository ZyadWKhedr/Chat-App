import 'package:chat_app/core/theme/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return IconButton(
      icon: Icon(
        themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
        color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
      ),
      onPressed: () {
        final isDark = themeMode == ThemeMode.dark;
        ref.read(themeNotifierProvider.notifier).toggleTheme(!isDark);
      },
    );
  }
}
