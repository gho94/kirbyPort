import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void initializeSocket(
      String url, String? nickname, Function onMessageReceived) {
    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    // 서버와 연결되었을 때 사용자 이름 등록
    socket.onConnect((_) {
      if (nickname != null) {
        socket.emit('register', nickname); // 사용자 이름 전송
      }
    });

    socket.onDisconnect((_) {});

    // 서버에서 메시지 수신
    socket.on('chat message', (data) {
      onMessageReceived(data);
    });
  }

  void sendMessage(String text, String? userId, String? senderName) {
    if (socket.connected) {
      socket.emit('chat message', {
        'text': text,
        'userId': userId,
        'senderName': senderName,
      });
    }
  }

  void dispose() {
    socket.disconnect();
    socket.dispose();
  }
}
