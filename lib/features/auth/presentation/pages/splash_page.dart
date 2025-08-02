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

    ref.listen(splashNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (isLoggedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(seconds: 2), () {
              final route = isLoggedIn ? AppRoutes.listChat : AppRoutes.login;
              context.go(route);
            });
          });
        },
      );
    });

    return Scaffold(
      body: Center(
        child: splashAsync.when(
          loading:
              () => Image.asset(
                'assets/images/logo.png',
                width: 50.sp,
                height: 50.sp,
              ),
          error: (err, stack) => Text('Error: $err'),
          data:
              (_) => Image.asset(
                'assets/images/logo.png',
                width: 50.sp,
                height: 50.sp,
              ),
        ),
      ),
    );
  }
}
