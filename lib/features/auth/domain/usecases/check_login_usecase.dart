import 'package:chat_app/features/auth/domain/repositories/auth_repository.dart';

class CheckIsLoggedInUseCase {
  final AuthRepository repository;

  CheckIsLoggedInUseCase(this.repository);

  Future<bool> call() => repository.isLoggedIn();
}
