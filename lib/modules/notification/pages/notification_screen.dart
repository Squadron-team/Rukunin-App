import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rukunin/models/app_notification.dart';
import 'package:rukunin/repositories/app_notifications.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/modules/notification/widgets/notification_tab_chip.dart';
import 'package:rukunin/modules/notification/widgets/notification_card.dart';
import 'package:rukunin/modules/notification/widgets/notification_empty_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTab = 'All';

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

  List<AppNotification> get _filteredNotifications {
    if (_selectedTab == 'All') {
      return appNotifications;
    }

    return appNotifications
        .where(
          (notification) =>
              notification.type == AppNotification.stringToType(_selectedTab),
        )
        .toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in appNotifications) {
        notification.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Semua notifikasi ditandai sudah dibaca'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int unreadCount = appNotifications.where((n) => n.isRead == false).length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
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
                SizedBox(
                  height: 74,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                      },
                      scrollbars: false,
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        NotificationTabChip(
                          label: 'All',
                          icon: Icons.notifications_active,
                          isSelected: _selectedTab == 'All',
                          onTap: () => setState(() => _selectedTab = 'All'),
                        ),
                        const SizedBox(width: 8),
                        NotificationTabChip(
                          label: 'Admin',
                          icon: Icons.admin_panel_settings,
                          isSelected: _selectedTab == 'Admin',
                          onTap: () => setState(() => _selectedTab = 'Admin'),
                        ),
                        const SizedBox(width: 8),
                        NotificationTabChip(
                          label: 'Komunitas',
                          icon: Icons.people,
                          isSelected: _selectedTab == 'Community',
                          onTap: () =>
                              setState(() => _selectedTab = 'Community'),
                        ),
                        const SizedBox(width: 8),
                        NotificationTabChip(
                          label: 'Kegiatan',
                          icon: Icons.event_note,
                          isSelected: _selectedTab == 'Event',
                          onTap: () => setState(() => _selectedTab = 'Event'),
                        ),
                        const SizedBox(width: 12), // Extra padding at the end
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, color: Colors.grey[200]),
              ],
            ),
          ),

          // Notification List
          Expanded(
            child: _filteredNotifications.isEmpty
                ? const NotificationEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return NotificationCard(
                        notification: notification,
                        onTap: () {
                          setState(() {
                            notification.isRead = true;
                          });
                          // TODO: Navigate to detailed view
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
