import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/notulensi/minutes_model.dart';

class MinutesItem extends StatelessWidget {
  final MinutesModel data;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const MinutesItem({
    required this.data,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(data.title, style: const TextStyle(fontSize: 18)),
        subtitle: Text(data.date),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
