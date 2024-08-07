// note_adapter.dart
import 'package:hive/hive.dart';
import '../models/note.dart';

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
      id: reader.read(),
      title: reader.read(),
      content: reader.read(),
      createdAt: DateTime.parse(reader.read()),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.content);
    writer.write(obj.createdAt.toIso8601String());
  }
}
