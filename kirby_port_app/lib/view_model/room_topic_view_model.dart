import 'package:flutter/foundation.dart';
import 'package:kirby_port_app/model/room_topic_model.dart';
import 'package:kirby_port_app/service/room_topic_manager.dart';

class RoomTopicViewModel extends ChangeNotifier {
  final RoomTopicManager _roomTopicManager = RoomTopicManager();

  List<RoomTopic> _roomTopics = [];
  List<RoomTopic> get roomTopics => _roomTopics;

  bool _isInitialized = false; // 초기화 상태 추적
  bool get isInitialized => _isInitialized;

  RoomTopicViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _roomTopicManager.initializeDatabase();
    _isInitialized = true;
    await getRoomTopics();
  }

  Future<List<RoomTopic>> getRoomTopics() async {
    _roomTopics = await _roomTopicManager.getRoomTopics();
    notifyListeners();

    return _roomTopics;
  }

  Future<List<RoomTopic>> getTopicsByRoomId(int roomId) async {
    _roomTopics = await _roomTopicManager.getTopicsByRoomId(roomId);
    notifyListeners();

    return _roomTopics;
  }

  Future<void> addRoomTopic(RoomTopic roomTopic) async {
    await _roomTopicManager.addRoomTopic(roomTopic);
    notifyListeners();
    //getTopicsByRoomId(roomTopic.roomId);
  }
}
