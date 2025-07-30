import 'package:chat_app/core/route/routes.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:chat_app/features/auth/presentation/pages/splash_page.dart';
import 'package:chat_app/features/chat/presentation/pages/user_list_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (context, state) => SplashPage()),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: AppRoutes.listChat,
      builder: (context, state) => UserListPage(),
    ),
  ],
);
