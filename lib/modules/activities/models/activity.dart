import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rukunin/utils/date_formatter.dart';

class Activity {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final String imageUrl;
  final String organizerId;
  final String organizerName;
  final String organizerPosition;
  final List<String> participants;
  final DateTime createdAt;
  final String category;
  final Color categoryColor;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    this.imageUrl = '',
    required this.organizerId,
    required this.organizerName,
    required this.organizerPosition,
    this.participants = const [],
    DateTime? createdAt,
    this.category = 'Sosial',
    this.categoryColor = Colors.blue,
  }) : createdAt = createdAt ?? DateTime.now();

  // Getters for formatted date and time
  String get date => DateFormatter.formatFull(dateTime);
  String get time =>
      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  bool get isPast => dateTime.isBefore(DateTime.now());
  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  // Convert Activity to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dateTime': Timestamp.fromDate(dateTime),
      'location': location,
      'imageUrl': imageUrl,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'organizerPosition': organizerPosition,
      'participants': participants,
      'createdAt': Timestamp.fromDate(createdAt),
      'category': category,
      'categoryColorValue': categoryColor.value,
    };
  }

  // Create Activity from Firestore document
  factory Activity.fromMap(String id, Map<String, dynamic> map) {
    DateTime dateTime;
    if (map['dateTime'] is Timestamp) {
      dateTime = (map['dateTime'] as Timestamp).toDate();
    } else if (map['dateTime'] is String) {
      dateTime = DateTime.parse(map['dateTime']);
    } else {
      dateTime = DateTime.now();
    }

    DateTime createdAt;
    if (map['createdAt'] is Timestamp) {
      createdAt = (map['createdAt'] as Timestamp).toDate();
    } else if (map['createdAt'] is String) {
      createdAt = DateTime.parse(map['createdAt']);
    } else {
      createdAt = DateTime.now();
    }

    return Activity(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dateTime: dateTime,
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      organizerId: map['organizerId'] ?? '',
      organizerName: map['organizerName'] ?? '',
      organizerPosition: map['organizerPosition'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      createdAt: createdAt,
      category: map['category'] ?? 'Sosial',
      categoryColor: map['categoryColorValue'] != null
          ? Color(map['categoryColorValue'])
          : Colors.blue,
    );
  }

  // Copy with method for immutable updates
  Activity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? location,
    String? imageUrl,
    String? organizerId,
    String? organizerName,
    String? organizerPosition,
    List<String>? participants,
    DateTime? createdAt,
    String? category,
    Color? categoryColor,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      organizerPosition: organizerPosition ?? this.organizerPosition,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      categoryColor: categoryColor ?? this.categoryColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
