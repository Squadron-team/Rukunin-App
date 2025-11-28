import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/style/app_colors.dart';

class RoleManagementPage extends StatefulWidget {
  const RoleManagementPage({super.key});

  @override
  State<RoleManagementPage> createState() => _RoleManagementPageState();
}

class _RoleManagementPageState extends State<RoleManagementPage> {
  final List<Map<String, dynamic>> roles = [
    {
      'name': 'Admin Sistem',
      'icon': Icons.admin_panel_settings,
      'color': Colors.red,
      'description': 'Akses penuh ke seluruh sistem',
      'count': 2,
      'permissions': [
        'Kelola Pengguna',
        'Kelola Role',
        'Kelola Data',
        'Kelola Keuangan',
        'Kelola Laporan',
      ],
    },
    {
      'name': 'Ketua RT',
      'icon': Icons.supervised_user_circle,
      'color': Colors.blue,
      'description': 'Mengelola data RT',
      'count': 5,
      'permissions': [
        'Kelola Warga RT',
        'Kelola Kegiatan',
        'Lihat Laporan',
        'Verifikasi Data',
      ],
    },
    {
      'name': 'Ketua RW',
      'icon': Icons.account_balance,
      'color': Colors.purple,
      'description': 'Mengelola data RW',
      'count': 1,
      'permissions': [
        'Kelola Warga RW',
        'Kelola Kegiatan',
        'Lihat Laporan',
        'Verifikasi Data',
      ],
    },
    {
      'name': 'Bendahara',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
      'description': 'Mengelola keuangan dan iuran',
      'count': 3,
      'permissions': [
        'Kelola Iuran',
        'Kelola Kas',
        'Lihat Laporan Keuangan',
        'Verifikasi Pembayaran',
      ],
    },
    {
      'name': 'Sekretaris',
      'icon': Icons.description,
      'color': Colors.orange,
      'description': 'Mengelola administrasi dan arsip',
      'count': 2,
      'permissions': [
        'Kelola Pengumuman',
        'Kelola Surat',
        'Kelola Arsip',
        'Lihat Laporan',
      ],
    },
    {
      'name': 'Warga',
      'icon': Icons.person,
      'color': Colors.grey,
      'description': 'Akses terbatas untuk warga',
      'count': 1234,
      'permissions': [
        'Lihat Pengumuman',
        'Lihat Kegiatan',
        'Bayar Iuran',
        'Buat Laporan',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Role'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.security,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manajemen Role & Hak Akses',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Kelola role dan izin akses sistem',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Statistik Role
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.groups,
                      label: 'Total Role',
                      value: '6',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.people,
                      label: 'Total Admin',
                      value: '13',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Aksi Cepat
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/admin/akun'),
                      icon: const Icon(Icons.manage_accounts, size: 20),
                      label: const Text('Kelola Akun'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showAddRoleDialog(context),
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Tambah Role'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Daftar Role
              const Text(
                'Daftar Role Sistem',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  return _buildRoleCard(context, role);
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, Map<String, dynamic> role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: role['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(role['icon'], color: role['color'], size: 24),
          ),
          title: Text(
            role['name'],
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                role['description'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: role['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${role['count']} pengguna',
                  style: TextStyle(
                    fontSize: 11,
                    color: role['color'],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _showEditRoleDialog(context, role),
                icon: Icon(Icons.edit, size: 20, color: Colors.grey[600]),
              ),
              Icon(Icons.expand_more, color: Colors.grey[400]),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Izin Akses:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (role['permissions'] as List<String>).map((perm) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: role['color'],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              perm,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Role Baru'),
        content: const Text('Fitur ini akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showEditRoleDialog(BuildContext context, Map<String, dynamic> role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Role: ${role['name']}'),
        content: const Text('Fitur edit role akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
