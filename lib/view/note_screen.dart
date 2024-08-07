import 'package:flutter/material.dart';
import 'package:note_app/controllers/sqllite_controller.dart';
import 'package:note_app/controllers/hive_controller.dart';
import '../models/note.dart';

enum StorageType { sqLite, hive }

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final SqLiteController _sqLiteController = SqLiteController();
  final HiveController _hiveController = HiveController();

  final TextEditingController _contentController = TextEditingController();

  List<Note> _notes = [];
  StorageType _selectedStorage = StorageType.sqLite;

  @override
  void initState() {
    super.initState();
    _initialHive();
    _loadNotes();
  }

  void _initialHive() async {
    await _hiveController.init();
  }

  void _loadNotes() async {
    if (_selectedStorage == StorageType.sqLite) {
      final notes = await _sqLiteController.getNotes();
      setState(() {
        _notes = notes;
      });
    } else {
      _initialHive();
      final notes = await _hiveController.getNotes();
      setState(() {
        _notes = notes;
      });
    }
  }

  void _addNote() async {
    final note = Note(
      title: '',
      content: _contentController.text,
      createdAt: DateTime.now(),
    );
    if (_selectedStorage == StorageType.sqLite) {
      await _sqLiteController.insert(note);
    } else {
      await _hiveController.add(note);
    }

    _contentController.clear();

    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(
                    'lib/img/note_pic.png',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'MY NOTE',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${_notes.length} notes',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 325,
              height: 60,
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your note',
                  suffixIcon: Icon(Icons.note),
                ),
                onSubmitted: (_) => _addNote(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.content,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Created on: ${note.createdAt.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
