import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ==============================
// ROUTE (contoh penggunaan)
// ==============================
// GoRoute(
//   path: '/admin/system-settings',
//   name: 'admin-system-settings',
//   builder: (context, state) {
//     return const SystemSettingsPage();
//   },
// ),

class SystemSettingsPage extends StatelessWidget {
  const SystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Sistem'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionTitle(title: 'Umum'),
          _SettingTile(
            icon: Icons.apartment,
            title: 'Profil RW',
            subtitle: 'Nama RW, alamat, kontak',
            routeName: 'admin-system-profile',
          ),
          _SettingTile(
            icon: Icons.schedule,
            title: 'Jam Operasional',
            subtitle: 'Atur jam layanan RW',
            routeName: 'admin-system-operational-hours',
          ),

          SizedBox(height: 24),
          _SectionTitle(title: 'Keamanan'),
          _SettingTile(
            icon: Icons.lock,
            title: 'Keamanan Akun',
            subtitle: 'Password & autentikasi',
            routeName: 'admin-system-security',
          ),
          _SettingTile(
            icon: Icons.admin_panel_settings,
            title: 'Hak Akses',
            subtitle: 'Role admin & petugas',
            routeName: 'admin-system-roles',
          ),

          SizedBox(height: 24),
          _SectionTitle(title: 'Data & Sistem'),
          _SettingTile(
            icon: Icons.backup,
            title: 'Backup & Restore',
            subtitle: 'Cadangkan data sistem',
            routeName: 'admin-system-backup',
          ),
          _SettingTile(
            icon: Icons.history,
            title: 'Log Aktivitas',
            subtitle: 'Riwayat aktivitas admin',
            routeName: 'admin-system-logs',
          ),
        ],
      ),
    );
  }
}

// ==============================
// WIDGET KOMPONEN
// ==============================
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String routeName;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withOpacity(0.15),
          child: Icon(icon, color: Colors.orange),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.pushNamed(routeName);
        },
      ),
    );
  }
}

// ==============================
// ROUTE LOG AKTIVITAS (sesuai MenuItem)
// ==============================
// GoRoute(
//   path: '/admin/activity-logs',
//   name: 'admin-activity-logs',
//   builder: (context, state) {
//     return const ActivityLogPage();
//   },
// ),

// ==============================
// LOG AKTIVITAS PAGE
// ==============================

class ActivityLogPage extends StatelessWidget {
  const ActivityLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Aktivitas'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dummyLogs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final log = dummyLogs[index];
          return Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.withOpacity(0.15),
                child: Icon(log.icon, color: Colors.orange),
              ),
              title: Text(log.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(log.description),
                  const SizedBox(height: 6),
                  Text(
                    log.time,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==============================
// MODEL & DATA DUMMY
// ==============================
class ActivityLog {
  final IconData icon;
  final String title;
  final String description;
  final String time;

  ActivityLog({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
  });
}

final List<ActivityLog> dummyLogs = [
  ActivityLog(
    icon: Icons.login,
    title: 'Login Admin',
    description: 'Admin RW 05 berhasil login ke sistem',
    time: '18 Desember 2025 • 09:12',
  ),
  ActivityLog(
    icon: Icons.person_add,
    title: 'Tambah Warga',
    description: 'Menambahkan data warga baru: Ahmad Fauzi',
    time: '18 Desember 2025 • 08:45',
  ),
  ActivityLog(
    icon: Icons.edit_document,
    title: 'Update Data Kegiatan',
    description: 'Mengubah jadwal kerja bakti',
    time: '17 Desember 2025 • 19:30',
  ),
  ActivityLog(
    icon: Icons.backup,
    title: 'Backup Data',
    description: 'Backup data sistem berhasil',
    time: '17 Desember 2025 • 18:10',
  ),
];
