import 'package:flutter/material.dart';

enum AppNotificationType { community, admin, event }

class AppNotification {
  final AppNotificationType type;
  final IconData icon;
  final String title;
  final String description;
  final String time;
  bool isRead;

  AppNotification({
    required this.type,
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    this.isRead = false,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      type: stringToType(map['type']),
      icon: map['icon'],
      title: map['title'],
      description: map['description'],
      time: map['time'],
      isRead: map['isRead'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'icon': icon,
      'title': title,
      'description': description,
      'time': time,
      'isRead': isRead,
    };
  }

  static AppNotificationType stringToType(String value) {
    switch (value) {
      case 'Community':
        return AppNotificationType.community;
      case 'Admin':
        return AppNotificationType.admin;
      case 'Event':
        return AppNotificationType.event;
      default:
        throw Exception('Unknown notification type: $value');
    }
  }
}
