import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repo;

  SignUpUseCase(this.repo);

  Future<void> call(String name, String email, String password) {
    return repo.signUpWithEmail(name, email, password);
  }
}
