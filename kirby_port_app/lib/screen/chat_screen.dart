import 'package:flutter/material.dart';
import 'package:kirby_port_app/view_model/chat_view_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final viewModel = ChatViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.initialize('http://192.168.35.15:3000');
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 이름 선택 화면
    if (viewModel.selectedUserId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('사용자 선택'),
          backgroundColor: Colors.grey.shade700,
        ),
        body: ListView.builder(
          itemCount: viewModel.users.length,
          itemBuilder: (context, index) {
            final user = viewModel.users[index];
            return ListTile(
              title: Text(
                user['name']!,
                style: const TextStyle(fontSize: 18),
              ),
              onTap: () {
                setState(() {
                  viewModel.selectedUserId = user['userId'];
                  viewModel.selectedUserName = user['name'];
                });
                viewModel.registerUser(); // 사용자 등록
              },
            );
          },
        ),
      );
    }

    // 채팅 화면
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: viewModel.messagesNotifier,
      builder: (context, messages, _) {
        return Scaffold(
          backgroundColor: Colors.grey.shade900,
          appBar: AppBar(
            backgroundColor: Colors.grey.shade900,
            title: const Text(
              "오징어게임 2 1화",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
                      color: Colors.white,
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
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          controller: viewModel.scrollController,
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
                                            : Colors.black,
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
                            controller: viewModel.messageController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                  onPressed: () =>
                                      viewModel.showHearts(context),
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )),
                              suffixIcon: IconButton(
                                onPressed: viewModel.sendMessage,
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
                valueListenable: viewModel.heartsNotifier,
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
