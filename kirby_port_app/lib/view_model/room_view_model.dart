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
    await getRooms();
  }

  Future<void> getRooms({int page = 1, int pageSize = 10}) async {
    _loading = true;
    notifyListeners();

    List<Room> allRooms = await _roomManager.getRooms(page: page, pageSize: pageSize);
    _rooms = _filterExpiredRooms(allRooms);

    // List<Room> newRooms = await _roomManager.getRooms(page: page, pageSize: pageSize);
    // if (page == 1) {
    //   _rooms = newRooms;
    // } else {
    //   _rooms.addAll(newRooms);
    // }

    _loading = false;
    notifyListeners();
  }

  List<Room> _filterExpiredRooms(List<Room> rooms) {
    DateTime now = DateTime.now();
    return rooms.where((room) {
      DateTime endTime = DateTime.parse(room.endTime);
      return endTime.isAfter(now);
    }).toList();
  }

  Future<void> loadMoreRooms() async {
    if (_loading) return;

    _currentPage++;
    await getRooms(page: _currentPage, pageSize: _pageSize);
  }

  Future<void> addRoom(Room room) async {
    await _roomManager.addRoom(room);
    _rooms.add(room);
    notifyListeners();
  }

  Future<void> updateReserveYn({required int roomId, required String reserveYn, required String updatedAt}) async {
    await _roomManager.updateReserveYn(roomId, reserveYn, updatedAt);
    getRooms();
  }
}
