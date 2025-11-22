import 'package:flutter/material.dart';
import 'package:rukunin/modules/activities/models/event.dart';
import 'package:rukunin/modules/activities/widgets/event_card.dart';
import 'package:rukunin/modules/activities/services/firebase_event_service.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/utils/date_formatter.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final FirebaseEventService _eventService = FirebaseEventService();

  List<Event> _allEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  void _loadEvents() {
    _eventService.getEvents().listen(
      (events) {
        if (mounted) {
          setState(() {
            _allEvents = events;
            _isLoading = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading events: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    final dayStr = DateFormatter.formatFull(day);
    return _allEvents.where((event) => event.date == dayStr).toList();
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
          _loadEvents();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar Section
                    _buildCalendarSection(),

                    const SizedBox(height: 24),

                    // Selected Date Header
                    _buildSelectedDateHeader(),

                    const SizedBox(height: 16),

                    // Event List Section
                    _buildEventListSection(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        locale: 'id_ID',

        // Calendar Styling
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withAlpha(15),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          todayTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          outsideDaysVisible: false,
          markersMaxCount: 1,
          markerDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          markerSize: 6,
          markerMargin: const EdgeInsets.symmetric(horizontal: 1),
          cellMargin: const EdgeInsets.all(4),
        ),

        // Header Styling
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          leftChevronIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.chevron_left, color: AppColors.primary),
          ),
          rightChevronIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.chevron_right, color: AppColors.primary),
          ),
          headerPadding: const EdgeInsets.symmetric(vertical: 16),
        ),

        // Day of Week Styling
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
          weekendStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },

        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _buildSelectedDateHeader() {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);
    final dateStr = DateFormatter.formatFull(_selectedDay ?? _focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(38),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event_note,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      events.isEmpty
                          ? 'Tidak ada kegiatan'
                          : '${events.length} kegiatan terjadwal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventListSection() {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);

    if (events.isEmpty) {
      return const EventCard.empty();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: events
            .map((event) => EventCard.normal(event: event))
            .toList(),
      ),
    );
  }
}
