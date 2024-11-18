class Room {
  final int? id;
  final String name;
  final String startTime;
  final String endTime;
  final int topicId;
  final int playerId;
  final String createdAt;
  final String? updatedAt;
  final String? reserveYn;

  Room(
      {this.id,
      required this.name,
      required this.startTime,
      required this.endTime,
      required this.topicId,
      required this.playerId,
      required this.createdAt,
      this.updatedAt,
      required this.reserveYn});

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'],
      name: map['name'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      topicId: map['topic_id'],
      playerId: map['player_id'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      reserveYn: map['reserve_yn'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'start_time': startTime,
      'end_time': endTime,
      'topic_id': topicId,
      'player_id': playerId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'reserve_yn': reserveYn,
    };
  }
}
