import 'package:flutter/foundation.dart';
import 'package:kirby_port_app/model/room_model.dart';
import 'package:kirby_port_app/service/room_manager.dart';
import 'package:kirby_port_app/service/room_topic_manager.dart';

class RoomViewModel extends ChangeNotifier {
  final RoomManager _roomManager = RoomManager();
  final RoomTopicManager _roomTopicManager = RoomTopicManager();

  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  bool _loading = false;
  bool get loading => _loading;

  RoomViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _roomManager.initializeDatabase();
    //await getRooms();
  }

  Future<List<Room>> getRooms() async {
    _loading = true;
    notifyListeners();

    _rooms = await _roomManager.getRooms();
    _loading = false;
    notifyListeners();

    return _rooms;
  }

  Future<List<Room>> getMyRooms() async {
    _loading = true;
    notifyListeners();

    _rooms = await _roomManager.getMyRooms();
    _loading = false;
    notifyListeners();

    return _rooms;
  }

  Future<void> getFilteredRooms(List<int> selectedTopicIds) async {
    _loading = true;
    notifyListeners();

    final roomIds = await _roomTopicManager.getRoomTopicsByTopicIds(selectedTopicIds);
    _rooms = await _roomManager.getFilteredRooms(roomIds);

    _loading = false;
    notifyListeners();
  }

  Future<void> getFilteredMyRooms(List<int> selectedTopicIds) async {
    _loading = true;
    notifyListeners();

    final roomIds = await _roomTopicManager.getRoomTopicsByTopicIds(selectedTopicIds);
    _rooms = await _roomManager.getFilteredMyRooms(roomIds);

    _loading = false;
    notifyListeners();
  }

  Future<int> addRoom(Room room) async {
    int roomId = await _roomManager.addRoom(room);
    getRooms();

    return roomId;
  }

  Future<void> updateReserveYn({required int roomId, required String reserveYn, required String updatedAt}) async {
    await _roomManager.updateReserveYn(roomId, reserveYn, updatedAt);
    getRooms();
  }

  Future<void> removeRoom(int roomId) async {
    await _roomManager.deleteRoom(roomId);
    getRooms();
  }
}
