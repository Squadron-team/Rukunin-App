import 'package:flutter/material.dart';

class Street {
  String name;
  int totalHouses;
  int paid;
  String status;
  Color statusColor;

  Street({
    required this.name,
    required this.totalHouses,
    this.paid = 0,
    this.status = '',
    this.statusColor = Colors.grey,
  });

  Street copyWith({
    String? name,
    int? totalHouses,
    int? paid,
    String? status,
    Color? statusColor,
  }) {
    return Street(
      name: name ?? this.name,
      totalHouses: totalHouses ?? this.totalHouses,
      paid: paid ?? this.paid,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
    );
  }
}
