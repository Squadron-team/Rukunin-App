import 'package:flutter/material.dart';
import 'package:rukunin/models/app_notification.dart';

final List<AppNotification> appNotifications = [
  AppNotification(
    type: AppNotificationType.community,
    icon: Icons.campaign,
    title: 'Perbaikan Jalan Gang 3',
    description:
        'Perbaikan jalan akan dilaksanakan pada 20 November 2025. Mohon kerjasama warga.',
    time: '2m ago',
    isRead: false,
  ),
  AppNotification(
    type: AppNotificationType.admin,
    icon: Icons.info_outline,
    title: 'Pembaruan Sistem',
    description:
        'Sistem aplikasi akan diperbarui pada malam ini pukul 23.00 WIB.',
    time: '1h ago',
    isRead: false,
  ),
  AppNotification(
    type: AppNotificationType.event,
    icon: Icons.event,
    title: 'Kerja Bakti Minggu Pagi',
    description:
        'Kerja bakti rutin akan diadakan hari Minggu, 17 November 2025 pukul 07.00.',
    time: '3h ago',
    isRead: true,
  ),
  AppNotification(
    type: AppNotificationType.admin,
    icon: Icons.payment,
    title: 'Pengingat Iuran Bulanan',
    description: 'Iuran bulan November akan jatuh tempo pada 30 November 2025.',
    time: '1d ago',
    isRead: false,
  ),
  AppNotification(
    type: AppNotificationType.community,
    icon: Icons.announcement,
    title: 'Pengumuman Rapat RT',
    description: 'Rapat RT akan diadakan Kamis, 21 November 2025 di Balai RW.',
    time: '2d ago',
    isRead: true,
  ),
  AppNotification(
    type: AppNotificationType.event,
    icon: Icons.celebration,
    title: '17 Agustus - Lomba Warga',
    description: 'Daftarkan diri Anda untuk mengikuti berbagai lomba menarik!',
    time: '3d ago',
    isRead: true,
  ),
];
