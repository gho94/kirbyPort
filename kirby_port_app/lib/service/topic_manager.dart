import 'package:kirby_port_app/model/topic_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TopicManager {
  static final TopicManager _instance = TopicManager._internal();
  factory TopicManager() => _instance;
  TopicManager._internal();

  late Database _database;

  Future<Database> get database async {
    if (_database.isOpen) return _database;

    await initializeDatabase();
    return _database;
  }

  Future<void> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "topic_database.db");

    _database = await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute("""
            CREATE TABLE topic (
              id          INTEGER PRIMARY KEY, 
              name        TEXT, 
              created_at  TEXT, 
              updated_at  TEXT
            )""");

        await db.insert("topic", {"name": "로맨스", "created_at": DateTime.now().toString()});
        await db.insert("topic", {"name": "스릴러", "created_at": DateTime.now().toString()});
        await db.insert("topic", {"name": "액션", "created_at": DateTime.now().toString()});
        await db.insert("topic", {"name": "코믹", "created_at": DateTime.now().toString()});
        await db.insert("topic", {"name": "호러", "created_at": DateTime.now().toString()});
        await db.insert("topic", {"name": "애니메이션", "created_at": DateTime.now().toString()});
      },
      version: 1,
    );
  }

  Future<List<Topic>> getTopics() async {
    final List<Map<String, dynamic>> maps = await _database.query("topic");
    return List.generate(maps.length, (index) => Topic.fromMap(maps[index]));
  }

  Future<void> addTopic(Topic topic) async {
    await _database.insert(
      "topic",
      topic.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 새로운 delete 메서드 추가
  Future<void> deleteTopic(int topicId) async {
    final db = await database;

    await db.delete(
      "topic",
      where: "id = ?",
      whereArgs: [topicId],
    );
  }
}
