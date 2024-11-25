import 'package:kirby_port_app/model/room_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RoomManager {
  static final RoomManager _instance = RoomManager._internal();
  factory RoomManager() => _instance;
  RoomManager._internal();

  late Database _database;
  bool isDatabaseInitialized = false;

  Future<Database> get database async {
    if (_database.isOpen) return _database;

    await initializeDatabase();
    return _database;
  }

  Future<void> initializeDatabase() async {
    if (!isDatabaseInitialized) {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, "room_database.db");

      _database = await openDatabase(
        path,
        onCreate: (db, version) async {
          await db.execute("""
            CREATE TABLE room (
              id          INTEGER PRIMARY KEY,
              name        TEXT, 
              start_time  TEXT, 
              end_time    TEXT,               
              player_id   INTEGER, 
              
              created_at  TEXT, 
              updated_at  TEXT,
              reserve_yn  TEXT
            )""");
        },
        version: 1,
      );
      isDatabaseInitialized = true;
    }
  }

  Future<List<Room>> getRooms() async {
    if (!isDatabaseInitialized) {
      await initializeDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database.query("room");
    return List.generate(maps.length, (index) => Room.fromMap(maps[index]));
  }

  Future<List<Room>> getMyRooms() async {
    if (!isDatabaseInitialized) {
      await initializeDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database.query(
      "room",
      where: "reserve_yn = ?",
      whereArgs: ['Y'],
    );

    return List.generate(maps.length, (index) => Room.fromMap(maps[index]));
  }

  Future<List<Room>> getFilteredRooms(List<int> selectedRoomIds) async {
    if (!isDatabaseInitialized) {
      await initializeDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database.query(
      "room",
      where: "id IN (${List.filled(selectedRoomIds.length, '?').join(',')})",
      whereArgs: selectedRoomIds,
    );

    return List.generate(maps.length, (index) => Room.fromMap(maps[index]));
  }

  Future<List<Room>> getFilteredMyRooms(List<int> selectedRoomIds) async {
    if (!isDatabaseInitialized) {
      await initializeDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database.query(
      "room",
      where: "reserve_yn = ? AND id IN (${List.filled(selectedRoomIds.length, '?').join(',')})",
      whereArgs: ['Y', ...selectedRoomIds],
    );

    return List.generate(maps.length, (index) => Room.fromMap(maps[index]));
  }

  Future<int> addRoom(Room room) async {
    final db = await database;

    return db.insert(
      "room",
      room.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateReserveYn(int roomId, String reserveYn, String updatedAt) async {
    final db = await database;

    await db.update(
      "room",
      {
        "reserve_yn": reserveYn,
        "updated_at": updatedAt,
      },
      where: "id = ?",
      whereArgs: [roomId],
    );
  }

  Future<void> deleteRoom(int roomId) async {
    final db = await database;

    await db.delete(
      'room',
      where: 'id = ?',
      whereArgs: [roomId],
    );
  }
}
