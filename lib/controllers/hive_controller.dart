import 'package:hive/hive.dart';
import '../models/note.dart';
import '../models/note_adapter.dart';

class HiveController {
  static final HiveController _singleton = HiveController._internal();
  factory HiveController() => _singleton;
  HiveController._internal();

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteAdapter());
    }

    // Hive.registerAdapter(NoteAdapter());
    await Hive.openBox<Note>('notesBox');
  }

  Future<Box<Note>> getBox() async {
    if (!Hive.isBoxOpen('notesBox')) {
      await Hive.openBox<Note>('notesBox');
    }
    return Hive.box<Note>('notesBox');
  }

  Future<void> add(Note note) async {
    final box = await getBox();
    await box.add(note);
  }

  Future<void> delete(index) async {
    final box = await getBox();
    await box.deleteAt(index);
  }

// Get Notes
  Future<List<Note>> getNotes() async {
    final box = await getBox();
    return box.values.toList();
  }

// Get Single Note
  Future<Note?> getNote(int index) async {
    final box = await getBox();
    return box.getAt(index);
  }

// update Note
  Future<void> update(Note note) async {
    final box = await getBox();
    await box.put(note.id, note);
  }
}
