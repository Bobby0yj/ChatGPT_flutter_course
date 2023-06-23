import 'package:flutter/foundation.dart';
import '../db/database_helper.dart';
import '../model/note_model.dart';

class NoteProvider with ChangeNotifier{

  Future<List<Note>?> notes = DatabaseHelper.getAllNote();

  Future<List<Note>?> getAllNotes() async{
    return await DatabaseHelper.getAllNote();
  }

  Future<void> createNote(Note note) async {
    await DatabaseHelper.addNote(note);
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    await DatabaseHelper.updateNote(note);
    notifyListeners();
  }

  deleteNote(Note note) async {
    await DatabaseHelper.deleteNote(note);
    notifyListeners();
  }

}