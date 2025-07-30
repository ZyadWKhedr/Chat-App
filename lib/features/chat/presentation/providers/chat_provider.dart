import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../data/datasources/socket_service.dart';

final socketServiceProvider = Provider((ref) {
  final socketService = SocketService();
  socketService.connect(); // Ensure it’s connected when the app starts
  return socketService;
});

final allUsersProvider = FutureProvider<List<UserEntity>>((ref) async {
  final authRepo = ref.read(authRepositoryProvider);
  return await authRepo.getAllUsers(); // Implement this in your repo
});


final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final socketService = ref.read(socketServiceProvider);
  return ChatRepositoryImpl(socketService);
});

final sendMessageUseCaseProvider = Provider((ref) {
  final repo = ref.read(chatRepositoryProvider);
  return SendMessageUseCase(repo);
});

final chatMessagesProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
      final repo = ref.read(chatRepositoryProvider);
      final notifier = ChatNotifier(ref, repo);
      notifier._startListening();
      return notifier;
    });

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref ref;
  final ChatRepository repository;

  ChatNotifier(this.ref, this.repository) : super([]);

  void _startListening() {
    ref.read(socketServiceProvider).connect();

    repository.getMessagesStream().listen((message) {
      state = [...state, message];
    });
  }

  void sendMessage(ChatMessage message) {
    ref.read(sendMessageUseCaseProvider).call(message);
    state = [...state, message];
  }
}
