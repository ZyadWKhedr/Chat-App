import 'package:chat_app/core/route/routes.dart';
import 'package:chat_app/core/theme/text_styles.dart';
import 'package:chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:chat_app/features/auth/presentation/widgets/auth_redirected_text.dart';
import 'package:chat_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:chat_app/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:chat_app/features/auth/presentation/widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const ThemeToggleButton(),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.sp),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.signUpTitle, style: AppTextStyles.heading1(context)),
              SizedBox(height: 1.h),
              Text(t.signUpSubtitle, style: AppTextStyles.heading2(context)),
              SizedBox(height: 3.h),

              // Name field
              CustomTextFormField(
                hintText: t.nameHint,
                controller: nameController,
              ),
              SizedBox(height: 3.h),
              CustomTextFormField(
                hintText: t.emailHint,
                controller: emailController,
              ),
              SizedBox(height: 3.h),
              CustomTextFormField(
                hintText: t.passwordHint,
                controller: passwordController,
                isPassword: true,
              ),
              SizedBox(height: 4.h),
              CustomButton(
                text: t.signUpButton,
                onPressed: () async {
                  await ref.read(authStateProvider.notifier).signOut(context);
                  await ref
                      .read(authStateProvider.notifier)
                      .signUp(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        context,
                      );
                },
              ),
              SizedBox(height: 4.h),
              AuthRedirectText(
                isLogin: false,
                onTap: () => context.go(AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
