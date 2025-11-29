class Meeting {
  final String id;
  final String title;
  final DateTime dateTime;
  final String location;
  final String description;
  int attendeesCount;
  bool isAttending;
  List<String> attendingRTs;
  final DateTime createdAt;

  Meeting({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.description,
    required this.createdAt,
    this.attendeesCount = 0,
    this.isAttending = false,
    this.attendingRTs = const [],
  });
}
