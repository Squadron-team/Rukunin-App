import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/rt/meetings/models/meeting.dart';
import 'package:rukunin/repositories/meeting_repository.dart';
import 'package:rukunin/pages/rt/meetings/widgets/meeting_card.dart';
import 'package:rukunin/pages/rt/meetings/meeting_detail_screen.dart';
import 'package:rukunin/pages/rt/meetings/create_meeting_screen.dart';

class MeetingsScreen extends StatefulWidget {
  const MeetingsScreen({super.key});

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  List<Meeting> _items = [];
  String _filter = 'Semua';

  @override
  void initState() {
    super.initState();
    _items = MeetingRepository.all();
  }

  void _refresh() => setState(() => _items = MeetingRepository.all());

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    List<Meeting> visible;
    if (_filter == 'Semua') {
      final future = _items.where((m) => m.dateTime.isAfter(now)).toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      final past = _items.where((m) => m.dateTime.isBefore(now)).toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
      visible = [...future, ...past];
    } else if (_filter == 'Mendatang') {
      visible = _items.where((m) => m.dateTime.isAfter(now)).toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else {
      visible = _items.where((m) => m.dateTime.isBefore(now)).toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Rapat RT',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    Expanded(child: _filterChip('Semua')),
                    const SizedBox(width: 8),
                    Expanded(child: _filterChip('Mendatang')),
                    const SizedBox(width: 8),
                    Expanded(child: _filterChip('Terlewat')),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (visible.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total: ${visible.length}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: visible.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.calendar_month,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Belum ada rapat',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _filter == 'Semua'
                                    ? 'Belum ada rapat di RT ini.'
                                    : _filter == 'Mendatang'
                                    ? 'Belum ada rapat mendatang.'
                                    : 'Belum ada rapat yang lewat.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 120),
                        itemCount: visible.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final m = visible[index];
                          return MeetingCard(
                            meeting: m,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      MeetingDetailScreen(meeting: m),
                                ),
                              );
                              _refresh();
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-rapat',
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final res = await Navigator.push<Meeting>(
            context,
            MaterialPageRoute(builder: (_) => const CreateMeetingScreen()),
          );
          if (res != null) {
            MeetingRepository.add(res);
            _refresh();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Rapat berhasil dibuat'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _filterChip(String label) {
    final selected = _filter == label;
    return GestureDetector(
      onTap: () => setState(() => _filter = label),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : Colors.grey[800],
          ),
        ),
      ),
    );
  }
}
