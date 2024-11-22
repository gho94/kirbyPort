import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.isMine,
    required this.senderName,
    required this.message,
  });

  final bool isMine;
  final dynamic senderName;
  final Map<String, dynamic> message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.symmetric(
              vertical: 4,
              // horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: isMine ? Colors.red.shade500 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message['text'],
              style: TextStyle(
                color: isMine ? Colors.white : Colors.black, //서버로 확인
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
