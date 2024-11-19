import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kirby_port_app/component/animated_heart.dart';
import 'package:kirby_port_app/service/socket_service.dart';

class ChatViewModel {
  final SocketService socketService = SocketService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<List<Map<String, dynamic>>> messagesNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);
  final ValueNotifier<List<Widget>> heartsNotifier = ValueNotifier([]);

  final List<Map<String, String>> users = [
    {'userId': 'user1', 'name': 'Elice'},
    {'userId': 'user2', 'name': 'Bob'},
    {'userId': 'user3', 'name': 'Charlie'},
    {'userId': 'user4', 'name': 'Diana'},
  ];

  String? selectedUserId;
  String? selectedUserName;

  void initialize(String url) {
    socketService.initializeSocket(
      url,
      selectedUserName,
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

  void registerUser() {
    if (selectedUserName != null) {
      socketService.socket.emit('register', selectedUserName);
    }
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      socketService.sendMessage(text, selectedUserId, selectedUserName);
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

  void dispose() {
    socketService.dispose();
    messageController.dispose();
    scrollController.dispose();
  }
}
