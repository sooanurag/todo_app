import 'package:flutter/material.dart';
import 'package:todo_app/database/database_helper.dart';

import '../database/model.dart';
import '../widgets/note_form.dart';

class AddEditNotePage extends StatefulWidget {
  final Notes? note;
  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late String title;
  late String description;
  late int number;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    number = widget.note?.number ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          title: title,
          number: number,
          isImportant: isImportant,
          description: description,
          // unnecessary
          onChangedTitle: (title) => setState(() => this.title = title),
          onChangedDescription: (description) =>
              setState(() => this.description = description),
          onChangedImportant: (isImportant) =>
              setState(() => this.isImportant = isImportant),
          onChangedNumber: (number) => setState(() => this.number = number),
        ),
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();
    final navigation = Navigator.of(context);
    //By following this pattern(storing navigator), you ensure that the BuildContext is not
    //held across asynchronous operations, preventing potential issues related 
    //to widget lifecycles and memory management(leaks).

    if (isValid) {
      //isUpdating: check if note obj is null or not, if its null then u adding new note.
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      navigation.pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await TodoDatabase.instance.updateNotes(note);
  }

  Future addNote() async {
    final note = Notes(
      title: title,
      isImportant: isImportant,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await TodoDatabase.instance.createNotes(note);
  }
}
