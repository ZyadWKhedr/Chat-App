import 'package:chat_app/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AuthRedirectText extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onTap;

  const AuthRedirectText({
    super.key,
    required this.isLogin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? "Don't have an account? " : "Already have an account? ",
          style: AppTextStyles.bodyLarge(context),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            isLogin ? "Sign Up" : "Log In",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.blue,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
