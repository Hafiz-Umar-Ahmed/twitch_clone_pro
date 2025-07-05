class Comment {
  final String name;
  final String id;
  final String channelId;
  final String content;
  final createdAt;

  Comment({
    required this.name,
    required this.id,
    required this.channelId,
    required this.content,
    this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {'name': name, 'id': id, 'channelId': channelId, 'content': content};
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      channelId: map['channelId'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
