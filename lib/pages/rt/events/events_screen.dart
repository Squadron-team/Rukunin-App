import 'package:flutter/material.dart';
import 'package:rukunin/modules/activities/widgets/activity_card.dart';
import 'package:rukunin/pages/rt/events/models/event.dart';
import 'package:rukunin/pages/rt/events/widgets/community_event_card.dart';
import 'package:rukunin/repositories/events.dart';
import 'package:rukunin/pages/rt/events/create_event_screen.dart';
import 'package:rukunin/pages/rt/events/event_detail_screen.dart';
import 'package:rukunin/pages/rt/events/widgets/category_chip.dart';
import 'package:rukunin/pages/rt/events/widgets/dismiss_background.dart';
import 'package:rukunin/pages/rt/events/widgets/delete_confirm_dialog.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/utils/date_formatter.dart';

class CommunityHeadEventsScreen extends StatefulWidget {
  const CommunityHeadEventsScreen({super.key});

  @override
  State<CommunityHeadEventsScreen> createState() =>
      _CommunityHeadEventsScreenState();
}

class _CommunityHeadEventsScreenState extends State<CommunityHeadEventsScreen> {
  List<Event> _events = [];
  String _filter = 'Semua';

  @override
  void initState() {
    super.initState();
    // TODO: new events will be added here
    _events = List<Event>.from(events);
  }

  void _openCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateEventScreen()),
    );

    if (result is Event) {
      setState(() {
        _events.insert(0, result);
        // also add to global repo
        events.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Kegiatan Warga',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                const SizedBox(height: 12),

                // Category filters
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 44,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          CategoryChip(
                            label: 'Semua',
                            selected: _filter == 'Semua',
                            onTap: () => setState(() => _filter = 'Semua'),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Sosial',
                            selected: _filter == 'Sosial',
                            onTap: () => setState(() => _filter = 'Sosial'),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Rapat',
                            selected: _filter == 'Rapat',
                            onTap: () => setState(() => _filter = 'Rapat'),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Pendidikan',
                            selected: _filter == 'Pendidikan',
                            onTap: () => setState(() => _filter = 'Pendidikan'),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Seni',
                            selected: _filter == 'Seni',
                            onTap: () => setState(() => _filter = 'Seni'),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Olahraga',
                            selected: _filter == 'Olahraga',
                            onTap: () => setState(() => _filter = 'Olahraga'),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Total count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total: ${_filter == 'Semua' ? _events.length : _events.where((ev) => ev.category.toLowerCase() == _filter.toLowerCase()).length} kegiatan',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Event list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildEventList(),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),

          // Floating Create Button
          Positioned(
            right: 12,
            bottom: 12,
            child: FloatingActionButton(
              heroTag: 'add-event',
              backgroundColor: AppColors.primary,
              onPressed: _openCreate,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    // filter by category
    List<Event> visible = _filter == 'Semua'
        ? List<Event>.from(_events)
        : _events
              .where((e) => e.category.toLowerCase() == _filter.toLowerCase())
              .toList();

    if (visible.isEmpty) return const ActivityCard.empty();

    // sort upcoming then past
    visible.sort((a, b) {
      DateTime da, db;
      try {
        da = DateFormatter.fullDate.parse(a.date);
      } catch (_) {
        da = DateTime.now();
      }
      try {
        db = DateFormatter.fullDate.parse(b.date);
      } catch (_) {
        db = DateTime.now();
      }

      final now = DateTime.now();
      final aPast = da.isBefore(now);
      final bPast = db.isBefore(now);

      if (aPast != bPast)
        return aPast ? 1 : -1; // upcoming (-1) before past (1)
      return da.compareTo(db);
    });

    return Column(
      children: visible.map((e) {
        final key = '${e.title}-${e.date}-${e.time}';
        final interested = (e.title.hashCode.abs() % 45) + 1;

        return Dismissible(
          key: Key(key),
          direction: DismissDirection.endToStart,
          background: const DismissBackground(),
          confirmDismiss: (_) async {
            // prevent deleting events that already passed
            DateTime da;
            try {
              da = DateFormatter.fullDate.parse(e.date);
            } catch (_) {
              da = DateTime.now();
            }
            if (da.isBefore(DateTime.now())) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Tidak dapat menghapus kegiatan yang sudah lewat',
                  ),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              return false;
            }

            final ok = await showDeleteConfirm(context);
            if (ok ?? false) {
              setState(() {
                // remove by object
                events.remove(e);
                _events.remove(e);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Kegiatan berhasil dihapus'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
            return ok ?? false;
          },
          child: CommunityEventCard(
            event: e,
            interestedCount: interested,
            onTap: () async {
              final res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommunityHeadEventDetailScreen(
                    event: e,
                    interestedCount: interested,
                  ),
                ),
              );
              if (res is Event) {
                // update event in lists
                setState(() {
                  final idx = _events.indexWhere(
                    (it) =>
                        it.title == e.title &&
                        it.date == e.date &&
                        it.time == e.time &&
                        it.location == e.location,
                  );
                  if (idx != -1) _events[idx] = res;
                  final gidx = events.indexWhere(
                    (it) =>
                        it.title == e.title &&
                        it.date == e.date &&
                        it.time == e.time &&
                        it.location == e.location,
                  );
                  if (gidx != -1) events[gidx] = res;
                });
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
