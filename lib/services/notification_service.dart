import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:rukunin/modules/activities/models/activity.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const androidSettings = AndroidInitializationSettings('@mipmap/app_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - you can navigate to activity detail here
    // using a navigation key or callback
  }

  Future<void> scheduleEventReminders(Activity event) async {
    final eventDateTime = event.dateTime;
    final now = DateTime.now();

    // Don't schedule if event is in the past
    if (eventDateTime.isBefore(now)) return;

    // Schedule notification 1 day before
    final oneDayBefore = eventDateTime.subtract(const Duration(days: 1));
    if (oneDayBefore.isAfter(now)) {
      await _scheduleNotification(
        id: _generateNotificationId(event.id, 1),
        title: 'Pengingat Kegiatan Besok',
        body: '${event.title} akan diadakan besok pada ${event.time}',
        scheduledDate: oneDayBefore,
      );
    }

    // Schedule notification 1 hour before
    final oneHourBefore = eventDateTime.subtract(const Duration(hours: 1));
    if (oneHourBefore.isAfter(now)) {
      await _scheduleNotification(
        id: _generateNotificationId(event.id, 2),
        title: 'Kegiatan Segera Dimulai',
        body: '${event.title} akan dimulai dalam 1 jam di ${event.location}',
        scheduledDate: oneHourBefore,
      );
    }

    // Schedule notification at event time
    if (eventDateTime.isAfter(now)) {
      await _scheduleNotification(
        id: _generateNotificationId(event.id, 3),
        title: 'Kegiatan Dimulai Sekarang!',
        body: '${event.title} sedang berlangsung di ${event.location}',
        scheduledDate: eventDateTime,
      );
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'event_reminders',
      'Event Reminders',
      channelDescription: 'Notifications for upcoming community events',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/app_icon',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelEventReminders(String eventId) async {
    // Cancel all 3 notifications for this event
    await _notifications.cancel(_generateNotificationId(eventId, 1));
    await _notifications.cancel(_generateNotificationId(eventId, 2));
    await _notifications.cancel(_generateNotificationId(eventId, 3));
  }

  int _generateNotificationId(String eventId, int reminderType) {
    // Generate unique ID from event ID hash and reminder type
    final hash = eventId.hashCode & 0x7FFFFFFF; // Ensure positive
    return (hash % 1000000) * 10 + reminderType;
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
