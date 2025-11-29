import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/modules/activities/models/activity.dart';
import 'package:rukunin/modules/activities/widgets/activity_detail_screen_appbar.dart';
import 'package:rukunin/modules/activities/widgets/activity_organizer_card.dart';
import 'package:rukunin/modules/activities/widgets/small_activity_detail_card.dart';
import 'package:rukunin/modules/activities/services/activity_service.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/loading_indicator.dart';

class ActivityDetailScreen extends StatefulWidget {
  final Activity event;

  const ActivityDetailScreen({required this.event, super.key});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  final ActivityService _activityService = ActivityService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isJoined = false;
  int _participantCount = 0;
  bool _isLoading = true;
  Activity? _currentEvent;

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  void _loadEventData() {
    _activityService.getEventById(widget.event.id).listen((event) async {
      if (event != null && mounted) {
        final userId = _auth.currentUser?.uid ?? '';
        final hasJoined = await _activityService.hasUserJoined(
          event.id,
          userId,
        );

        setState(() {
          _currentEvent = event;
          _participantCount = event.participants.length;
          _isJoined = hasJoined;
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _toggleJoinStatus() async {
    final userId = _auth.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool success;
    if (_isJoined) {
      success = await _activityService.leaveEvent(widget.event.id, userId);
    } else {
      success = await _activityService.joinEvent(widget.event.id, userId);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isJoined
                  ? 'Pendaftaran dibatalkan'
                  : 'Anda telah mendaftar untuk kegiatan ini',
            ),
            backgroundColor: _isJoined ? Colors.orange : Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memperbarui status pendaftaran'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayEvent = _currentEvent ?? widget.event;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          ActivityDetailScreenAppbar(event: displayEvent),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayEvent.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Participants Count
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 32,
                            child: Stack(
                              children: List.generate(3, (index) {
                                return Positioned(
                                  left: index * 20.0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 70),
                          Text(
                            '$_participantCount orang tertarik',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Activity Details Cards
                SmallActivityDetailCard(
                  icon: Icons.calendar_today,
                  title: 'Tanggal',
                  subtitle: displayEvent.date,
                  color: Colors.blue,
                ),

                SmallActivityDetailCard(
                  icon: Icons.access_time,
                  title: 'Waktu',
                  subtitle: displayEvent.time,
                  color: Colors.green,
                ),

                SmallActivityDetailCard(
                  icon: Icons.location_on,
                  title: 'Lokasi',
                  subtitle: displayEvent.location,
                  color: AppColors.primary,
                  hasAction: true,
                ),

                const SizedBox(height: 16),

                // Description Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(26),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.description,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Deskripsi Kegiatan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        displayEvent.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Organizer Section
                ActivityOrganizerCard(
                  name: displayEvent.organizerName,
                  position: displayEvent.organizerPosition,
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            OutlinedButton(
              onPressed: () {
                // TODO: Add to calendar
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                side: const BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Icon(Icons.calendar_today, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _toggleJoinStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isJoined
                      ? Colors.grey[300]
                      : AppColors.primary,
                  foregroundColor: _isJoined ? Colors.grey[700] : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: LoadingIndicator(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isJoined ? Icons.check_circle : Icons.person_add,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isJoined ? 'Sudah Terdaftar' : 'Ikut Kegiatan',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
