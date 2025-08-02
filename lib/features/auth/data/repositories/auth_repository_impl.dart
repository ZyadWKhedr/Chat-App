import 'package:chat_app/core/exceptions/auth_exception.dart';
import 'package:chat_app/features/auth/data/datasources/local_auth_data_source.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthLocalDataSource localDataSource;

  AuthRepoImpl(this.localDataSource);

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
      await localDataSource.setLoggedIn(true);
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
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await localDataSource.setLoggedIn(true);
      final user = result.user;
      if (user == null) throw Exception('Signup failed. No user returned.');

      await user.updateDisplayName(name);

      final userModel = UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: name,
      );

      await _firestore
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Signup error');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn(); 
  }

  @override
  Future<void> setLoggedIn(bool value) {
    return localDataSource.setLoggedIn(value);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await localDataSource.setLoggedIn(false);
  }

  @override
  Future<UserEntity> signInWithFacebook() {
    throw UnimplementedError('Sign in with Facebook is not implemented');
  }

  @override
  Future<UserEntity> signInWithGoogle() {
    throw UnimplementedError('Sign in with Google is not implemented');
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    final snapshot = await _firestore.collection('users').get();

    return snapshot.docs
        .where((doc) => doc.id != currentUser.uid) // exclude yourself
        .map((doc) => UserModel.fromMap(doc.data()))
        .toList();
  }
}
