import 'package:flutter/material.dart';
import 'package:rukunin/models/event.dart';
import 'package:rukunin/pages/resident/resident_layout.dart';
import 'package:rukunin/pages/resident/events/event_detail_screen.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  // Sample event data - Replace with actual data from Firebase
  final Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadSampleEvents();
  }

  void _loadSampleEvents() {
    // Sample events - Replace with Firebase data
    final now = DateTime.now();
    
    _events[DateTime(now.year, now.month, now.day)] = [
      Event(
        title: 'Kerja Bakti Lingkungan',
        category: 'Sosial',
        categoryColor: Colors.green,
        date: DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(now),
        time: '07:00 - 10:00',
        location: 'Taman Warga RW 05',
      ),
    ];

    _events[DateTime(now.year, now.month, now.day + 2)] = [
      Event(
        title: 'Rapat RT Bulanan',
        category: 'Rapat',
        categoryColor: Colors.blue,
        date: DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(now.add(const Duration(days: 2))),
        time: '19:00 - 21:00',
        location: 'Balai RT 03',
      ),
      Event(
        title: 'Senam Sehat Bersama',
        category: 'Olahraga',
        categoryColor: Colors.orange,
        date: DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(now.add(const Duration(days: 2))),
        time: '06:00 - 07:30',
        location: 'Lapangan RW',
      ),
    ];

    _events[DateTime(now.year, now.month, now.day + 5)] = [
      Event(
        title: 'Pelatihan Kewirausahaan',
        category: 'Pendidikan',
        categoryColor: Colors.purple,
        date: DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(now.add(const Duration(days: 5))),
        time: '13:00 - 16:00',
        location: 'Balai RW 05',
      ),
    ];

    _events[DateTime(now.year, now.month, now.day + 7)] = [
      Event(
        title: 'Festival Seni & Budaya',
        category: 'Seni',
        categoryColor: Colors.pink,
        date: DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(now.add(const Duration(days: 7))),
        time: '15:00 - 20:00',
        location: 'Gedung Serbaguna',
      ),
    ];
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return ResidentLayout(
      title: 'Kegiatan Warga',
      currentIndex: 2,
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh from Firebase
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            _loadSampleEvents();
          });
        },
        child: SingleChildScrollView(
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
            color: Colors.black.withOpacity(0.06),
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
            color: AppColors.primary.withOpacity(0.3),
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
          markerDecoration: BoxDecoration(
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
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.chevron_left,
              color: AppColors.primary,
            ),
          ),
          rightChevronIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.chevron_right,
              color: AppColors.primary,
            ),
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
    final dateStr = DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
        .format(_selectedDay ?? _focusedDay);
    
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
                  color: AppColors.primary.withOpacity(0.15),
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
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: events.map((event) => _buildEventCard(event)).toList(),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: event.categoryColor.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative gradient
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      event.categoryColor.withOpacity(0.15),
                      event.categoryColor.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: event.categoryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getCategoryIcon(event.category),
                          size: 20,
                          color: event.categoryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: event.categoryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          event.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Event Title
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Time Info
                  _buildInfoRow(
                    Icons.access_time,
                    event.time,
                    Colors.green,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Location Info
                  _buildInfoRow(
                    Icons.location_on,
                    event.location,
                    AppColors.primary,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          event.categoryColor,
                          event.categoryColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lihat Detail',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_busy,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tidak Ada Kegiatan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada kegiatan yang dijadwalkan\npada tanggal ini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to suggest event or reload
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Fitur usulkan kegiatan akan segera tersedia'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Usulkan Kegiatan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'pendidikan':
        return Icons.school;
      case 'sosial':
        return Icons.people;
      case 'olahraga':
        return Icons.sports_soccer;
      case 'seni':
        return Icons.palette;
      case 'rapat':
        return Icons.meeting_room;
      default:
        return Icons.event;
    }
  }
}