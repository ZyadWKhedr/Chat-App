import 'package:chat_app/core/exceptions/firebase_exception_handler.dart';
import 'package:chat_app/features/auth/data/datasources/local_auth_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:chat_app/core/utils/toasts.dart';
import 'package:chat_app/features/auth/data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:chat_app/core/exceptions/auth_exception.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localDataSource = ref.read(authLocalDataSourceProvider);
  return AuthRepoImpl(localDataSource);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(); // or however you instantiate it
});

final splashNotifierProvider = FutureProvider<bool>((ref) async {
  final repo = ref.read(authRepositoryProvider);
  return await repo.isLoggedIn();
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(data: (user) => user);
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
      final authRepo = ref.watch(authRepositoryProvider);
      return AuthNotifier(authRepo);
    });

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepository repository;

  AuthNotifier(this.repository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (_) {
      ToastService.show('Failed to load current user');
      state = const AsyncValue.data(null);
    }
  }

  Future<void> signUp(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    final loc = AppLocalizations.of(context)!;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ToastService.show(loc.authEmptyFieldsError);
      return;
    }

    try {
      state = const AsyncValue.loading();
      final user = await repository.signUpWithEmail(name, email, password);
      state = AsyncValue.data(user);
      ToastService.show(loc.authSignUpSuccess);
    } on AuthException catch (e) {
      ToastService.show(e.code);
      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e) {
      final msg = FirebaseExceptionHandler.getMessage(context, e);
      ToastService.show(msg ?? e.message ?? loc.authUnknown);
      state = const AsyncValue.data(null);
    } catch (_) {
      ToastService.show(loc.authSignUpFailed);
      state = const AsyncValue.data(null);
    }
  }

  Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    final loc = AppLocalizations.of(context)!;

    if (email.isEmpty || password.isEmpty) {
      ToastService.show(loc.authEmptyFieldsError ?? 'Please fill all fields');
      return;
    }

    try {
      state = const AsyncLoading();
      final user = await repository.signInWithEmail(email, password);
      state = AsyncData(user);
      ToastService.show(loc.authSignInSuccess);
    } on AuthException catch (e) {
      ToastService.show(e.code);
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      final msg = FirebaseExceptionHandler.getMessage(context, e);
      ToastService.show(msg ?? e.message ?? loc.authUnknown);
      state = const AsyncData(null);
    } catch (_) {
      ToastService.show(loc.authSignInFailed);
      state = const AsyncData(null);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    try {
      state = const AsyncValue.loading();
      final user = await repository.signInWithGoogle();
      state = AsyncValue.data(user);
      ToastService.show(loc.authSignInGoogleSuccess);
    } catch (_) {
      ToastService.show(loc.authSignInGoogleFailed);
      state = const AsyncValue.data(null);
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    try {
      state = const AsyncValue.loading();
      final user = await repository.signInWithFacebook();
      state = AsyncValue.data(user);
      ToastService.show(loc.authSignInFacebookSuccess);
    } catch (_) {
      ToastService.show(loc.authSignInFacebookFailed);
      state = const AsyncValue.data(null);
    }
  }

  Future<void> signOut(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    try {
      state = const AsyncValue.loading();
      await repository.signOut();
      state = const AsyncValue.data(null);
      ToastService.show(loc.authSignOutSuccess);
    } catch (_) {
      ToastService.show(loc.authSignOutFailed);
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    if (email.isEmpty) {
      ToastService.show(loc.authEmptyFieldsError ?? 'Please enter your email');
      return;
    }

    try {
      state = const AsyncValue.loading();
      await repository.sendPasswordResetEmail(email);
      ToastService.show(loc.authResetPasswordSent);
      state = AsyncValue.data(state.value);
    } catch (_) {
      ToastService.show(loc.authResetPasswordFailed);
      state = AsyncValue.data(state.value);
    }
  }
}
