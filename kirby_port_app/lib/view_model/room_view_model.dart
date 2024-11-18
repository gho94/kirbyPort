import 'package:flutter/foundation.dart';
import 'package:kirby_port_app/model/room_model.dart';
import 'package:kirby_port_app/service/room_manager.dart';

class RoomViewModel extends ChangeNotifier {
  final RoomManager _roomManager = RoomManager();
  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  int _currentPage = 0;
  final int _pageSize = 10;

  bool _loading = false;
  bool get loading => _loading;

  RoomViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _roomManager.initializeDatabase();
    getRooms();
  }

  Future<void> getRooms({int page = 1, int pageSize = 10}) async {
    _loading = true;
    notifyListeners();

    List<Room> newRooms = await _roomManager.getRooms(page: page, pageSize: pageSize);
    if (page == 1) {
      _rooms = newRooms;
    } else {
      _rooms.addAll(newRooms);
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadMoreRooms() async {
    if (_loading) return;

    _currentPage++;
    await getRooms(page: _currentPage, pageSize: _pageSize);
  }

  Future<void> addRoom(Room room) async {
    await _roomManager.addRoom(room);
    getRooms();
  }

  Future<void> updateReserveYn({required int roomId, required String reserveYn, required String updatedAt}) async {
    await _roomManager.updateReserveYn(roomId, reserveYn, updatedAt);
    getRooms();
  }
}
