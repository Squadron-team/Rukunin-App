import 'package:flutter/material.dart';

class MeetingItem extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String location;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const MeetingItem({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.onTap,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('$date • $time'), Text(location)],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: onEdit,
        ),
      ),
    );
  }
}
