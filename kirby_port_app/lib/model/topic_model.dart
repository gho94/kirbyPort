class Topic {
  final int? id;
  final String name;
  final String createdAt;
  final String? updatedAt;

  Topic({
    this.id,
    required this.name,
    required this.createdAt,
    this.updatedAt,
  });

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'],
      name: map['name'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
