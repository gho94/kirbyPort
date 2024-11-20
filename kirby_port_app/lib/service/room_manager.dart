import 'package:kirby_port_app/model/room_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RoomManager {
  static final RoomManager _instance = RoomManager._internal();

  factory RoomManager() => _instance;

  RoomManager._internal();

  late Database _database;

  Future<Database> get database async {
    if (_database.isOpen) return _database;

    await initializeDatabase();
    return _database;
  }

  Future<void> initializeDatabase() async {
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
              topic_id    INTEGER, 
              
              player_id   INTEGER, 
              created_at  TEXT, 
              updated_at  TEXT,
              reserve_yn  TEXT
            )""");
      },
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE room ADD COLUMN reserve_yn TEXT');
        }
      },
    );
  }

  Future<List<Room>> getRooms() async {
    final List<Map<String, dynamic>> maps = await _database.query("room");
    return List.generate(maps.length, (index) => Room.fromMap(maps[index]));
  }

  Future<void> addRoom(Room room) async {
    await _database.insert(
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
