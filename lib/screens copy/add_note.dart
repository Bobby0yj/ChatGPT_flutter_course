import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/custom_icon_button.dart';
import '../model/note_model.dart';
import '../providers copy/color_provider.dart';
import '../providers copy/note_provider.dart';
import '../style/app_style.dart';
import '../components/colors_bottom_sheet.dart';
import '../providers/color_provider.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {

  final Note? note;

   AddNoteScreen({this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  // String noteTitle = '';
  int bgColor = 0xFF252525;

  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteContentController = TextEditingController();

  @override
  void initState() {

    if(widget.note != null){
      _noteTitleController.text = widget.note!.title;
      _noteContentController.text = widget.note!.content;
      bgColor = widget.note!.color;

      context.read<ColorProvider>().setBgColor(Color(bgColor));
    }else{
      context.read<ColorProvider>().setBgColor(Color(bgColor));
    }
    super.initState();
  }

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<ColorProvider>().bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
        child: Column(
          children: [
            //Top section where you have the backButton and Save Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Back-Button
                CustomIconButton(
                  icon: Icons.arrow_back,
                  onPress: (){
                    Navigator.pop(context);
                  },
                ),

                Row(
                  children: [
                    //Choose Note Color Prompt
                    CustomIconButton(
                      icon: Icons.color_lens,
                      onPress: () async{
                        var colorCode = await showModalBottomSheet(
                            context: context,
                            builder: (context) => const ColorsBottomSheet()
                        ).then((value) => {
                        bgColor = value,
                        context.read<ColorProvider>().setBgColor(Color(bgColor))
                        });
                      },
                    ),

                    const SizedBox(width: 16.0,),

                    //Save Note Button
                    CustomIconButton(
                      icon: Icons.save,
                      onPress: ()async{

                        final title = _noteTitleController.value.text;
                        final content = _noteContentController.value.text;

                        if(title.isEmpty && content.isEmpty){
                          return;
                        }
                        Note model = Note(title: title, content: content, id: widget.note?.id, color: bgColor);

                        if(widget.note == null){
                          context.read<NoteProvider>().createNote(model);
                          Navigator.pop(context);
                        }else{
                          context.read<NoteProvider>().updateNote(model);
                          Navigator.pop(context);
                        }

                      },
                    ),
                  ],
                ),

              ],
            ),

            //Note-Title
            TextField(
              controller: _noteTitleController,
              onChanged: (String value){
                //noteTitle = value;
              },
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: GoogleFonts.nunito(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF9A9A9A),
                ),
                focusColor: AppStyle.bgColor,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent), // Set the desired border color
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent), // Set the desired border color
                ),
              ),
              cursorColor: const Color(0xFF3B3B3B),
              cursorHeight: 30.0,
              style: GoogleFonts.nunito(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: widget.note != null ? Colors.black : Colors.white,
              ),
              maxLines: null,
            ),

            const SizedBox(height: 16.0,),

            //Note-Content
            Expanded(
              child: TextField(
                controller: _noteContentController,
                onChanged: (String value){
                  //noteContent = value;
                },
                decoration: InputDecoration(
                  hintText: 'Type something...',
                  hintStyle: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF9A9A9A),
                  ),
                  focusColor: AppStyle.bgColor,
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent), // Set the desired border color
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent), // Set the desired border color
                  ),
                ),
                cursorColor: const Color(0xFF3B3B3B),
                cursorHeight: 30.0,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: widget.note != null ? Colors.black87 : Colors.white,
                ),
                maxLines: 20,

              ),
            ),

          ],
        ),
      ),
    );
  }
}
