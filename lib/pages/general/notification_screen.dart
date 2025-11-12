import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTab = 'All';

  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'Community',
      'icon': Icons.campaign,
      'title': 'Perbaikan Jalan Gang 3',
      'description':
          'Perbaikan jalan akan dilaksanakan pada 20 November 2025. Mohon kerjasama warga.',
      'time': '2m ago',
      'isRead': false,
    },
    {
      'type': 'Admin',
      'icon': Icons.info_outline,
      'title': 'Pembaruan Sistem',
      'description':
          'Sistem aplikasi akan diperbarui pada malam ini pukul 23.00 WIB.',
      'time': '1h ago',
      'isRead': false,
    },
    {
      'type': 'Event',
      'icon': Icons.event,
      'title': 'Kerja Bakti Minggu Pagi',
      'description':
          'Kerja bakti rutin akan diadakan hari Minggu, 17 November 2025 pukul 07.00.',
      'time': '3h ago',
      'isRead': true,
    },
    {
      'type': 'Admin',
      'icon': Icons.payment,
      'title': 'Pengingat Iuran Bulanan',
      'description':
          'Iuran bulan November akan jatuh tempo pada 30 November 2025.',
      'time': '1d ago',
      'isRead': false,
    },
    {
      'type': 'Community',
      'icon': Icons.announcement,
      'title': 'Pengumuman Rapat RT',
      'description':
          'Rapat RT akan diadakan Kamis, 21 November 2025 di Balai RW.',
      'time': '2d ago',
      'isRead': true,
    },
    {
      'type': 'Event',
      'icon': Icons.celebration,
      'title': '17 Agustus - Lomba Warga',
      'description':
          'Daftarkan diri Anda untuk mengikuti berbagai lomba menarik!',
      'time': '3d ago',
      'isRead': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 'All') {
      return _notifications;
    }
    return _notifications
        .where((notification) => notification['type'] == _selectedTab)
        .toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Semua notifikasi ditandai sudah dibaca'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int unreadCount =
        _notifications.where((n) => n['isRead'] == false).length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Notifikasi',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Tandai semua',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Category Tabs
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      _buildTabChip('All', Icons.notifications_active),
                      const SizedBox(width: 8),
                      _buildTabChip('Admin', Icons.admin_panel_settings),
                      const SizedBox(width: 8),
                      _buildTabChip('Community', Icons.people),
                      const SizedBox(width: 8),
                      _buildTabChip('Event', Icons.event_note),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey[200]),
              ],
            ),
          ),

          // Notification List
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label, IconData icon) {
    bool isSelected = _selectedTab == label;
    int count = label == 'All'
        ? _notifications.length
        : _notifications.where((n) => n['type'] == label).length;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withAlpha(8)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    bool isRead = notification['isRead'];
    Color backgroundColor = _getBackgroundColor(notification['type'], isRead);

    return GestureDetector(
      onTap: () {
        setState(() {
          notification['isRead'] = true;
        });
        // TODO: Navigate to detailed view
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead ? Colors.grey[200]! : AppColors.primary.withOpacity(0.3),
            width: isRead ? 1 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isRead ? 5 : 15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(notification['type']),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notification['icon'],
                  color: _getIconColor(notification['type']),
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isRead ? Colors.grey[600] : Colors.black,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: isRead ? Colors.grey[500] : Colors.grey[700],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          notification['time'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(38),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tidak ada notifikasi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifikasi baru akan muncul di sini',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(String type, bool isRead) {
    if (isRead) return Colors.white;

    switch (type) {
      case 'Admin':
        return Colors.blue.withAlpha(13);
      case 'Community':
        return Colors.amber.withAlpha(13);
      case 'Event':
        return Colors.green.withAlpha(13);
      default:
        return Colors.white;
    }
  }

  Color _getIconBackgroundColor(String type) {
    switch (type) {
      case 'Admin':
        return Colors.blue.withAlpha(38);
      case 'Community':
        return AppColors.primary.withAlpha(38);
      case 'Event':
        return Colors.green.withAlpha(38);
      default:
        return Colors.grey.withAlpha(38);
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'Admin':
        return Colors.blue;
      case 'Community':
        return AppColors.primary;
      case 'Event':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}