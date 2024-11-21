import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kirby_port_app/component/animated_heart.dart';
import 'package:kirby_port_app/service/socket_service.dart';
import '../service/device_info_manager.dart';

class ChatViewModel with ChangeNotifier {
  final SocketService socketService = SocketService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<List<Map<String, dynamic>>> messagesNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);
  final ValueNotifier<List<Widget>> heartsNotifier = ValueNotifier([]);
  final DeviceInfoManager deviceInfoManager = DeviceInfoManager();

  String? nickname;
  String? deviceId;
  String? get getNickname => nickname;
  String? get getDeviceId => deviceId;
  bool _isInitialized = false;

  void setUsers(String nickname) {
    this.nickname = nickname;
    notifyListeners();
  }

  Future<void> initializeUsers(String nickname) async {
    if (!_isInitialized) {
      deviceId = await deviceInfoManager.getDeviceId();
      this.nickname = nickname;
      _isInitialized = true;
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
          messagesNotifier.value = [
            ...messagesNotifier.value,
            {
              'text': data['message'],
              'isMine': isMine,
              'senderName': data['senderName'],
            }
          ];
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
    final List<Widget> hearts = List.generate(10, (_) {
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

    // heartsNotifier에 추가
    heartsNotifier.value = [...heartsNotifier.value, ...hearts];

    // 일정 시간 후 하트 제거
    Future.delayed(const Duration(seconds: 2), () {
      heartsNotifier.value = [];
    });
  }

  void scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () => scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    socketService.dispose();
    messageController.dispose();
    scrollController.dispose();
  }
}
