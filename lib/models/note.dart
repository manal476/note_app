// note.dart

class Note {
  int? id;
  String title;
  String content;
  DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      createdAt: DateTime.parse(map['createdAt']),
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}
