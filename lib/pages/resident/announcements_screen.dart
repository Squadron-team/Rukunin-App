import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final Map<String, dynamic> announcement;

  const AnnouncementDetailScreen({required this.announcement, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              Share.share(
                '${announcement['title']}\n\n${announcement['content']}\n\n- ${announcement['author']}',
                subject: announcement['title'],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image if available
            if (announcement['imageUrl'] != null)
              Image.network(
                announcement['imageUrl'],
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Row(
                    children: [
                      _buildCategoryBadge(context),
                      if (announcement['isPinned'] == true) ...[
                        const SizedBox(width: 8),
                        _buildPinnedBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    announcement['title'],
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  // Meta Info
                  _buildMetaInfo(context),
                  const SizedBox(height: 24),

                  // Divider
                  const Divider(),
                  const SizedBox(height: 24),

                  // Content
                  Text(
                    announcement['content'],
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.7, fontSize: 15),
                  ),
                  const SizedBox(height: 32),

                  // Author Card
                  _buildAuthorCard(context),
                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context) {
    final categoryInfo = _getCategoryInfo(announcement['category']);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: categoryInfo['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: categoryInfo['color'].withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            categoryInfo['icon'] as IconData,
            size: 16,
            color: categoryInfo['color'],
          ),
          const SizedBox(width: 6),
          Text(
            categoryInfo['label'] as String,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: categoryInfo['color'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.push_pin, size: 16, color: AppColors.error),
          SizedBox(width: 6),
          Text(
            'Pengumuman Penting',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Penulis',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        announcement['author'],
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dipublikasi',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('dd MMM yyyy').format(announcement['date']),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                announcement['author'].substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement['author'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pengurus RT 05 / RW 12',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {
                  // TODO: Contact author
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Share.share(
                '${announcement['title']}\n\n${announcement['content']}\n\n- ${announcement['author']}',
                subject: announcement['title'],
              );
            },
            icon: const Icon(Icons.share_outlined),
            label: const Text('Bagikan'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Save bookmark
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pengumuman disimpan')),
              );
            },
            icon: const Icon(Icons.bookmark_outline),
            label: const Text('Simpan'),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getCategoryInfo(String category) {
    switch (category) {
      case 'event':
        return {
          'label': 'Kegiatan',
          'icon': Icons.event_rounded,
          'color': Colors.purple,
        };
      case 'info':
        return {
          'label': 'Informasi',
          'icon': Icons.info_rounded,
          'color': Colors.blue,
        };
      case 'security':
        return {
          'label': 'Keamanan',
          'icon': Icons.security_rounded,
          'color': Colors.orange,
        };
      case 'finance':
        return {
          'label': 'Keuangan',
          'icon': Icons.payments_rounded,
          'color': AppColors.success,
        };
      default:
        return {
          'label': 'Lainnya',
          'icon': Icons.campaign_rounded,
          'color': Colors.grey,
        };
    }
  }
}
