import 'package:flutter/material.dart';
import 'package:kirby_port_app/model/topic_model.dart';
import 'package:kirby_port_app/view_model/topic_view_model.dart';
import 'package:provider/provider.dart';

class TopicFilterScreen extends StatelessWidget {
  const TopicFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TopicViewModel>(
      builder: (context, topicViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("주제별 필터"),
            centerTitle: true,
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
                return ChoiceChip(
                  label: Text(topic.name),
                  selected: topicViewModel.selectedTopicIds.contains(topic.id),
                  onSelected: (selected) => topicViewModel.toggleTopicSelection(topic.id!),
                );
              }).toList(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              final topicName = await _showAddTopicDialog(context);
              if (topicName != null && context.mounted) {
                Topic topic = Topic(name: topicName, createdAt: DateTime.now().toString());
                Provider.of<TopicViewModel>(context, listen: false).addTopic(topic);
              }
            },
          ),
        );
      },
    );
  }

  Future<String?> _showAddTopicDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String? topic;
        return AlertDialog(
          title: const Text("주제 추가"),
          content: TextField(
            onChanged: (value) => topic = value,
            decoration: const InputDecoration(hintText: "주제를 입력하세요."),
          ),
          actions: <Widget>[
            TextButton(child: const Text("취소"), onPressed: () => Navigator.of(context).pop()),
            TextButton(child: const Text("확인"), onPressed: () => Navigator.of(context).pop(topic)),
          ],
        );
      },
    );
  }
}
