import 'package:flutter/material.dart';
import 'package:rukunin/repositories/announcementsRT.dart' as repo;
import 'package:rukunin/models/announcementRT.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/rt/announcements/create_announcement_screen.dart';
import 'package:rukunin/pages/rt/announcements/announcement_detail_modal.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  List<Announcement> _items = [];

  @override
  void initState() {
    super.initState();
    _items = List<Announcement>.from(repo.announcements);
  }

  void _openCreate() async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateAnnouncementScreen()),
    );
    if (res is Announcement) {
      setState(() {
        _items.insert(0, res);
        repo.addAnnouncement(res);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pengumuman terkirim'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Pengumuman RT',
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Expanded(
                  child: _items.isEmpty
                      ? Center(
                          child: Text(
                            'Belum ada pengumuman',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (c, i) {
                            final a = _items[i];
                            return _buildCard(a);
                          },
                        ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          Positioned(
            right: 12,
            bottom: 12,
            child: FloatingActionButton(
              heroTag: 'add-announcement',
              backgroundColor: AppColors.primary,
              onPressed: _openCreate,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Announcement a) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showDetail(a),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(6),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.campaign,
                      color: Colors.yellow[800],
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    a.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              a.body,
              style: TextStyle(
                color: Colors.grey[800],
                height: 1.4,
                fontSize: 13,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                  const SizedBox(width: 6),
                  Text(
                    _formatRelative(a.createdAt),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(Announcement a) {
    showDialog(
      context: context,
      builder: (_) => AnnouncementDetailDialog(a: a),
    );
  }

  String _formatRelative(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    final months = (diff.inDays / 30).floor();
    if (months < 12) return '$months mo ago';
    final years = (months / 12).floor();
    return '${years}y ago';
  }
}
