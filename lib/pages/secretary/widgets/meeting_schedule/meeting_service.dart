import 'package:rukunin/pages/secretary/widgets/meeting_schedule/meeting_model.dart';

class MeetingService {
  static final List<MeetingModel> _meetings = [];

  static List<MeetingModel> getMeetings() => _meetings;

  static void addMeeting(MeetingModel meeting) {
    _meetings.add(meeting);
  }

  static void updateMeeting(String id, MeetingModel updated) {
    final index = _meetings.indexWhere((m) => m.id == id);
    if (index != -1) _meetings[index] = updated;
  }

  static void deleteMeeting(String id) {
    _meetings.removeWhere((m) => m.id == id);
  }
}
