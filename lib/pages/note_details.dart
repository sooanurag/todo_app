import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../database/model.dart';
import 'package:intl/intl.dart';

import 'edit_note.dart';

class NoteDetailsPage extends StatefulWidget {
  final int noteId;
  const NoteDetailsPage({super.key, required this.noteId});

  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  late Notes note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }
// loading used to wait to fetch data, if its true then build only show circular bar util data is fetched from db.
  void refreshNote() async {
    setState(() {
      isLoading = true;
    });

    note = await TodoDatabase.instance.readNotes(widget.noteId);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: _editButton,
          icon: const Icon(Icons.edit_attributes_outlined),
        ),
        IconButton(
          onPressed: _deleteButton,
          icon: const Icon(Icons.deblur_outlined),
        ),
      ]),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      Row(
                        children: [
                          Text(
                            note.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.isImportant
                                    ? 'Priority: High'
                                    : 'Priority: Low',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                "Scale: ${note.number}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat.yMMMd().format(note.createdTime),
                        style: const TextStyle(color: Colors.white38),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note.description,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                )),
    );
  }

  void _deleteButton() async {
    TodoDatabase.instance.deleteNotes(widget.noteId);
    Navigator.of(context).pop();
  }

  void _editButton() async {
    if (isLoading == true) {
      return;
    }

    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddEditNotePage(note: note),
    ));

    refreshNote();
  }
}
