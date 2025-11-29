import 'package:flutter/material.dart';
import 'package:rukunin/widgets/input_decorations.dart';

class NotesCard extends StatelessWidget {
  final TextEditingController notesCtrl;
  const NotesCard({Key? key, required this.notesCtrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TextFormField(
          controller: notesCtrl,
          maxLines: 3,
          decoration: buildInputDecoration('Keterangan / Catatan (opsional)'),
        ),
      ),
    );
  }
}
