import 'package:kirby_port_app/model/room_topic_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RoomTopicManager {
  static final RoomTopicManager _instance = RoomTopicManager._internal();
  factory RoomTopicManager() => _instance;
  RoomTopicManager._internal();

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
      final path = join(databasePath, "room_topic_database.db");

      _database = await openDatabase(
        path,
        onCreate: (db, version) async {
          await db.execute("""
            CREATE TABLE room_topic (
              room_id     INTEGER,
              topic_id    INTEGER,
              PRIMARY KEY (room_id, topic_id)
            )""");
        },
        version: 1,
      );
      isDatabaseInitialized = true;
    }
  }

  Future<List<RoomTopic>> getRoomTopics() async {
    if (!isDatabaseInitialized) {
      await initializeDatabase();
    }

    final List<Map<String, dynamic>> maps = await _database.query("room_topic");
    return List.generate(maps.length, (index) => RoomTopic.fromMap(maps[index]));
  }

  Future<List<int>> getRoomTopicsByTopicIds(List<int> topicIds) async {
    if (!isDatabaseInitialized) {
      await initializeDatabase();
    }

    final List<Map<String, dynamic>> maps = await _database.query(
      "room_topic",
      where: "topic_id IN (${List.filled(topicIds.length, '?').join(',')})",
      whereArgs: topicIds,
    );

    return maps.map((map) => map['room_id'] as int).toList();
  }

  Future<List<RoomTopic>> getTopicsByRoomId(int roomId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'room_topic',
      where: 'room_id = ?',
      whereArgs: [roomId],
    );

    return List.generate(maps.length, (index) => RoomTopic.fromMap(maps[index]));
  }

  Future<List<RoomTopic>> getRoomTopicsByTopicId(int topicId) async {
    if (!isDatabaseInitialized) {
      await initializeDatabase();
    }

    final List<Map<String, dynamic>> maps = await _database.query(
      "room_topic",
      where: "topic_id = ?",
      whereArgs: [topicId],
    );

    return List.generate(maps.length, (index) => RoomTopic.fromMap(maps[index]));
  }

  Future<void> addRoomTopic(RoomTopic roomTopic) async {
    await _database.insert(
      "room_topic",
      roomTopic.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeRoomTopicByRoomId(int roomId) async {
    await _database.delete(
      "room_topic",
      where: "room_id = ?",
      whereArgs: [roomId],
    );
  }

  Future<void> removeRoomTopicByTopicId(int topicId) async {
    await _database.delete(
      "room_topic",
      where: "topic_id = ?",
      whereArgs: [topicId],
    );
  }
}
