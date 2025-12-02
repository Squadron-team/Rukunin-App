import 'package:flutter/material.dart';

// Widgets
import 'package:rukunin/pages/secretary/widgets/meeting_schedule/meeting_item.dart';
import 'package:rukunin/pages/secretary/widgets/meeting_schedule/empty_meeting.dart';
import 'package:rukunin/pages/secretary/widgets/meeting_schedule/create_meeting_screen.dart';
import 'package:rukunin/pages/secretary/widgets/meeting_schedule/meeting_detail_page.dart';
import 'package:rukunin/pages/secretary/widgets/meeting_schedule/meeting_edit_form.dart';

class MeetingScheduleScreen extends StatefulWidget {
  const MeetingScheduleScreen({super.key});

  @override
  State<MeetingScheduleScreen> createState() => _MeetingScheduleScreenState();
}

class _MeetingScheduleScreenState extends State<MeetingScheduleScreen> {
  // Data rapat
  List<Map<String, String>> meetings = [
    {
      'title': 'Rapat Koordinasi Bulanan',
      'date': '03 Desember 2025',
      'time': '09.00 WIB',
      'location': 'Aula Balai Desa',
      'description': 'Membahas agenda bulanan dan evaluasi kinerja',
    },
    {
      'title': 'Pembahasan Anggaran Tahun 2026',
      'date': '10 Desember 2025',
      'time': '13.00 WIB',
      'location': 'Ruang Rapat Lantai 2',
      'description': 'Evaluasi serta penyusunan anggaran desa',
    },
  ];

  // Untuk pencarian
  List<Map<String, String>> filteredMeetings = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMeetings = meetings;
    searchController.addListener(_filterMeetings);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Filter pencarian
  void _filterMeetings() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredMeetings = meetings;
      } else {
        filteredMeetings = meetings.where((meeting) {
          return meeting['title']!.toLowerCase().contains(query) ||
              meeting['location']!.toLowerCase().contains(query) ||
              meeting['date']!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  // Navigasi ke detail rapat
  void _viewMeetingDetail(Map<String, String> meeting) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MeetingDetailPage(meeting: meeting)),
    );
  }

  // Navigasi edit rapat
  void _editMeeting(int index) async {
    // Cari index asli dari meeting yang akan diedit
    final meetingToEdit = filteredMeetings[index];
    final originalIndex = meetings.indexWhere(
      (m) =>
          m['title'] == meetingToEdit['title'] &&
          m['date'] == meetingToEdit['date'],
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MeetingEditForm(meeting: meetings[originalIndex]),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        meetings[originalIndex] = result;
        _filterMeetings(); // Update filtered list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rapat berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Tambah rapat baru
  void _addMeeting() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateMeetingScreen()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        meetings.add(result);
        _filterMeetings(); // Update filtered list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rapat berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Hapus rapat
  void _deleteMeeting(int index) {
    final meetingToDelete = filteredMeetings[index];
    final originalIndex = meetings.indexWhere(
      (m) =>
          m['title'] == meetingToDelete['title'] &&
          m['date'] == meetingToDelete['date'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Rapat'),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${meetingToDelete['title']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                meetings.removeAt(originalIndex);
                _filterMeetings();
              });
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rapat berhasil dihapus'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text('Jadwal Rapat'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.3,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMeeting,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Rapat'),
        backgroundColor: Colors.blue[700],
      ),

      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(14),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari jadwal rapat...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
                ),
              ),
            ),
          ),

          // Hasil pencarian info
          if (searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'Ditemukan ${filteredMeetings.length} rapat',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),

          const SizedBox(height: 8),

          // List rapat
          Expanded(
            child: filteredMeetings.isEmpty
                ? searchController.text.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada rapat ditemukan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const EmptyMeeting()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: filteredMeetings.length,
                    itemBuilder: (context, index) {
                      final meeting = filteredMeetings[index];

                      return MeetingItem(
                        title: meeting['title']!,
                        date: meeting['date']!,
                        time: meeting['time']!,
                        location: meeting['location']!,
                        onTap: () => _viewMeetingDetail(meeting),
                        onEdit: () => _editMeeting(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
