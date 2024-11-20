import 'package:flutter/foundation.dart';
import 'package:kirby_port_app/model/room_model.dart';
import 'package:kirby_port_app/service/room_manager.dart';

class RoomViewModel extends ChangeNotifier {
  final RoomManager _roomManager = RoomManager();
  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  bool _loading = false;
  bool get loading => _loading;

  RoomViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _roomManager.initializeDatabase();
    await getRooms();
  }

  Future<List<Room>> getRooms() async {
    _loading = true;
    notifyListeners();

    _rooms = await _roomManager.getRooms();
    _loading = false;
    notifyListeners();

    return _rooms;
  }

  Future<void> addRoom(Room room) async {
    await _roomManager.addRoom(room);
    getRooms();
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
