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
// CONTOH HALAMAN DETAIL (DUMMY)
// ==============================
class DummySettingDetailPage extends StatelessWidget {
  final String title;
  const DummySettingDetailPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Halaman $title (frontend saja)',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
