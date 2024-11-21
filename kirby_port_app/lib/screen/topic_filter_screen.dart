import 'package:flutter/material.dart';
import 'package:kirby_port_app/component/topic_container.dart';
import 'package:kirby_port_app/model/topic_model.dart';
import 'package:go_router/go_router.dart';

import 'package:kirby_port_app/view_model/topic_view_model.dart';
import 'package:provider/provider.dart';

class TopicFilterScreen extends StatelessWidget {
  const TopicFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TopicViewModel>(
      builder: (context, topicViewModel, child) {
        final TextEditingController textController = TextEditingController();
        return Scaffold(
          appBar: AppBar(
            title: const Text("주제별 필터"),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              color: Colors.red[900],
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.check,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 20.0,
              runSpacing: 20.0,
              children: topicViewModel.topics.map((topic) {
                return GestureDetector(
                  onLongPress: () => _showConfirmationDialog(context, topic, topicViewModel),
                  onTap: () => topicViewModel.toggleTopicSelection(topic.id!),
                  child: TopicContainer(
                    text: topic.name,
                    isSelected: topicViewModel.selectedTopicIds.contains(topic.id),
                  ),
                );
              }).toList(),
            ),
          ),
          bottomSheet: Container(
            color: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.white,
                          controller: textController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                final topicName = textController.text.trim();
                                if (topicName.isNotEmpty) {
                                  final newTopic = Topic(
                                    name: topicName,
                                    createdAt: DateTime.now().toString(),
                                  );
                                  topicViewModel.addTopic(newTopic);
                                  textController.clear(); // 텍스트 필드 초기화
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
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void _showConfirmationDialog(BuildContext context, Topic topic, TopicViewModel topicViewModel) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.15),
      title: Text(
        "정말 삭제 하시겠습니까?",
        style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text(
            "NO",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "'${topic.name}' 토픽이 삭제되었습니다.",
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
            topicViewModel.deleteTopic(topic.id!);
            context.pop();
          },
          child: const Text(
            "YES",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}
