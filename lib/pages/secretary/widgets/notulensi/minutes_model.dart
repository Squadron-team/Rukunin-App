class MinutesModel {
  final String id;
  final String title;
  final String date;
  final String participants;
  final String notes;

  MinutesModel({
    required this.id,
    required this.title,
    required this.date,
    required this.participants,
    required this.notes,
  });

  MinutesModel copyWith({
    String? title,
    String? date,
    String? participants,
    String? notes,
  }) {
    return MinutesModel(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      participants: participants ?? this.participants,
      notes: notes ?? this.notes,
    );
  }
}
