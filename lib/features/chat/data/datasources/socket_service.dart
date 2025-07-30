import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  void connect() {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      'http://localhost:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket!.connect();
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_socket?.connected ?? false) {
      _socket!.emit('send_message', message);
    }
  }

  void listenMessages(Function(Map<String, dynamic>) onMessageReceived) {
    _socket?.on('receive_message', (data) {
      onMessageReceived(data);
    });
  }

  void dispose() {
    _socket?.dispose();
  }
}
