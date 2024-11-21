import 'package:flutter/material.dart';
import 'package:kirby_port_app/model/message.dart';
import 'package:kirby_port_app/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatViewModel = context.watch<ChatViewModel>();
    // 채팅 화면
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
        actions: const [
          _LiveIcon(),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _ChatHistory(chatViewModel: chatViewModel),
              _InputTextField(chatViewModel: chatViewModel),
            ],
          ),
          Stack(children: chatViewModel.hearts),
        ],
      ),
    );
  }
}

class _LiveIcon extends StatelessWidget {
  const _LiveIcon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
    );
  }
}

class _InputTextField extends StatelessWidget {
  const _InputTextField({
    required this.chatViewModel,
  });

  final ChatViewModel chatViewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
              controller: chatViewModel.messageController,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                    onPressed: () => chatViewModel.showHearts(context),
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )),
                suffixIcon: IconButton(
                  onPressed: () {
                    final text = chatViewModel.messageController.text.trim();
                    if (text.isNotEmpty) {
                      final deviceId = chatViewModel.deviceId;
                      final nickname = chatViewModel.getNickname ?? "default";

                      if (deviceId != null &&
                          deviceId.isNotEmpty &&
                          nickname.isNotEmpty) {
                        chatViewModel.sendMessage(deviceId, nickname);
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
    );
  }
}

class _ChatHistory extends StatelessWidget {
  const _ChatHistory({
    required this.chatViewModel,
  });

  final ChatViewModel chatViewModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            controller: chatViewModel.scrollController,
            itemCount: chatViewModel.messages.length,
            itemBuilder: (context, index) {
              final message = chatViewModel.messages[index];
              final isMine = message['isMine'] as bool;
              final senderName = message['senderName'] ?? "Unknown";
              return Message(
                isMine: isMine,
                senderName: senderName,
                message: message,
              );
            },
          ),
        ),
      ),
    );
  }
}
