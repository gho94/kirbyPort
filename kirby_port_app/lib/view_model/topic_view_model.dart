import 'package:flutter/material.dart';
import 'package:kirby_port_app/model/topic_model.dart';
import 'package:kirby_port_app/service/topic_manager.dart';

class TopicViewModel extends ChangeNotifier {
  final TopicManager _topicManager = TopicManager();

  List<Topic> _topics = [];
  final List<int> _selectedTopicIds = [];

  List<Topic> get topics => _topics;
  List<int> get selectedTopicIds => _selectedTopicIds;

  TopicViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _topicManager.initializeDatabase();
    getTopics();
  }

  Future<List<Topic>> getTopics() async {
    _topics = await _topicManager.getTopics();
    notifyListeners();

    return _topics;
  }

  Future<void> addTopic(Topic topic) async {
    await _topicManager.addTopic(topic);
    getTopics();
  }

  void toggleTopicSelection(int topicId) {
    if (_selectedTopicIds.contains(topicId)) {
      _selectedTopicIds.remove(topicId);
    } else {
      _selectedTopicIds.add(topicId);
    }
    notifyListeners();
  }

  void deleteTopic(int topicId) async {
    final topicManager = TopicManager();
    await topicManager.deleteTopic(topicId);
    _topics.removeWhere((topic) => topic.id == topicId);
    notifyListeners();
  }
}
