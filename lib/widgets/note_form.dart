import 'package:flutter/material.dart';

class NoteFormWidget extends StatefulWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    this.isImportant,
    this.number,
    this.title,
    this.description,
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
    super.key,
  });

  @override
  State<NoteFormWidget> createState() => _NoteFormWidgetState();
}

class _NoteFormWidgetState extends State<NoteFormWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Switch(
                  value: widget.isImportant ?? false,
                  onChanged: widget.onChangedImportant,
                ),
                Expanded(
                  child: Slider(
                    value: (widget.number ?? 0).toDouble(),
                    min: 0,
                    max: 5,
                    onChanged: (number) =>
                        widget.onChangedNumber(number.toInt()),
                  ),
                ),
              ],
            ),
            buildTitle(),
            const SizedBox(
              height: 8,
            ),
            buildDescription(),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: widget.title,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: widget.onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: widget.description,
        style: const TextStyle(color: Colors.white60, fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: widget.onChangedDescription,
      );
}
