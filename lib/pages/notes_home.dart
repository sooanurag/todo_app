import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:todo_app/database/database_helper.dart';

import '../database/model.dart';
import '../widgets/note_card.dart';
import 'edit_note.dart';
import 'note_details.dart';

class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  late List<Notes> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  void refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    notes = await TodoDatabase.instance.readAllNotes();

    setState(() {
      isLoading = false;
    });
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8.0),
        itemCount: notes.length,
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailsPage(noteId: note.id!)));
              refreshNotes();
            },
            child: NoteCard(note: note, index: index),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text(
                    "No Notes Found!",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  )
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditNotePage()),
          );
          //after updating notes
          refreshNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
