import 'package:flutter/material.dart';

class Event {
  final String category;
  final String title;
  final String location;
  final String date;
  final String time;
  final Color categoryColor;
  final String description;

  Event({
    required this.category,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.categoryColor,
    required this.description,
  });
}