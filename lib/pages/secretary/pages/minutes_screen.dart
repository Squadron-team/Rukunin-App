import 'package:flutter/material.dart';

// Import dari widgets/notulensi/
import 'package:rukunin/pages/secretary/widgets/notulensi/minutes_model.dart';
import 'package:rukunin/pages/secretary/widgets/notulensi/minutes_list_widget.dart';
import 'package:rukunin/pages/secretary/widgets/notulensi/empty_minutes.dart';
import 'package:rukunin/pages/secretary/widgets/notulensi/create_minutes_screen.dart';
import 'package:rukunin/pages/secretary/widgets/notulensi/edit_minutes_screen.dart';
import 'package:rukunin/pages/secretary/widgets/notulensi/minutes_detail_page.dart';

class MinutesScreen extends StatefulWidget {
  const MinutesScreen({super.key});

  @override
  State<MinutesScreen> createState() => _MinutesScreenState();
}

class _MinutesScreenState extends State<MinutesScreen> {
  final List<MinutesModel> _minutes = [];

  void _addMinutes() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateMinutesScreen()),
    );

    if (result != null) {
      setState(() => _minutes.add(result));
    }
  }

  void _editMinutes(MinutesModel m) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditMinutesScreen(minutes: m)),
    );

    if (result != null) {
      final index = _minutes.indexWhere((e) => e.id == m.id);
      setState(() => _minutes[index] = result);
    }
  }

  void _deleteMinutes(MinutesModel m) {
    setState(() => _minutes.remove(m));
  }

  void _openDetail(MinutesModel m) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MinutesDetailPage(
          minutes: m,
          onEdit: () => _editMinutes(m),
          onDelete: () => _deleteMinutes(m),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notulensi'), centerTitle: false),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMinutes,
        child: const Icon(Icons.add),
      ),
      body: _minutes.isEmpty
          ? const EmptyMinutes()
          : MinutesListWidget(
              data: _minutes,
              onTap: _openDetail,
              onDelete: _deleteMinutes,
            ),
    );
  }
}
