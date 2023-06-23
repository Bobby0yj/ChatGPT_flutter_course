import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../components/custom_icon_button.dart';
import '../model/note_model.dart';
import '../providers copy/note_provider.dart';
import '../style/app_style.dart';
import 'add_note.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  NotesScreen({super.key});

  bool isDarkTheme = true;

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Lottie.network(
                "https://assets5.lottiefiles.com/packages/lf20_fynnwg6i.json",
                height: 150,
                width: 150),
            // backgroundColor: const Color(0xFF252525),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text(
              'Simple Notes App',
              style: GoogleFonts.nunito(
                  color: Color.fromARGB(255, 33, 33, 33),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            content: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Powered by',
                    style: GoogleFonts.nunito(
                        color: const Color.fromARGB(179, 0, 0, 0),
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  Text(
                    "BOBBY'S WORLD",
                    style: GoogleFonts.nunito(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 22,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              color: const Color(0xFF252525),
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Note Text
                  const Text(
                    'ITTR-NOTES',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),

                  //Dark and Light mode toggle button
                  CustomIconButton(
                    icon: Icons.info_outline,
                    onPress: () {
                      _showDialog(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Note>?>(
                  future: context.watch<NoteProvider>().getAllNotes(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Note>?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ));
                    } else {
                      final notes = snapshot.data;
                      if (notes != null && notes.isNotEmpty) {
                        return ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final note = notes[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddNoteScreen(
                                              note: note,
                                            )));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7.0),
                                child: Dismissible(
                                  key: Key(note.id.toString()),
                                  onDismissed: (direction) {
                                    context
                                        .read<NoteProvider>()
                                        .deleteNote(note);
                                  },
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.delete_rounded,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Delete note',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    tileColor: Color(note.color),
                                    title: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 5.0),
                                      child: Text(
                                        note.title,
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 3, 3, 3),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        note.content,
                                        style: const TextStyle(
                                            color: Color.fromARGB(221, 0, 0, 0),
                                            fontSize: 16),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Lottie.network(
                              "https://assets5.lottiefiles.com/packages/lf20_fynnwg6i.json",
                              height: 150,
                              width: 150),
                        );
                      }
                    }
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNoteScreen()));
        },
        backgroundColor: Colors.black,
        elevation: 8,
        splashColor: const Color(0xFF3B3B3B),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
/*

               Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Color(0xFF252525),
            borderRadius: BorderRadius.circular(10.0)
          ),
        child: Center(
          child: Column(

          ),
        ),
      )
 */




