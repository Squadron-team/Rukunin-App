import 'package:flutter/material.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final String imageUrl;
  final String organizerId;
  final String organizerName;
  final String organizerPosition;
  final List<String> participants;
  final DateTime createdAt;
  final String category;
  final Color categoryColor;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.organizerId,
    required this.organizerName,
    required this.organizerPosition,
    required this.participants,
    required this.createdAt,
    this.category = 'Sosial',
    this.categoryColor = Colors.blue,
  });

  // Convert Event to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
      'imageUrl': imageUrl,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'organizerPosition': organizerPosition,
      'participants': participants,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
      'categoryColorValue': categoryColor.value,
    };
  }

  // Create Event from Firestore document
  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      organizerId: map['organizerId'] ?? '',
      organizerName: map['organizerName'] ?? '',
      organizerPosition: map['organizerPosition'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      category: map['category'] ?? 'Sosial',
      categoryColor: map['categoryColorValue'] != null
          ? Color(map['categoryColorValue'])
          : Colors.blue,
    );
  }

  // Copy with method for immutable updates
  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
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
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
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
}