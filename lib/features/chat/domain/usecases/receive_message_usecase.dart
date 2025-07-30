import '../repositories/chat_repository.dart';

class ReceiveMessageUsecase {
  final ChatRepository repository;

  ReceiveMessageUsecase(this.repository);

  void call() {
    repository.getMessagesStream();
  }
}
