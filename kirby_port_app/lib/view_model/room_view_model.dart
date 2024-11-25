import 'package:flutter/foundation.dart';
import 'package:kirby_port_app/model/room_model.dart';
import 'package:kirby_port_app/service/room_manager.dart';
import 'dart:async';

class RoomViewModel extends ChangeNotifier {
  final RoomManager _roomManager = RoomManager();
  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;
  Timer? _timer;

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

  void _startRoomCleanup() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      checkAndRemoveExpiredRooms();
    });
  }

  void checkAndRemoveExpiredRooms() async {
    final currentTime = DateTime.now();
    List<Room> roomsToRemove = [];

    for (var room in _rooms) {
      DateTime endDate = DateTime.parse(room.endTime);
      if (currentTime.isAfter(endDate)) {
        roomsToRemove.add(room);
      }
    }
    for (var room in roomsToRemove) {
      await removeRoom(room.id!);
    }

    await getRooms();
    notifyListeners();
  }

  void stopRoomCleanup() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopRoomCleanup();
    super.dispose();
  }
}
