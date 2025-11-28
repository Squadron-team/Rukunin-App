import 'package:flutter/material.dart';
import 'package:rukunin/models/app_notification.dart';
import 'package:rukunin/style/app_colors.dart';

class NotificationHelpers {
  static Color getBackgroundColor(AppNotificationType type, bool isRead) {
    if (isRead) return Colors.white;

    switch (type) {
      case AppNotificationType.admin:
        return Colors.blue.withAlpha(13);
      case AppNotificationType.community:
        return Colors.amber.withAlpha(13);
      case AppNotificationType.event:
        return Colors.green.withAlpha(13);
    }
  }

  static Color getIconBackgroundColor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.admin:
        return Colors.blue.withAlpha(38);
      case AppNotificationType.community:
        return AppColors.primary.withAlpha(38);
      case AppNotificationType.event:
        return Colors.green.withAlpha(38);
    }
  }

  static Color getIconColor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.admin:
        return Colors.blue;
      case AppNotificationType.community:
        return AppColors.primary;
      case AppNotificationType.event:
        return Colors.green;
    }
  }
}
