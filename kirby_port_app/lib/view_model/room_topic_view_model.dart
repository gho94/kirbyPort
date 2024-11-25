import 'package:flutter/foundation.dart';
import 'package:kirby_port_app/model/room_topic_model.dart';
import 'package:kirby_port_app/service/room_topic_manager.dart';

class RoomTopicViewModel extends ChangeNotifier {
  final RoomTopicManager _roomTopicManager = RoomTopicManager();

  List<RoomTopic> _roomTopics = [];
  List<RoomTopic> get roomTopics => _roomTopics;

  RoomTopicViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _roomTopicManager.initializeDatabase();
    await getRoomTopics();
  }

  Future<List<RoomTopic>> getRoomTopics() async {
    _roomTopics = await _roomTopicManager.getRoomTopics();
    notifyListeners();

    return _roomTopics;
  }

  // Future<List<RoomTopic>> getTopicsByRoomId(int roomId) async {
  //   _roomTopics = await _roomTopicManager.getTopicsByRoomId(roomId);
  //   notifyListeners();

  //   return _roomTopics;
  // }

  // Future<List<RoomTopic>> getRoomTopicsByTopicId(int topicId) async {
  //   _roomTopics = await _roomTopicManager.getRoomTopicsByTopicId(topicId);
  //   notifyListeners();

  //   return _roomTopics;
  // }

  Future<void> addRoomTopic(RoomTopic roomTopic) async {
    await _roomTopicManager.addRoomTopic(roomTopic);
    notifyListeners();
    //getTopicsByRoomId(roomTopic.roomId);
  }

  Future<void> removeRoomTopicByRoomId(int roomId) async {
    await _roomTopicManager.removeRoomTopicByRoomId(roomId);
    getRoomTopics();
  }

  Future<void> removeRoomTopicByTopicId(int topicId) async {
    await _roomTopicManager.removeRoomTopicByTopicId(topicId);
    getRoomTopics();
  }
}
