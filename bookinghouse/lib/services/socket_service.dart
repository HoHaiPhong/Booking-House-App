import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'api_service.dart';

class SocketService {
  late IO.Socket socket;

  void connect(int userId) {
    socket = IO.io(ApiService.baseUrl.replaceAll('/api', ''), <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to Socket.io');
      socket.emit('join_room', userId);
    });

    socket.onDisconnect((_) => print('Disconnected'));
  }

  void sendMessage(int senderId, int receiverId, String content) {
    socket.emit('send_message', {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
    });
  }

  void onMessageReceived(Function(dynamic) callback) {
    socket.on('receive_message', (data) {
      callback(data);
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
