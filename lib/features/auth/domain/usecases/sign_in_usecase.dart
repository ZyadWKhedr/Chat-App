import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repo;

  SignInUseCase(this.repo);

  Future<void> call(String email, String password) {
    return repo.signInWithEmail(email, password);
  }
}
