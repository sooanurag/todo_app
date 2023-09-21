import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/model.dart';

final _lightColors = [
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.limeAccent,
  Colors.yellowAccent,
  Colors.redAccent,
  Colors.purpleAccent,
];

class NoteCard extends StatelessWidget {
  final Notes note;
  final int index;
  const NoteCard({
    super.key,
    required this.note,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final minHeight = getminHeight(index);
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.createdTime);

    return Card(
      color: color.withOpacity(0.7),
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              note.title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getminHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 3:
        return 150;
      case 4:
        return 100;
      default:
        return 100;
    }
  }
}
