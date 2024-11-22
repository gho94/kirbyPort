class RoomTopic {
  final int roomId;
  final int topicId;

  RoomTopic({
    required this.roomId,
    required this.topicId,
  });

  factory RoomTopic.fromMap(Map<String, dynamic> map) {
    return RoomTopic(
      roomId: map['room_id'],
      topicId: map['topic_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'room_id': roomId,
      'topic_id': topicId,
    };
  }
}
