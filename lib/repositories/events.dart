import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rukunin/models/event.dart';
import 'package:rukunin/style/app_colors.dart';

List<Event> events = [
  Event(
    category: 'Pendidikan',
    title: 'Pelatihan UMKM',
    location: 'Rumah Bu Rosi',
    date: DateFormat(
      'EEEE, dd MMM yyyy',
      'id_ID',
    ).format(DateTime.now().add(const Duration(days: -12))),
    time: '09.00 WIB',
    categoryColor: const Color(0xFFBDBDBD),
  ),
  Event(
    category: 'Sosial',
    title: 'Kerja Bakti',
    location: 'Balai Warga',
    date: DateFormat(
      'EEEE, dd MMM yyyy',
      'id_ID',
    ).format(DateTime.now().add(const Duration(days: -3))),
    time: '07.00 WIB',
    categoryColor: AppColors.primary,
  ),
  Event(
    title: 'Kerja Bakti Lingkungan',
    category: 'Sosial',
    categoryColor: Colors.green,
    date: DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(DateTime.now()),
    time: '07:00 - 10:00',
    location: 'Taman Warga RW 05',
  ),
  Event(
    title: 'Rapat RT Bulanan',
    category: 'Rapat',
    categoryColor: Colors.blue,
    date: DateFormat(
      'EEEE, dd MMM yyyy',
      'id_ID',
    ).format(DateTime.now().add(const Duration(days: 2))),
    time: '19:00 - 21:00',
    location: 'Balai RT 03',
  ),
  Event(
    title: 'Senam Sehat Bersama',
    category: 'Olahraga',
    categoryColor: Colors.orange,
    date: DateFormat(
      'EEEE, dd MMM yyyy',
      'id_ID',
    ).format(DateTime.now().add(const Duration(days: 2))),
    time: '06:00 - 07:30',
    location: 'Lapangan RW',
  ),
  Event(
    title: 'Pelatihan Kewirausahaan',
    category: 'Pendidikan',
    categoryColor: Colors.purple,
    date: DateFormat(
      'EEEE, dd MMM yyyy',
      'id_ID',
    ).format(DateTime.now().add(const Duration(days: 5))),
    time: '13:00 - 16:00',
    location: 'Balai RW 05',
  ),

  Event(
    title: 'Festival Seni & Budaya',
    category: 'Seni',
    categoryColor: Colors.pink,
    date: DateFormat(
      'EEEE, dd MMM yyyy',
      'id_ID',
    ).format(DateTime.now().add(const Duration(days: 7))),
    time: '15:00 - 20:00',
    location: 'Gedung Serbaguna',
  ),
];
