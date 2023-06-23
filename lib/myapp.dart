import 'package:chatgpt_course/providers%20copy/color_provider.dart';
import 'package:chatgpt_course/providers%20copy/note_provider.dart';
import 'package:chatgpt_course/screens%20copy/notes.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Notesapp());
}

class Notesapp extends StatelessWidget {
  const Notesapp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ColorProvider()),
        ChangeNotifierProvider(create: (context) => NoteProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NotesScreen(),
      ),
    );
  }
}
