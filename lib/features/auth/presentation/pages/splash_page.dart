import 'package:chat_app/core/route/routes.dart';
import 'package:chat_app/features/auth/presentation/providers/auth_provider.dart'
    show splashNotifierProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashAsync = ref.watch(splashNotifierProvider);

    return splashAsync.when(
      loading:
          () => Scaffold(
            body: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 50.sp,
                height: 50.sp,
              ),
            ),
          ),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (isLoggedIn) {
        Future.microtask(() {
          if (isLoggedIn) {
            context.go(AppRoutes.listChat);
          } else {
            context.go(AppRoutes.login);
          }
        });

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
