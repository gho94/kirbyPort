import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kirby_port_app/component/animated_heart.dart';
import 'package:kirby_port_app/service/socket_service.dart';
import '../service/device_info_manager.dart';

class ChatViewModel with ChangeNotifier {
  final String serverUrl;
  final SocketService socketService = SocketService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final DeviceInfoManager deviceInfoManager = DeviceInfoManager();

  List<Map<String, dynamic>> messages = [];
  List<Widget> hearts = [];

  String? nickname;
  String? deviceId;
  String? get getNickname => nickname;
  String? get getDeviceId => deviceId;
  bool _isInitialized = false;

  ChatViewModel({required this.serverUrl}) {
    initialize(serverUrl);
  }

  // void setUsers(String nickname) {
  //   this.nickname = nickname;
  //   notifyListeners();
  // }

  // void registerUser() {
  //   if (nickname != null) {
  //     socketService.socket.emit('register', nickname);
  //     notifyListeners(); // 상태 변경 알림
  //   }
  // }

  Future<void> initializeUsers(String nickname) async {
    if (!_isInitialized) {
      deviceId = await deviceInfoManager.getDeviceId();
      this.nickname = nickname;
      _isInitialized = true;

      socketService.socket.emit('register', nickname);

      notifyListeners();
    }
  }

  void initialize(String url) {
    if (!_isInitialized) {
      socketService.initializeSocket(
        url,
        nickname,
        (data) {
          final isMine = data['senderId'] == socketService.socket.id;
          messages.add({
            'text': data['message'],
            'isMine': isMine,
            'senderName': data['senderName'],
          });
          notifyListeners();
          scrollToBottom();
        },
      );
    }
  }

  void sendMessage(String deviceId, String nickname) {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      socketService.sendMessage(text, deviceId, nickname);
      messageController.clear();
    }
  }

  void showHearts(BuildContext context) {
    final random = Random();

    // 하트 생성
    hearts = List.generate(10, (_) {
      final double startX =
          random.nextDouble() * MediaQuery.of(context).size.width;
      final double endY = MediaQuery.of(context).size.height;

      return Positioned(
        left: startX,
        bottom: 0,
        child: AnimatedHeart(
          duration: Duration(milliseconds: 1000 + random.nextInt(1000)),
          endY: endY,
          size: 30.0 + random.nextDouble() * 20,
        ),
      );
    });

    notifyListeners(); // 상태 변경 알림

    // 일정 시간 후 하트 제거
    Future.delayed(const Duration(seconds: 2), () {
      hearts = [];
      notifyListeners(); // 상태 변경 알림
    });
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        ),
      );
    }
  }

  @override
  void dispose() {
    socketService.dispose();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
