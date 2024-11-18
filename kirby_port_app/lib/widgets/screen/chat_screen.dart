import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<Map<String, String>> users = [
    {'userId': 'user1', 'name': 'Elice'},
    {'userId': 'user2', 'name': 'Bob'},
    {'userId': 'user3', 'name': 'Charlie'},
    {'userId': 'user4', 'name': 'Diana'},
  ];

  String? selectedUserId; // 선택된 사용자 ID
  String? selectedUserName; // 선택된 사용자 이름
  final List<Map<String, dynamic>> messages = []; // 채팅 메시지 리스트
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Widget> floatingHearts = []; // 하트 애니메이션 리스트

  String title = "오징어게임 2 1화"; // 방송 제목
  late IO.Socket socket; // Socket.IO 클라이언트

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io(
      'http://10.10.6.123:3000', // 서버 IP 주소
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    // 서버와 연결되었을 때 사용자 이름 등록
    socket.onConnect((_) {
      print('Connected to Socket.IO server');
      if (selectedUserName != null) {
        print('Registering user: $selectedUserName'); // 디버깅 로그 추가
        socket.emit('register', selectedUserName); // 사용자 이름 전송
      } else {
        print('No user selected for registration');
      }
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });

    // 서버에서 메시지 수신
    socket.on('chat message', (data) {
      print('Message received: $data');

      final isMine = data['senderId'] == socket.id;
      setState(() {
        messages.add({
          'text': data['message'],
          'isMine': isMine,
          'senderName': data['senderName'],
        });
      });

      // 새로운 메시지가 추가되면 스크롤을 아래로 이동
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      socket.emit('chat message', {
        'text': text,
        'userId': selectedUserId,
        'senderName': selectedUserName,
      });

      messageController.clear();
    }
  }

  void _showHearts() {
    setState(() {
      for (int i = 0; i < 10; i++) {
        floatingHearts.add(_buildHeart());
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        floatingHearts.clear();
      });
    });
  }

  Widget _buildHeart() {
    final random = Random();
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
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    _scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 사용자 선택 화면
    if (selectedUserId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('사용자 선택'),
          backgroundColor: Colors.grey.shade700,
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(
                user['name']!,
                style: const TextStyle(fontSize: 18),
              ),
              onTap: () {
                // 사용자를 선택하면 ID와 이름을 저장하고 서버에 등록
                setState(() {
                  selectedUserId = user['userId'];
                  selectedUserName = user['name'];
                });

                if (socket.connected) {
                  print('Sending register event for user: $selectedUserName');
                  socket.emit('register', selectedUserName); // 사용자 이름 등록
                }
              },
            );
          },
        ),
      );
    }

    // 채팅 화면
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "LIVE 🟡",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMine = message['isMine'] as bool;
                        final senderName = message['senderName'] ?? "Unknown";
                        return Align(
                          alignment: isMine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: isMine
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (!isMine)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    senderName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isMine
                                      ? Colors.red.shade500
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  message['text'],
                                  style: TextStyle(
                                    color: isMine ? Colors.white : Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: GestureDetector(
                            onLongPress: _showHearts,
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: sendMessage,
                            icon: const Icon(Icons.send, color: Colors.red),
                          ),
                          hintText: "메시지를 입력하세요...",
                          filled: true,
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: floatingHearts,
          ),
        ],
      ),
    );
  }
}

class AnimatedHeart extends StatefulWidget {
  final Duration duration;
  final double endY;
  final double size;

  const AnimatedHeart({
    super.key,
    required this.duration,
    required this.endY,
    required this.size,
  });

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _yAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _yAnimation = Tween<double>(begin: 0, end: widget.endY).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_yAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Icon(
              Icons.favorite,
              size: widget.size,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}


//how to use socket.io

