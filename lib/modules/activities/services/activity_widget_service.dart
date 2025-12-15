import 'package:home_widget/home_widget.dart';
import 'package:rukunin/modules/activities/models/activity.dart';
import 'package:rukunin/utils/formatter/date_formatter.dart';

class ActivityWidgetService {
  static const String _widgetName = 'ActivityWidgetProvider';
  static const String _titleKey = 'widget_title';
  static const String _descriptionKey = 'widget_description';
  static const String _dateKey = 'widget_date';
  static const String _timeKey = 'widget_time';
  static const String _locationKey = 'widget_location';
  static const String _countKey = 'widget_count';
  static const String _currentDayKey = 'widget_current_day';
  static const String _currentMonthKey = 'widget_current_month';
  static const String _hasEventsKey = 'widget_has_events';
  static const String _nextTitleKey = 'widget_next_title';
  static const String _nextDateKey = 'widget_next_date';
  static const String _nextTimeKey = 'widget_next_time';

  Future<void> updateWidget(List<Activity> activities) async {
    try {
      final now = DateTime.now();
      await HomeWidget.saveWidgetData<int>(_currentDayKey, now.day);
      await HomeWidget.saveWidgetData<String>(
        _currentMonthKey,
        _getMonthName(now.month),
      );

      if (activities.isEmpty) {
        await _updateEmptyWidget();
      } else {
        final weekActivities = _getActivitiesThisWeek(activities);
        if (weekActivities.isEmpty) {
          await _updateEmptyWidget();
        } else {
          final currentActivity = weekActivities.first;
          final nextActivity = weekActivities.length > 1
              ? weekActivities[1]
              : null;
          await _updateWithActivities(
            currentActivity,
            nextActivity,
            weekActivities.length,
          );
        }
      }
      await HomeWidget.updateWidget(androidName: _widgetName);
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  List<Activity> _getActivitiesThisWeek(List<Activity> activities) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final weekActivities = activities.where((activity) {
      return activity.dateTime.isAfter(
            startOfWeek.subtract(const Duration(days: 1)),
          ) &&
          activity.dateTime.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();

    weekActivities.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return weekActivities;
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  Future<void> _updateWithActivities(
    Activity current,
    Activity? next,
    int totalCount,
  ) async {
    await HomeWidget.saveWidgetData<bool>(_hasEventsKey, true);
    await HomeWidget.saveWidgetData<String>(_titleKey, current.title);
    await HomeWidget.saveWidgetData<String>(
      _descriptionKey,
      current.description,
    );
    await HomeWidget.saveWidgetData<String>(
      _dateKey,
      DateFormatter.formatShort(current.dateTime),
    );
    await HomeWidget.saveWidgetData<String>(
      _timeKey,
      DateFormatter.formatTime(current.dateTime),
    );
    await HomeWidget.saveWidgetData<String>(_locationKey, current.location);
    await HomeWidget.saveWidgetData<int>(_countKey, totalCount);

    if (next != null) {
      await HomeWidget.saveWidgetData<String>(_nextTitleKey, next.title);
      await HomeWidget.saveWidgetData<String>(
        _nextDateKey,
        DateFormatter.formatShort(next.dateTime),
      );
      await HomeWidget.saveWidgetData<String>(
        _nextTimeKey,
        DateFormatter.formatTime(next.dateTime),
      );
    } else {
      await HomeWidget.saveWidgetData<String>(_nextTitleKey, '');
      await HomeWidget.saveWidgetData<String>(_nextDateKey, '');
      await HomeWidget.saveWidgetData<String>(_nextTimeKey, '');
    }
  }

  Future<void> _updateEmptyWidget() async {
    await HomeWidget.saveWidgetData<bool>(_hasEventsKey, false);
    await HomeWidget.saveWidgetData<String>(_titleKey, 'Tidak ada kegiatan');
    await HomeWidget.saveWidgetData<String>(
      _descriptionKey,
      'Belum ada kegiatan minggu ini',
    );
    await HomeWidget.saveWidgetData<String>(_dateKey, '');
    await HomeWidget.saveWidgetData<String>(_timeKey, '');
    await HomeWidget.saveWidgetData<String>(_locationKey, '');
    await HomeWidget.saveWidgetData<int>(_countKey, 0);
    await HomeWidget.saveWidgetData<String>(_nextTitleKey, '');
    await HomeWidget.saveWidgetData<String>(_nextDateKey, '');
    await HomeWidget.saveWidgetData<String>(_nextTimeKey, '');
  }

  Future<void> registerInteractivity() async {
    await HomeWidget.registerBackgroundCallback(backgroundCallback);
  }
}

@pragma('vm:entry-point')
void backgroundCallback(Uri? uri) async {
  if (uri?.host == 'refresh') {
    // Trigger refresh logic
  }
}
