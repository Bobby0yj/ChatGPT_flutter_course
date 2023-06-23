import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../model/note_model.dart';

class DatabaseHelper{

  static const int _version = 1;
  static const String _dbName = 'Notes.db';

  static Future<Database> _getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
    onCreate: (db, version) async =>
    await db.execute("CREATE TABLE Note(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, content TEXT NOT NULL, color INTEGER NOT NULL)"),
      version: _version);
  }

  static Future<int> addNote(Note note) async {
    final db = await _getDatabase();
    return await db.insert("Note", note.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateNote(Note note) async {
    final db = await _getDatabase();
    return await db.update("Note", note.toJson(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNote(Note note) async {
    final db = await _getDatabase();
    return await db.delete("Note",
        where: 'id = ?',
        whereArgs: [note.id],);
  }

  static Future<List<Note>?> getAllNote() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query("Note");

    if(maps.isEmpty){
      return null;
    }

    return List.generate(maps.length, (index) => Note.fromJson(maps[index]));
  }

}