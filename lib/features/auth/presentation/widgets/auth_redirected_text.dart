import 'package:chat_app/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final l = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? l.dontHaveAccount : l.haveAccount,
          style: AppTextStyles.bodyLarge(context),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            isLogin ? l.loginButton : l.signUpButton,
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
