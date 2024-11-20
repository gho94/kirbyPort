import 'package:flutter/material.dart';
import 'package:kirby_port_app/component/topic_container.dart';
import 'package:kirby_port_app/model/topic_model.dart';
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
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check),
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
                  // todo : 구현 해야함
                  onLongPress: () => topicViewModel.deleteTopic(topic.id!),
                  onTap: () => topicViewModel.toggleTopicSelection(topic.id!),
                  child: TopicContainer(
                    text: topic.name,
                    isSelected:
                        topicViewModel.selectedTopicIds.contains(topic.id),
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
                          controller: textController,
                          style: const TextStyle(color: Colors.white),
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
