import 'dart:developer';
import 'package:chat_app/core/exceptions/auth_exception.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  @override
Future<UserEntity> signInWithEmail(String email, String password) async {
  try {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user;
    if (user == null) throw const AuthException('user-not-found');
    return UserModel.fromFirebaseUser(user);
  } on FirebaseAuthException catch (e) {
    throw AuthException(e.code.replaceAll('.', ''));
  }
}

  @override
  Future<UserEntity> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    log('Starting signup for $email with name $name');

    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        throw Exception('Signup failed. No user returned.');
      }

      // Update display name
      await user.updateDisplayName(name);
      await user.reload(); // Refresh user data

      log('SIGN UP RESPONSE: ${user.uid} - ${user.email}');

      return UserModel.fromFirebaseUser(_firebaseAuth.currentUser!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Signup error');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserEntity> signInWithFacebook() {
    throw UnimplementedError('Sign in with Facebook is not implemented');
  }

  @override
  Future<UserEntity> signInWithGoogle() {
    throw UnimplementedError('Sign in with Google is not implemented');
  }
}
