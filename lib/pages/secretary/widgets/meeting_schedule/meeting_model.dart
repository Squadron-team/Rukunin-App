class MeetingModel {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;

  MeetingModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    this.description = '',
  });

  // Convert to Map
  Map<String, String> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'location': location,
      'description': description,
    };
  }

  // Create from Map
  factory MeetingModel.fromMap(Map<String, String> map) {
    return MeetingModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
    );
  }

  // Copy with method untuk update
  MeetingModel copyWith({
    String? id,
    String? title,
    String? date,
    String? time,
    String? location,
    String? description,
  }) {
    return MeetingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      description: description ?? this.description,
    );
  }
}
