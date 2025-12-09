import 'package:flutter/material.dart';
import 'package:rukunin/modules/activities/models/activity.dart';
import 'package:rukunin/modules/activities/services/activity_service.dart';
import 'package:rukunin/modules/activities/widgets/activity_card.dart';
import 'package:rukunin/pages/rt/activities/widgets/community_activity_card.dart';
import 'package:rukunin/pages/rt/activities/create_activity_screen.dart';
import 'package:rukunin/pages/rt/activities/activity_detail_screen.dart';
import 'package:rukunin/pages/rt/activities/widgets/category_chip.dart';
import 'package:rukunin/pages/rt/activities/widgets/dismiss_background.dart';
import 'package:rukunin/pages/rt/activities/widgets/delete_confirm_dialog.dart';
import 'package:rukunin/theme/app_colors.dart';

class RtActivitiesScreen extends StatefulWidget {
  const RtActivitiesScreen({super.key});

  @override
  State<RtActivitiesScreen> createState() => _RtActivitiesScreenState();
}

class _RtActivitiesScreenState extends State<RtActivitiesScreen> {
  final ActivityService _activityService = ActivityService();
  String _filter = 'Semua';

  void _openCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateActivityScreen()),
    );

    if (result is Activity && mounted) {
      setState(() {});
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StreamBuilder<List<Activity>>(
                    stream: _filter == 'Semua'
                        ? _activityService.getEvents()
                        : _activityService.getEventsByCategory(_filter),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        );
                      }

                      final activities = snapshot.data ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total: ${activities.length} kegiatan',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          _buildEventList(activities),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: 'add-event',
        backgroundColor: AppColors.primary,
        onPressed: _openCreate,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEventList(List<Activity> activities) {
    if (activities.isEmpty) return const ActivityCard.empty();

    // Sort: upcoming first, then past
    final sortedActivities = List<Activity>.from(activities);
    sortedActivities.sort((a, b) {
      if (a.isPast != b.isPast) {
        return a.isPast ? 1 : -1;
      }
      return a.dateTime.compareTo(b.dateTime);
    });

    return Column(
      children: sortedActivities.map((activity) {
        final interested = (activity.title.hashCode.abs() % 45) + 1;

        return Dismissible(
          key: Key(activity.id),
          direction: DismissDirection.endToStart,
          background: const DismissBackground(),
          confirmDismiss: (_) async {
            if (activity.isPast) {
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
              final success = await _activityService.deleteEvent(activity.id);
              if (success && mounted) {
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
            }
            return ok ?? false;
          },
          child: CommunityEventCard(
            activity: activity,
            interestedCount: interested,
            onTap: () async {
              final res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RtActivityDetailScreen(
                    activity: activity,
                    interestedCount: interested,
                  ),
                ),
              );
              if (res is Activity && mounted) {
                setState(() {});
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
