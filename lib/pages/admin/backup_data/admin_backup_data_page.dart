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

class BackupDataPage extends StatefulWidget {
  const BackupDataPage({super.key});

  @override
  State<BackupDataPage> createState() => _BackupDataPageState();
}

class _BackupDataPageState extends State<BackupDataPage> {
  bool isBackingUp = false;

  void _startBackup() async {
    setState(() => isBackingUp = true);

    // simulasi proses backup
    await Future.delayed(const Duration(seconds: 2));

    setState(() => isBackingUp = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup data berhasil dibuat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup Data'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BackupInfoCard(),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isBackingUp ? null : _startBackup,
            icon: isBackingUp
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.backup),
            label: Text(
              isBackingUp ? 'Memproses Backup...' : 'Backup Sekarang',
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Riwayat Backup',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...dummyBackups.map((backup) => _BackupHistoryTile(backup)),
        ],
      ),
    );
  }
}

class _BackupInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.orange.withOpacity(0.1),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Backup data digunakan untuk menyimpan salinan data sistem RW secara aman.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackupHistoryTile extends StatelessWidget {
  final BackupHistory backup;
  const _BackupHistoryTile(this.backup);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.archive, color: Colors.orange),
        title: Text(backup.fileName),
        subtitle: Text(backup.date),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Download backup (dummy)')),
            );
          },
        ),
      ),
    );
  }
}

// ==============================
// MODEL & DATA DUMMY
// ==============================
class BackupHistory {
  final String fileName;
  final String date;

  BackupHistory({required this.fileName, required this.date});
}

final List<BackupHistory> dummyBackups = [
  BackupHistory(
    fileName: 'backup_rw05_18-12-2025.zip',
    date: '18 Desember 2025 • 09:30',
  ),
  BackupHistory(
    fileName: 'backup_rw05_17-12-2025.zip',
    date: '17 Desember 2025 • 18:10',
  ),
  BackupHistory(
    fileName: 'backup_rw05_16-12-2025.zip',
    date: '16 Desember 2025 • 20:05',
  ),
];

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
