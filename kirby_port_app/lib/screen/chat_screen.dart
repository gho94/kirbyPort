import 'package:flutter/material.dart';
import 'package:kirby_port_app/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatViewModel chatViewModel;

  @override
  void initState() {
    super.initState();
    chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    String nickname = chatViewModel.getNickname ?? "default";
    chatViewModel.initializeUsers(nickname);
    chatViewModel.initialize('http://192.168.200.151:3000');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 채팅 화면
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: chatViewModel.messagesNotifier,
      builder: (context, messages, _) {
        return Scaffold(
          backgroundColor: Colors.grey.shade900,
          appBar: AppBar(
            backgroundColor: Colors.grey.shade900,
            title: const Text(
              "오징어게임 2 1화",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
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
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white, // 채팅방 확인 예정(서버열려야함)
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          controller: chatViewModel.scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isMine = message['isMine'] as bool;
                            final senderName =
                                message['senderName'] ?? "Unknown";
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
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
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
                                      vertical: 4,
                                      // horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isMine
                                          ? Colors.red.shade500
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      message['text'],
                                      style: TextStyle(
                                        color: isMine
                                            ? Colors.white
                                            : Colors.black, //서버로 확인
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
                            cursorColor: Colors.white,
                            controller: chatViewModel.messageController,
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                  onPressed: () =>
                                      chatViewModel.showHearts(context),
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  final text = chatViewModel
                                      .messageController.text
                                      .trim();
                                  if (text.isNotEmpty) {
                                    final deviceId = chatViewModel.deviceId;
                                    final nickname =
                                        chatViewModel.getNickname ?? "default";

                                    if (deviceId != null &&
                                        deviceId.isNotEmpty &&
                                        nickname.isNotEmpty) {
                                      chatViewModel.sendMessage(
                                          deviceId, nickname);
                                      chatViewModel.messageController.clear();
                                    }
                                  }
                                },
                                icon: const Icon(Icons.send, color: Colors.red),
                              ),
                              hintText: "메시지를 입력하세요...",
                              hintStyle: const TextStyle(color: Colors.grey),
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
              ValueListenableBuilder<List<Widget>>(
                valueListenable: chatViewModel.heartsNotifier,
                builder: (context, hearts, _) {
                  return Stack(children: hearts);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
