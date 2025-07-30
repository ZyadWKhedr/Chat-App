import 'package:chat_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signUpWithEmail(
    String name,
    String email,
    String password,
  );
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity?> getCurrentUser();
  Future<void> signOut();
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> signInWithFacebook();
  Future<void> sendPasswordResetEmail(String email);
}